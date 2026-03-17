import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopvalut/core/cubits/theme/theme_cubit.dart';
import 'package:shopvalut/core/theme/app_colors.dart';
import 'package:shopvalut/core/theme/theme_extension.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(builder: (context, _) {
      return Scaffold(backgroundColor: context.bg, appBar: AppBar(backgroundColor: context.bg, elevation: 0,
        leading: GestureDetector(onTap: () => Navigator.pop(context), child: Container(margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: context.card, borderRadius: BorderRadius.circular(10), border: Border.all(color: context.border, width: 1.5)),
          child: Icon(Icons.arrow_back_ios_new, size: 16, color: context.iconColor))),
        title: Text('About', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: context.textPrimary)), centerTitle: true),
      body: Center(child: Padding(padding: const EdgeInsets.all(30), child: Column(children: [
        const Gap(40),
        Container(width: 80, height: 80, decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(20)),
          child: const Icon(Icons.lock, color: Colors.white, size: 40)),
        const Gap(16), Text('ShopVault', style: GoogleFonts.playfairDisplay(fontSize: 28, fontWeight: FontWeight.bold, color: context.textPrimary)),
        const Gap(4), Text('Version 1.0.0', style: GoogleFonts.outfit(fontSize: 14, color: context.textHint)),
        const Gap(24), Text('Your premium shopping destination. Discover curated collections, exclusive deals, and seamless shopping experience.',
          textAlign: TextAlign.center, style: GoogleFonts.outfit(fontSize: 14, color: context.textSecondary, height: 1.6)),
        const Gap(32),
        _link(context, 'Terms of Service'), _link(context, 'Privacy Policy'), _link(context, 'Licenses'),
        const Spacer(),
        Text('Made with ♥ in Egypt', style: GoogleFonts.outfit(fontSize: 13, color: context.textHint)),
        const Gap(20),
      ]))));
    });
  }
  Widget _link(BuildContext c, String t) => InkWell(onTap: () {}, child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 14),
    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: c.border, width: 1))),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(t, style: GoogleFonts.outfit(fontSize: 14, color: c.textPrimary)), Icon(Icons.chevron_right, color: c.textHint, size: 20)])));
}
