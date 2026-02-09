import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:aelanji/core/widgets/custom_toast/custom_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:saver_gallery/saver_gallery.dart';

import '../../utils/app_strings.dart';
import 'app_premission_handler.dart';

class ImageHelper {
  static final ImagePicker _picker = ImagePicker();
  static final AppPermissionHandler _permissionHandler = AppPermissionHandler();

  static Future<File?> pickImage(BuildContext context) async {
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text(AppStrings.of(context).camera),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(AppStrings.of(context).gallery),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );

    if (source == null) return null;

    if (source == ImageSource.camera) {
      final bool hasPermission = await _permissionHandler
          .requestCameraPermissionWithBetterHandling(context: context);

      log('Camera permission status: $hasPermission');

      if (!hasPermission) {
        return null;
      }
    }

    return await _getImage(source);
  }

  static Future<File?> _getImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      return image != null ? File(image.path) : null;
    } catch (e) {
      log('Error picking image: $e');
      return null;
    }
  }

  /// Pick a single image from gallery or camera.
  /// Returns an XFile object for use with AddServicesBloc.
  static Future<XFile?> pickSingleImage(BuildContext context) async {
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text(AppStrings.of(context).camera),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(AppStrings.of(context).gallery),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );

    if (source == null) return null;

    if (source == ImageSource.camera) {
      final bool hasPermission = await _permissionHandler
          .requestCameraPermissionWithBetterHandling(context: context);

      log('Camera permission status: $hasPermission');

      if (!hasPermission) {
        return null;
      }
    }

    try {
      final XFile? image = await _picker.pickImage(source: source);
      return image;
    } catch (e) {
      log('Error picking single image: $e');
      return null;
    }
  }

  /// Pick multiple images from gallery or single image from camera.
  /// Returns a list of XFile objects that can be used with AddPhotosEvent.
  static Future<List<XFile>> pickMultipleImages(BuildContext context) async {
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text(AppStrings.of(context).camera),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(AppStrings.of(context).gallery),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );

    if (source == null) return [];

    if (source == ImageSource.camera) {
      final bool hasPermission = await _permissionHandler
          .requestCameraPermissionWithBetterHandling(context: context);

      log('Camera permission status: $hasPermission');

      if (!hasPermission) {
        return [];
      }

      // Camera only picks single image
      try {
        final XFile? image = await _picker.pickImage(source: source);
        return image != null ? [image] : [];
      } catch (e) {
        log('Error picking image from camera: $e');
        return [];
      }
    }

    // Gallery - pick multiple images
    try {
      final List<XFile> images = await _picker.pickMultiImage(limit: 10);
      return images;
    } catch (e) {
      log('Error picking images from gallery: $e');
      return [];
    }
  }

  /// Maximum image dimension (width or height) for compression
  static const int _maxImageDimension = 1024;

  /// JPEG compression quality (0-100)
  static const int _compressionQuality = 70;

  /// Compresses a File image with optional resizing.
  static Future<File> compressImage(File file) async {
    final bytes = await file.readAsBytes();
    final img.Image? image = img.decodeImage(bytes);

    if (image == null) return file;

    // Resize if needed (maintain aspect ratio)
    img.Image resized = image;
    if (image.width > _maxImageDimension || image.height > _maxImageDimension) {
      if (image.width > image.height) {
        resized = img.copyResize(image, width: _maxImageDimension);
      } else {
        resized = img.copyResize(image, height: _maxImageDimension);
      }
    }

    final compressedBytes = img.encodeJpg(
      resized,
      quality: _compressionQuality,
    );
    final compressedFile = File(file.path)..writeAsBytesSync(compressedBytes);
    return compressedFile;
  }

  /// Compresses an XFile image for upload.
  /// Returns a new compressed File in the temp directory.
  static Future<File> compressXFile(XFile xFile) async {
    final bytes = await xFile.readAsBytes();
    final img.Image? image = img.decodeImage(bytes);

    if (image == null) return File(xFile.path);

    // Resize if needed (maintain aspect ratio)
    img.Image resized = image;
    if (image.width > _maxImageDimension || image.height > _maxImageDimension) {
      if (image.width > image.height) {
        resized = img.copyResize(image, width: _maxImageDimension);
      } else {
        resized = img.copyResize(image, height: _maxImageDimension);
      }
    }

    final compressedBytes = img.encodeJpg(
      resized,
      quality: _compressionQuality,
    );

    // Write to temp file with unique name
    final tempDir = Directory.systemTemp;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final compressedFile = File('${tempDir.path}/compressed_$timestamp.jpg');
    await compressedFile.writeAsBytes(compressedBytes);

    return compressedFile;
  }

  static Future<void> saveNetworkImage({
    required BuildContext context,
    required String url,
  }) async {
    try {
      final hasPermission = await AppPermissionHandler()
          .checkAndRequestPermissions(skipIfExists: false);

      if (!hasPermission) {
        if (context.mounted) {
          CustomToast.error(
            context,
            AppStrings.of(context).permissionDeniedToSaveImageToGallery,
          );
        }
        return;
      }

      CustomToast.loading(
        context,
        dismissible: true,
        duration: const Duration(seconds: 2),
      );

      log('saveNetworkImage: $url');
      final response = await Dio().get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      bool result = false;

      if (Platform.isAndroid) {
        final saveResult = await SaverGallery.saveImage(
          Uint8List.fromList(response.data),
          quality: 80,
          fileName: 'Aelanji_${DateTime.now().millisecondsSinceEpoch}.jpg',
          androidRelativePath: 'Pictures/Aelanji',
          skipIfExists: false,
        );
        result = saveResult.isSuccess;
      } else {
        final saveResult = await SaverGallery.saveImage(
          Uint8List.fromList(response.data),
          quality: 80,
          fileName: 'Aelanji_${DateTime.now().millisecondsSinceEpoch}.jpg',
          androidRelativePath: 'Pictures/Aelanji',
          skipIfExists: false,
        );
        result = saveResult.isSuccess;
      }

      if (result) {
        CustomToast.success(context, AppStrings.of(context).savedToGallery);
      } else {
        CustomToast.error(context, AppStrings.of(context).failedToSaveImage);
      }

      log('result of save image is: $result');
    } catch (e) {
      log('Error saving image: $e');
      CustomToast.error(context, AppStrings.of(context).errorSavingImage);
    } finally {}
  }
}
