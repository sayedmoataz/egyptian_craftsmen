import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../features/home_screen/data/models/category_model.dart';
import '../bloc/category_details_bloc.dart';
import '../widgets/category_details_widget.dart';

class CategoryDetailsScreen extends StatelessWidget {
  final CategoryModel categoryModel;

  const CategoryDetailsScreen({required this.categoryModel, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CategoryDetailsBloc>(),
      child: Scaffold(
        body: SafeArea(
          child: CategoryDetailsWidget(categoryModel: categoryModel),
        ),
      ),
    );
  }
}
