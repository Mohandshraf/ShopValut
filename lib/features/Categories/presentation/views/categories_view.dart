import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopvalut/core/cubits/theme/theme_cubit.dart';
import 'package:shopvalut/core/theme/theme_extension.dart';
import 'package:shopvalut/features/Categories/presentation/views/widgets/categories_view_body.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});
  @override
  Widget build(BuildContext context) => BlocBuilder<ThemeCubit, bool>(
    builder: (context, _) => Scaffold(backgroundColor: context.bg, body: const CategoriesViewBody()));
}
