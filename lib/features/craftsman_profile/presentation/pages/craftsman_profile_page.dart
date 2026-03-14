import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/colors.dart';
import '../bloc/craftsman_profile_bloc.dart';
import '../widgets/craftsman_profile_widget.dart';

class CraftsmanProfilePage extends StatelessWidget {
  const CraftsmanProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold background color per Figma
    return BlocProvider(
      create: (context) => sl<CraftsmanProfileBloc>(),
      child: const Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(child: CraftsmanProfileWidget()),
      ),
    );
  }
}
