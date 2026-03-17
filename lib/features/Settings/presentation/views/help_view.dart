import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopvalut/core/cubits/theme/theme_cubit.dart';
import 'package:shopvalut/core/theme/app_colors.dart';
import 'package:shopvalut/core/theme/theme_extension.dart';

class HelpView extends StatefulWidget {
  const HelpView({super.key});
  @override
  State<HelpView> createState() => _HelpViewState();
}
class _HelpViewState extends State<HelpView> {
  int _expanded = -1;
  final _faqs = [
    {'q': 'How do I track my order?', 'a': 'Go to Profile → My Orders, then tap on the order you want to track. You\'ll see real-time status updates.'},
    {'q': 'What is the return policy?', 'a': 'You can return any item within 30 days of delivery. Items must be in original condition with tags attached.'},
    {'q': 'How do I apply a coupon?', 'a': 'In the cart, enter your coupon code in the field and tap "Apply". The discount will be reflected in your total.'},
    {'q': 'Is cash on delivery available?', 'a': 'Yes, cash on delivery is available for orders under \$500. A small COD fee may apply.'},
    {'q': 'How can I change my password?', 'a': 'Go to Profile → Settings → Change Password. You\'ll need to enter your current and new password.'},
  ];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(builder: (context, _) {
      return Scaffold(backgroundColor: context.bg, appBar: AppBar(backgroundColor: context.bg, elevation: 0,
        leading: GestureDetector(onTap: () => Navigator.pop(context), child: Container(margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: context.card, borderRadius: BorderRadius.circular(10), border: Border.all(color: context.border, width: 1.5)),
          child: Icon(Icons.arrow_back_ios_new, size: 16, color: context.iconColor))),
        title: Text('Help & Support', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: context.textPrimary)), centerTitle: true),
      body: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('FAQ', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: context.textPrimary)), const Gap(12),
        Container(decoration: BoxDecoration(color: context.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: context.border, width: 1)),
          child: Column(children: List.generate(_faqs.length, (i) => Column(children: [
            if (i > 0) Divider(height: 1, color: context.border, indent: 16, endIndent: 16),
            InkWell(onTap: () => setState(() => _expanded = _expanded == i ? -1 : i),
              child: Padding(padding: const EdgeInsets.all(16), child: Row(children: [
                Expanded(child: Text(_faqs[i]['q']!, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimary))),
                Icon(_expanded == i ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: context.textHint),
              ]))),
            if (_expanded == i) Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(_faqs[i]['a']!, style: GoogleFonts.outfit(fontSize: 13, color: context.textSecondary, height: 1.5))),
          ])))),
        const Gap(24),
        Text('Contact Us', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: context.textPrimary)), const Gap(12),
        _contact(context, Icons.email_outlined, AppColors.gold, 'Email', 'support@shopvault.com'),
        const Gap(8), _contact(context, Icons.phone_outlined, AppColors.green, 'Phone', '+20 123 456 789'),
        const Gap(8), _contact(context, Icons.chat_outlined, const Color(0xFF457B9D), 'Live Chat', 'Available 24/7'),
      ])));
    });
  }
  Widget _contact(BuildContext c, IconData icon, Color color, String title, String sub) => Container(padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: c.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: c.border, width: 1)),
    child: Row(children: [
      Container(width: 40, height: 40, decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 20)),
      const Gap(14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: c.textPrimary)),
        Text(sub, style: GoogleFonts.outfit(fontSize: 12, color: c.textHint)),
      ])), Icon(Icons.chevron_right, color: c.textHint, size: 20),
    ]));
}
