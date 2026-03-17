import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopvalut/core/cubits/theme/theme_cubit.dart';
import 'package:shopvalut/core/theme/app_colors.dart';

extension ThemeExtension on BuildContext {
  bool get isDark => read<ThemeCubit>().isDarkMode;

  Color get bg => isDark ? AppColors.darkBg : AppColors.lightBg;
  Color get card => isDark ? AppColors.darkCard : AppColors.lightCard;
  Color get textPrimary => isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
  Color get textSecondary => isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
  Color get textHint => isDark ? AppColors.darkTextHint : AppColors.lightTextHint;
  Color get border => isDark ? AppColors.darkBorder : AppColors.lightBorder;
  Color get inputFill => isDark ? AppColors.darkInputFill : AppColors.lightInputFill;
  Color get shimmer => isDark ? AppColors.darkShimmer : AppColors.lightShimmer;
  Color get navBar => isDark ? const Color(0xFF1A1A1A) : Colors.white;
  Color get navBarBorder => isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE8E5E0);
  Color get iconColor => isDark ? const Color(0xFFE0E0E0) : const Color(0xFF1A1A1A);
}
