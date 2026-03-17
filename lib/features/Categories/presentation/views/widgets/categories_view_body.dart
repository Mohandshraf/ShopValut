import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopvalut/core/cubits/theme/theme_cubit.dart';
import 'package:shopvalut/core/theme/theme_extension.dart';
import 'package:shopvalut/features/Categories/data/categories_data.dart';
import 'package:shopvalut/features/Categories/data/models/category_model.dart';
import 'package:shopvalut/features/Categories/presentation/views/category_products_view.dart';

class CategoriesViewBody extends StatefulWidget {
  const CategoriesViewBody({super.key});
  @override
  State<CategoriesViewBody> createState() => _CategoriesViewBodyState();
}

class _CategoriesViewBodyState extends State<CategoriesViewBody> {
  final _ctrl = TextEditingController();
  List<CategoryModel> _filtered = CategoriesData.categories;
  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _filter(String q) => setState(() {
    _filtered = q.isEmpty
        ? CategoriesData.categories
        : CategoriesData.categories
              .where((c) => c.name.toLowerCase().contains(q.toLowerCase()))
              .toList();
  });
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, _) {
        return SafeArea(
          child: Column(
            children: [
              const Gap(20),
              Text(
                'Categories',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: context.textPrimary,
                ),
              ),
              const Gap(16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _ctrl,
                  onChanged: _filter,
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    color: context.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search categories...',
                    hintStyle: GoogleFonts.outfit(
                      fontSize: 13,
                      color: context.textHint,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: context.textHint,
                      size: 20,
                    ),
                    filled: true,
                    fillColor: context.inputFill,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: context.border, width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: context.border, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: Color(0xFFD4A574),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              const Gap(20),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 1.3,
                  ),
                  itemCount: _filtered.length,
                  itemBuilder: (_, i) => GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CategoryProductsView(
                          categoryName: _filtered[i].name,
                        ),
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _filtered[i].color,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              _filtered[i].icon,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                          const Gap(10),
                          Text(
                            _filtered[i].name,
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
