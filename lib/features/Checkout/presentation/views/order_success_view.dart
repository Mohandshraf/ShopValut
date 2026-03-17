import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopvalut/core/cubits/theme/theme_cubit.dart';
import 'package:shopvalut/core/theme/app_colors.dart';
import 'package:shopvalut/core/theme/theme_extension.dart';
import 'package:shopvalut/features/Home/presentation/views/home_view.dart';

class OrderSuccessView extends StatelessWidget {
  final double total;
  const OrderSuccessView({super.key, required this.total});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(builder: (context, _) {
      return Scaffold(backgroundColor: context.bg,
        body: SafeArea(child: Center(child: Padding(padding: const EdgeInsets.all(30), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(width: 100, height: 100, decoration: BoxDecoration(color: AppColors.green.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: const Icon(Icons.check_circle, color: AppColors.green, size: 60)),
          const Gap(24),
          Text('Order Placed!', style: GoogleFonts.playfairDisplay(fontSize: 28, fontWeight: FontWeight.bold, color: context.textPrimary)),
          const Gap(8),
          Text('Your order #${DateTime.now().millisecondsSinceEpoch.toString().substring(7)} has been\nplaced successfully', textAlign: TextAlign.center,
            style: GoogleFonts.outfit(fontSize: 14, color: context.textSecondary)),
          const Gap(24),
          Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: context.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: context.border, width: 1)),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Total Paid', style: GoogleFonts.outfit(fontSize: 14, color: context.textSecondary)),
                Text('\$${total.toStringAsFixed(2)}', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.green))]),
              const Gap(10), Divider(color: context.border), const Gap(10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Est. Delivery', style: GoogleFonts.outfit(fontSize: 14, color: context.textSecondary)),
                Text('Mar 5 - Mar 7', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimary))]),
            ])),
          const Gap(40),
          SizedBox(width: double.infinity, height: 52, child: ElevatedButton(onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0),
            child: Text('Track Order', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)))),
          const Gap(12),
          TextButton(onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomeView()), (r) => false),
            child: Text('Continue Shopping', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.gold))),
        ])))));
    });
  }
}
