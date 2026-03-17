import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopvalut/core/cubits/theme/theme_cubit.dart';
import 'package:shopvalut/core/cubits/wishlist/wishlist_cubit.dart';
import 'package:shopvalut/core/cubits/wishlist/wishlist_state.dart';
import 'package:shopvalut/core/cubits/cart/cart_cubit.dart';
import 'package:shopvalut/core/theme/app_colors.dart';
import 'package:shopvalut/core/theme/theme_extension.dart';
import 'package:shopvalut/features/Home/data/models/product_model.dart';
import 'package:shopvalut/features/ProductDetails/presentation/views/product_details_view.dart';

class WishlistViewBody extends StatelessWidget {
  const WishlistViewBody({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, _) {
        return BlocBuilder<WishlistCubit, WishlistState>(
          builder: (context, state) {
            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          'My Wishlist',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: context.textPrimary,
                          ),
                        ),
                        const Gap(8),
                        const Icon(
                          Icons.favorite,
                          color: Color(0xFFE74C3C),
                          size: 22,
                        ),
                        const Gap(6),
                        Text(
                          '(${state.items.length} items)',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: context.textHint,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(16),
                  Expanded(
                    child: state.items.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: AppColors.red.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.favorite_border,
                                    size: 40,
                                    color: Color(0xFFE74C3C),
                                  ),
                                ),
                                const Gap(16),
                                Text(
                                  'Your wishlist is empty',
                                  style: GoogleFonts.outfit(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: context.textPrimary,
                                  ),
                                ),
                                const Gap(8),
                                Text(
                                  'Tap the heart icon on any product\nto add it to your wishlist',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.outfit(
                                    fontSize: 14,
                                    color: context.textHint,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 0.56,
                                ),
                            itemCount: state.items.length,
                            itemBuilder: (_, i) =>
                                _card(context, state.items[i]),
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _card(BuildContext c, ProductModel p) => GestureDetector(
    onTap: () => Navigator.push(
      c,
      MaterialPageRoute(builder: (_) => ProductDetailsView(product: p)),
    ),
    child: Container(
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.border, width: 1),
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
                  color: c.shimmer,
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
                        color: c.border,
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
                  onTap: () => c.read<WishlistCubit>().toggle(p),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: c.card,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.favorite,
                      size: 16,
                      color: Color(0xFFE74C3C),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
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
                      color: c.textPrimary,
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
                          color: c.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\$${p.price}',
                              style: GoogleFonts.outfit(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.green,
                              ),
                            ),
                            Text(
                              '\$${p.oldPrice}',
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                color: c.textHint,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          c.read<CartCubit>().addToCart(p);
                          ScaffoldMessenger.of(c).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Added to cart',
                                style: GoogleFonts.outfit(),
                              ),
                              backgroundColor: AppColors.green,
                              duration: const Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: Color(0xFF2D6A4F),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
