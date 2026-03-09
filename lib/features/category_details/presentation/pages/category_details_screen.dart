import 'package:flutter/material.dart';

import '../../../../features/home_screen/data/models/category_model.dart';
import '../widgets/category_details_widget.dart';

class CategoryDetailsScreen extends StatelessWidget {
  final CategoryModel categoryModel;

  const CategoryDetailsScreen({required this.categoryModel, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: CategoryDetailsWidget(categoryModel: categoryModel));
  }
}
