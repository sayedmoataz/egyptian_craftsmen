## --- Flutter Base Rules ---
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.editing.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class com.google.apphosting.datastore.** { *; }

## --- Firebase & Google Services ---
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

## --- Dio & Network (JSON Deserialization) ---
-keepattributes Signature, Exceptions, *Annotation*
-keep class com.codemonkeylabs.fpslibrary.** { *; }
-dontwarn okio.**
-dontwarn javax.annotation.**

## --- Flutter Secure Storage ---
-keep class com.it_nomads.fluttersecurestorage.** { *; }

## --- Local Notifications & Permissions ---
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-keep class com.baseflow.permissionhandler.** { *; }

## --- Package Info & Device Info Plus ---
-keep class dev.fluttercommunity.plus.packageinfo.** { *; }
-keep class dev.fluttercommunity.plus.device_info.** { *; }

## --- Path Provider ---
-keep class io.flutter.plugins.pathprovider.** { *; }

## --- GetIt & Dartz (Functional Programming) ---
-keep class com.baseflow.** { *; }

## --- General Rules to prevent breaking the app ---
-dontwarn io.flutter.embedding.engine.renderer.FlutterRenderer
-dontwarn android.net.http.SslError
-dontwarn android.webkit.**

## --- Play Core Library (Deferred Components) ---
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

## --- Firebase Cloud Messaging ---
-keepattributes SourceFile,LineNumberTable
-keep public class * extends com.google.firebase.messaging.FirebaseMessagingService
