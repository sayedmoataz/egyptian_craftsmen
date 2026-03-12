import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/bottom_bar/custom_bottom_bar.dart';
import '../bloc/home_screen_bloc.dart';
import '../widgets/home_page_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HomeScreenBloc>(),
      child: const Scaffold(
        backgroundColor: AppColors.background,
        bottomNavigationBar: CustomBottomBar(),
        body: SafeArea(child: HomePage()),
      ),
    );
  }
}
