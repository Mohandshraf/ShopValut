import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopvalut/core/cubits/theme/theme_cubit.dart';
import 'package:shopvalut/core/theme/theme_extension.dart';
import 'package:shopvalut/features/OnboardingView/presentation/views/widgets/onboarding_view_body.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});
  @override
  Widget build(BuildContext context) => BlocBuilder<ThemeCubit, bool>(
    builder: (context, _) => Scaffold(backgroundColor: context.bg, body: const OnboardingViewBody()));
}
