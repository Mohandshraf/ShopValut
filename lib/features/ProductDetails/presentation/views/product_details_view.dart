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

class ProductDetailsView extends StatefulWidget {
  final ProductModel product;
  const ProductDetailsView({super.key, required this.product});
  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  int _currentImage = 0;
  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, _) {
        return BlocBuilder<WishlistCubit, WishlistState>(
          builder: (context, _) {
            final wCubit = context.read<WishlistCubit>();
            final isW = wCubit.isInWishlist(p.id);
            return Scaffold(
              backgroundColor: context.bg,
              body: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height: 320,
                                  width: double.infinity,
                                  color: context.shimmer,
                                  child: PageView.builder(
                                    itemCount: 3,
                                    onPageChanged: (i) =>
                                        setState(() => _currentImage = i),
                                    itemBuilder: (_, i) => Image.network(
                                      p.imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, _, _) => Center(
                                        child: Icon(
                                          Icons.image_outlined,
                                          size: 80,
                                          color: context.border,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 12,
                                  left: 16,
                                  child: _btn(
                                    context,
                                    Icons.arrow_back_ios_new,
                                    () => Navigator.pop(context),
                                  ),
                                ),
                                Positioned(
                                  top: 12,
                                  right: 60,
                                  child: _btn(
                                    context,
                                    Icons.share_outlined,
                                    () {},
                                  ),
                                ),
                                Positioned(
                                  top: 12,
                                  right: 16,
                                  child: GestureDetector(
                                    onTap: () => wCubit.toggle(p),
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: context.card,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: context.border,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Icon(
                                        isW
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        size: 20,
                                        color: AppColors.red,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 12,
                                  left: 0,
                                  right: 0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      3,
                                      (i) => AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 3,
                                        ),
                                        width: _currentImage == i ? 24 : 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: _currentImage == i
                                              ? AppColors.gold
                                              : Colors.white54,
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Gap(20),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          p.name,
                                          style: GoogleFonts.cairo(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: context.textPrimary,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.red,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          '-${p.discount}%',
                                          style: GoogleFonts.outfit(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Gap(8),
                                  Row(
                                    children: [
                                      ...List.generate(
                                        5,
                                        (i) => Icon(
                                          i < p.rating.floor()
                                              ? Icons.star
                                              : Icons.star_border,
                                          size: 18,
                                          color: AppColors.starYellow,
                                        ),
                                      ),
                                      const Gap(8),
                                      Text(
                                        '${p.rating} (${p.reviews} reviews)',
                                        style: GoogleFonts.outfit(
                                          fontSize: 13,
                                          color: context.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Gap(16),
                                  Row(
                                    children: [
                                      Text(
                                        '\$${p.price}',
                                        style: GoogleFonts.outfit(
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.green,
                                        ),
                                      ),
                                      const Gap(10),
                                      Text(
                                        '\$${p.oldPrice}',
                                        style: GoogleFonts.outfit(
                                          fontSize: 16,
                                          color: context.textHint,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Gap(24),
                                  Text(
                                    'Description',
                                    style: GoogleFonts.outfit(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: context.textPrimary,
                                    ),
                                  ),
                                  const Gap(8),
                                  Text(
                                    p.description.isNotEmpty
                                        ? p.description
                                        : 'Premium quality product with exceptional design and durability.',
                                    style: GoogleFonts.outfit(
                                      fontSize: 14,
                                      color: context.textSecondary,
                                      height: 1.6,
                                    ),
                                  ),
                                  const Gap(24),
                                  Text(
                                    'Specifications',
                                    style: GoogleFonts.outfit(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: context.textPrimary,
                                    ),
                                  ),
                                  const Gap(8),
                                  _spec(context, 'Category', p.category, true),
                                  _spec(
                                    context,
                                    'Rating',
                                    '${p.rating}/5.0',
                                    false,
                                  ),
                                  _spec(
                                    context,
                                    'Reviews',
                                    '${p.reviews}',
                                    true,
                                  ),
                                  _spec(
                                    context,
                                    'Availability',
                                    'In Stock',
                                    false,
                                  ),
                                  const Gap(24),
                                  Text(
                                    'Reviews',
                                    style: GoogleFonts.outfit(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: context.textPrimary,
                                    ),
                                  ),
                                  const Gap(12),
                                  _review(
                                    context,
                                    'Ahmed M.',
                                    5,
                                    'Amazing product! Exactly as described.',
                                    '2 days ago',
                                  ),
                                  const Gap(8),
                                  _review(
                                    context,
                                    'Sara K.',
                                    4,
                                    'Great quality, fast delivery.',
                                    '1 week ago',
                                  ),
                                  const Gap(20),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: context.card,
                        border: Border(
                          top: BorderSide(color: context.border, width: 1),
                        ),
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Price',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  color: context.textHint,
                                ),
                              ),
                              Text(
                                '\$${p.price}',
                                style: GoogleFonts.outfit(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.green,
                                ),
                              ),
                            ],
                          ),
                          const Gap(20),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                context.read<CartCubit>().addToCart(p);
                                ScaffoldMessenger.of(context).showSnackBar(
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
                                height: 52,
                                decoration: BoxDecoration(
                                  color: AppColors.green,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.shopping_bag_outlined,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    const Gap(8),
                                    Text(
                                      'Add to Cart',
                                      style: GoogleFonts.outfit(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _btn(BuildContext c, IconData icon, VoidCallback onTap) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: c.card,
            shape: BoxShape.circle,
            border: Border.all(color: c.border, width: 1.5),
          ),
          child: Icon(icon, size: 18, color: c.iconColor),
        ),
      );
  Widget _spec(BuildContext c, String k, String v, bool alt) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    color: alt ? c.shimmer : Colors.transparent,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          k,
          style: GoogleFonts.outfit(fontSize: 13, color: c.textSecondary),
        ),
        Text(
          v,
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: c.textPrimary,
          ),
        ),
      ],
    ),
  );
  Widget _review(
    BuildContext c,
    String name,
    int stars,
    String text,
    String time,
  ) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: c.card,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: c.border, width: 1),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.gold.withValues(alpha: 0.2),
              child: Text(
                name[0],
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.gold,
                ),
              ),
            ),
            const Gap(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: c.textPrimary,
                    ),
                  ),
                  Row(
                    children: [
                      ...List.generate(
                        stars,
                        (_) => const Icon(
                          Icons.star,
                          size: 12,
                          color: Color(0xFFFFB800),
                        ),
                      ),
                      const Gap(6),
                      Text(
                        time,
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          color: c.textHint,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const Gap(8),
        Text(
          text,
          style: GoogleFonts.outfit(fontSize: 13, color: c.textSecondary),
        ),
      ],
    ),
  );
}
