import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopvalut/core/cubits/theme/theme_cubit.dart';
import 'package:shopvalut/core/cubits/cart/cart_cubit.dart';
import 'package:shopvalut/core/cubits/cart/cart_state.dart';
import 'package:shopvalut/core/theme/app_colors.dart';
import 'package:shopvalut/core/theme/theme_extension.dart';
import 'package:shopvalut/features/Checkout/presentation/views/checkout_view.dart';

class CartViewBody extends StatelessWidget {
  const CartViewBody({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, _) {
        return BlocBuilder<CartCubit, CartState>(
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
                          'My Cart',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: context.textPrimary,
                          ),
                        ),
                        const Gap(8),
                        const Icon(
                          Icons.shopping_bag,
                          color: Color(0xFF2D6A4F),
                          size: 22,
                        ),
                        const Gap(6),
                        Text(
                          '(${state.totalItems} items)',
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
                        ? _empty(context)
                        : _content(context, state),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _empty(BuildContext c) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.green.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.shopping_bag_outlined,
            size: 40,
            color: Color(0xFF2D6A4F),
          ),
        ),
        const Gap(16),
        Text(
          'Your cart is empty',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: c.textPrimary,
          ),
        ),
        const Gap(8),
        Text(
          'Add items to start shopping',
          style: GoogleFonts.outfit(fontSize: 14, color: c.textHint),
        ),
      ],
    ),
  );

  Widget _content(BuildContext c, CartState state) {
    final cart = c.read<CartCubit>();
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: state.items.length,
            itemBuilder: (_, i) {
              final item = state.items[i];
              final p = item.product;
              return Dismissible(
                key: Key(p.id),
                direction: DismissDirection.endToStart,
                onDismissed: (_) => cart.removeFromCart(p.id),
                background: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: AppColors.red,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.centerRight,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: c.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: c.border, width: 1),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          p.imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            width: 80,
                            height: 80,
                            color: c.shimmer,
                            child: Icon(Icons.image_outlined, color: c.border),
                          ),
                        ),
                      ),
                      const Gap(14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.cairo(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: c.textPrimary,
                              ),
                            ),
                            const Gap(4),
                            Text(
                              p.category,
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                color: c.textHint,
                              ),
                            ),
                            const Gap(6),
                            Text(
                              '\$${p.price}',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: c.border, width: 1.5),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  cart.updateQuantity(p.id, item.quantity - 1),
                              child: Container(
                                width: 32,
                                height: 32,
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.remove,
                                  size: 16,
                                  color: c.textSecondary,
                                ),
                              ),
                            ),
                            Container(
                              width: 32,
                              height: 32,
                              alignment: Alignment.center,
                              color: c.shimmer,
                              child: Text(
                                '${item.quantity}',
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: c.textPrimary,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  cart.updateQuantity(p.id, item.quantity + 1),
                              child: Container(
                                width: 32,
                                height: 32,
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.add,
                                  size: 16,
                                  color: Color(0xFF2D6A4F),
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
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: c.card,
            border: Border(top: BorderSide(color: c.border, width: 1)),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              _row(c, 'Subtotal', '\$${state.subtotal.toStringAsFixed(2)}'),
              const Gap(8),
              _row(c, 'Shipping', '\$${state.shipping.toStringAsFixed(2)}'),
              const Gap(8),
              Divider(color: c.border),
              const Gap(8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: c.textPrimary,
                    ),
                  ),
                  Text(
                    '\$${state.totalPrice.toStringAsFixed(2)}',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.green,
                    ),
                  ),
                ],
              ),
              const Gap(16),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    c,
                    MaterialPageRoute(builder: (_) => const CheckoutView()),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Proceed to Checkout',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _row(BuildContext c, String l, String v) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(l, style: GoogleFonts.outfit(fontSize: 14, color: c.textSecondary)),
      Text(
        v,
        style: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: c.textPrimary,
        ),
      ),
    ],
  );
}
