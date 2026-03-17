import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopvalut/core/cubits/theme/theme_cubit.dart';
import 'package:shopvalut/core/cubits/cart/cart_cubit.dart';
import 'package:shopvalut/core/cubits/cart/cart_state.dart';
import 'package:shopvalut/core/theme/app_colors.dart';
import 'package:shopvalut/core/theme/theme_extension.dart';
import 'package:shopvalut/features/Checkout/presentation/views/order_success_view.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});
  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  int _step = 0;
  int _paymentMethod = 0;
  final _steps = ['Shipping', 'Payment', 'Review'];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, _) {
        return BlocBuilder<CartCubit, CartState>(
          builder: (context, cart) {
            return Scaffold(
              backgroundColor: context.bg,
              appBar: AppBar(
                backgroundColor: context.bg,
                elevation: 0,
                leading: GestureDetector(
                  onTap: () {
                    if (_step > 0) {
                      setState(() => _step--);
                    } else {
                      Navigator.pop(context);
                    }
                  },
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
                  'Checkout',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary,
                  ),
                ),
                centerTitle: true,
              ),
              body: Column(
                children: [
                  const Gap(8),
                  _stepper(context),
                  const Gap(20),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _step == 0
                          ? _shippingStep(context)
                          : _step == 1
                          ? _paymentStep(context)
                          : _reviewStep(context, cart),
                    ),
                  ),
                  _bottomBar(context, cart),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _stepper(BuildContext c) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 40),
    child: Row(
      children: List.generate(5, (i) {
        if (i.isOdd)
          return Expanded(
            child: Container(
              height: 2,
              color: i ~/ 2 < _step ? AppColors.green : c.border,
            ),
          );
        final si = i ~/ 2;
        final done = si < _step;
        final active = si == _step;
        return Column(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: done
                    ? AppColors.green
                    : active
                    ? AppColors.gold
                    : Colors.transparent,
                border: Border.all(
                  color: done
                      ? AppColors.green
                      : active
                      ? AppColors.gold
                      : c.border,
                  width: 2,
                ),
              ),
              child: Center(
                child: done
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : Text(
                        '${si + 1}',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: active ? Colors.white : c.textHint,
                        ),
                      ),
              ),
            ),
            const Gap(4),
            Text(
              _steps[si],
              style: GoogleFonts.outfit(
                fontSize: 11,
                color: active ? AppColors.gold : c.textHint,
              ),
            ),
          ],
        );
      }),
    ),
  );

  Widget _shippingStep(BuildContext c) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Shipping Address',
        style: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: c.textPrimary,
        ),
      ),
      const Gap(12),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: c.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.gold, width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.location_on,
                color: AppColors.red,
                size: 22,
              ),
            ),
            const Gap(14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Home',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: c.textPrimary,
                    ),
                  ),
                  const Gap(2),
                  Text(
                    '123 Main Street, Apt 4B',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      color: c.textSecondary,
                    ),
                  ),
                  Text(
                    'Cairo, Egypt • +20 123 456 789',
                    style: GoogleFonts.outfit(fontSize: 12, color: c.textHint),
                  ),
                ],
              ),
            ),
            Text(
              'Change',
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.gold,
              ),
            ),
          ],
        ),
      ),
      const Gap(20),
      Text(
        'Delivery Method',
        style: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: c.textPrimary,
        ),
      ),
      const Gap(12),
      _deliveryOption(
        c,
        'Standard Delivery',
        '3-5 business days',
        '\$9.99',
        true,
      ),
      const Gap(8),
      _deliveryOption(
        c,
        'Express Delivery',
        '1-2 business days',
        '\$19.99',
        false,
      ),
    ],
  );

  Widget _deliveryOption(
    BuildContext c,
    String title,
    String time,
    String price,
    bool sel,
  ) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: c.card,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(
        color: sel ? AppColors.gold : c.border,
        width: sel ? 2 : 1,
      ),
    ),
    child: Row(
      children: [
        Icon(
          sel ? Icons.radio_button_checked : Icons.radio_button_off,
          color: sel ? AppColors.gold : c.textHint,
          size: 22,
        ),
        const Gap(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: c.textPrimary,
                ),
              ),
              Text(
                time,
                style: GoogleFonts.outfit(fontSize: 12, color: c.textHint),
              ),
            ],
          ),
        ),
        Text(
          price,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.green,
          ),
        ),
      ],
    ),
  );

  Widget _paymentStep(BuildContext c) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Select Payment',
        style: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: c.textPrimary,
        ),
      ),
      const Gap(12),
      ...[
        {
          'icon': Icons.credit_card,
          'title': 'Credit / Debit Card',
          'sub': '**** 4532',
        },
        {
          'icon': Icons.account_balance_wallet,
          'title': 'PayPal',
          'sub': 'mohand@email.com',
        },
        {
          'icon': Icons.money,
          'title': 'Cash on Delivery',
          'sub': 'Pay when delivered',
        },
      ].asMap().entries.map((e) {
        final i = e.key;
        final m = e.value;
        final sel = _paymentMethod == i;
        return GestureDetector(
          onTap: () => setState(() => _paymentMethod = i),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: c.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: sel ? AppColors.gold : c.border,
                width: sel ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: (sel ? AppColors.gold : c.textHint).withValues(
                      alpha: 0.1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    m['icon'] as IconData,
                    color: sel ? AppColors.gold : c.textHint,
                    size: 22,
                  ),
                ),
                const Gap(14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        m['title'] as String,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: c.textPrimary,
                        ),
                      ),
                      Text(
                        m['sub'] as String,
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: c.textHint,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  sel ? Icons.check_circle : Icons.circle_outlined,
                  color: sel ? AppColors.gold : c.border,
                  size: 24,
                ),
              ],
            ),
          ),
        );
      }),
    ],
  );

  Widget _reviewStep(BuildContext c, CartState cart) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Order Summary',
        style: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: c.textPrimary,
        ),
      ),
      const Gap(12),
      ...cart.items.map(
        (item) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: c.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: c.border, width: 1),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  item.product.imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) =>
                      Container(width: 50, height: 50, color: c.shimmer),
                ),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.cairo(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: c.textPrimary,
                      ),
                    ),
                    Text(
                      'Qty: ${item.quantity}',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: c.textHint,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '\$${item.total.toStringAsFixed(2)}',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.green,
                ),
              ),
            ],
          ),
        ),
      ),
      const Gap(16),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: c.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: c.border, width: 1),
        ),
        child: Column(
          children: [
            _row(c, 'Subtotal', '\$${cart.subtotal.toStringAsFixed(2)}'),
            const Gap(6),
            _row(c, 'Shipping', '\$${cart.shipping.toStringAsFixed(2)}'),
            const Gap(6),
            Divider(color: c.border),
            const Gap(6),
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
                  '\$${cart.totalPrice.toStringAsFixed(2)}',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );

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

  Widget _bottomBar(BuildContext c, CartState cart) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: c.card,
      border: Border(top: BorderSide(color: c.border, width: 1)),
    ),
    child: SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {
          if (_step < 2) {
            setState(() => _step++);
          } else {
            c.read<CartCubit>().clear();
            Navigator.pushReplacement(
              c,
              MaterialPageRoute(
                builder: (_) => OrderSuccessView(total: cart.totalPrice),
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        child: Text(
          _step == 2 ? 'Place Order' : 'Continue',
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}
