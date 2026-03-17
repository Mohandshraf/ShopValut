import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopvalut/core/cubits/theme/theme_cubit.dart';
import 'package:shopvalut/core/cubits/wishlist/wishlist_cubit.dart';
import 'package:shopvalut/core/cubits/wishlist/wishlist_state.dart';
import 'package:shopvalut/core/theme/app_colors.dart';
import 'package:shopvalut/core/theme/theme_extension.dart';
import 'package:shopvalut/features/Home/data/dummy_data.dart';
import 'package:shopvalut/features/Home/data/models/product_model.dart';
import 'package:shopvalut/features/ProductDetails/presentation/views/product_details_view.dart';

class CategoryProductsView extends StatelessWidget {
  final String categoryName;
  const CategoryProductsView({super.key, required this.categoryName});
  @override
  Widget build(BuildContext context) {
    final products = [
      ...DummyData.flashDeals,
      ...DummyData.popular,
    ].where((p) => p.category == categoryName).toList();
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, _) {
        return Scaffold(
          backgroundColor: context.bg,
          appBar: AppBar(
            backgroundColor: context.bg,
            elevation: 0,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: context.card,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: context.border, width: 1.5),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  size: 16,
                  color: context.iconColor,
                ),
              ),
            ),
            title: Text(
              categoryName,
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: context.textPrimary,
              ),
            ),
            centerTitle: true,
          ),
          body: products.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 60,
                        color: context.border,
                      ),
                      const Gap(12),
                      Text(
                        'No products yet',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          color: context.textHint,
                        ),
                      ),
                    ],
                  ),
                )
              : BlocBuilder<WishlistCubit, WishlistState>(
                  builder: (context, _) => GridView.builder(
                    padding: const EdgeInsets.all(20),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.58,
                        ),
                    itemCount: products.length,
                    itemBuilder: (_, i) {
                      final p = products[i];
                      final isW = context.read<WishlistCubit>().isInWishlist(
                        p.id,
                      );
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetailsView(product: p),
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: context.card,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: context.border, width: 1),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: 140,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: context.shimmer,
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(16),
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(16),
                                      ),
                                      child: Image.network(
                                        p.imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, _, _) => Center(
                                          child: Icon(
                                            Icons.image_outlined,
                                            size: 50,
                                            color: context.border,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    left: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.red,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '-${p.discount}%',
                                        style: GoogleFonts.outfit(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () => context
                                          .read<WishlistCubit>()
                                          .toggle(p),
                                      child: Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: context.card,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.08,
                                              ),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          isW
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          size: 16,
                                          color: AppColors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      p.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.cairo(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: context.textPrimary,
                                      ),
                                    ),
                                    const Gap(4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          size: 14,
                                          color: Color(0xFFFFB800),
                                        ),
                                        const Gap(4),
                                        Text(
                                          '${p.rating} (${p.reviews})',
                                          style: GoogleFonts.outfit(
                                            fontSize: 11,
                                            color: context.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Gap(6),
                                    Row(
                                      children: [
                                        Text(
                                          '\$${p.price}',
                                          style: GoogleFonts.outfit(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.green,
                                          ),
                                        ),
                                        const Gap(6),
                                        Text(
                                          '\$${p.oldPrice}',
                                          style: GoogleFonts.outfit(
                                            fontSize: 11,
                                            color: context.textHint,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
        );
      },
    );
  }
}
