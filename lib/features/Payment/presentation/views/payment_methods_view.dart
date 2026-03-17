import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopvalut/core/cubits/theme/theme_cubit.dart';
import 'package:shopvalut/core/theme/app_colors.dart';
import 'package:shopvalut/core/theme/theme_extension.dart';

class PaymentMethodsView extends StatefulWidget {
  const PaymentMethodsView({super.key});
  @override
  State<PaymentMethodsView> createState() => _PaymentMethodsViewState();
}

class _PaymentMethodsViewState extends State<PaymentMethodsView> {
  int _selected = 0;
  final _cards = [
    {'brand': 'Visa', 'last4': '4532', 'holder': 'MOHAND', 'expiry': '12/28', 'gradient': [const Color(0xFF1A1A2E), const Color(0xFF16213E)]},
    {'brand': 'Mastercard', 'last4': '8721', 'holder': 'MOHAND', 'expiry': '08/27', 'gradient': [const Color(0xFF2D6A4F), const Color(0xFF1B4332)]},
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(builder: (context, _) {
      return Scaffold(backgroundColor: context.bg,
        appBar: AppBar(backgroundColor: context.bg, elevation: 0,
          leading: GestureDetector(onTap: () => Navigator.pop(context), child: Container(margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: context.card, borderRadius: BorderRadius.circular(10), border: Border.all(color: context.border, width: 1.5)),
            child: Icon(Icons.arrow_back_ios_new, size: 16, color: context.iconColor))),
          title: Text('Payment Methods', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: context.textPrimary)), centerTitle: true),
        body: ListView(padding: const EdgeInsets.all(20), children: [
          ...List.generate(_cards.length, (i) {
            final c = _cards[i]; final sel = _selected == i;
            return GestureDetector(onTap: () => setState(() => _selected = i),
              child: Container(margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.all(20), height: 190,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(colors: c['gradient'] as List<Color>, begin: Alignment.topLeft, end: Alignment.bottomRight),
                  border: sel ? Border.all(color: AppColors.gold, width: 2.5) : null,
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 12, offset: const Offset(0, 6))]),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(c['brand'] as String, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    if (sel) const Icon(Icons.check_circle, color: AppColors.gold, size: 24)]),
                  const Spacer(),
                  Text('**** **** **** ${c['last4']}', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white, letterSpacing: 2)),
                  const Gap(16),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('CARD HOLDER', style: GoogleFonts.outfit(fontSize: 10, color: Colors.white54)),
                      Text(c['holder'] as String, style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white))]),
                    Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Text('EXPIRES', style: GoogleFonts.outfit(fontSize: 10, color: Colors.white54)),
                      Text(c['expiry'] as String, style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white))]),
                  ])])));
          }),
          const Gap(8),
          GestureDetector(onTap: () {},
            child: Container(padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.gold.withValues(alpha: 0.4), width: 1.5)),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.add_circle_outline, color: AppColors.gold, size: 22), const Gap(10),
                Text('Add Payment Method', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.gold))]))),
        ]));
    });
  }
}
