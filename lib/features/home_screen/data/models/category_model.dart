import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CategoryModel extends Equatable {
  final String title;
  final IconData icon;
  final bool isViewAll;

  const CategoryModel({
    required this.title,
    required this.icon,
    this.isViewAll = false,
  });

  @override
  List<Object?> get props => [title, icon, isViewAll];
}
