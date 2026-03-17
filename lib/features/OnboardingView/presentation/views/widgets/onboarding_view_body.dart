import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopvalut/core/cubits/theme/theme_cubit.dart';
import 'package:shopvalut/core/theme/app_colors.dart';
import 'package:shopvalut/core/theme/theme_extension.dart';
import 'package:shopvalut/features/OnboardingView/data/models/onboarding_model.dart';
import 'package:shopvalut/features/LoginView/presentation/views/login_view.dart';

class OnboardingViewBody extends StatefulWidget {
  const OnboardingViewBody({super.key});
  @override
  State<OnboardingViewBody> createState() => _OnboardingViewBodyState();
}

class _OnboardingViewBodyState extends State<OnboardingViewBody> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingModel> pages = [
    OnboardingModel(icon: Icons.local_mall, title: "Discover Thousands of\nProducts",
      subtitle: "From electronics to fashion, home goods to beauty —\nfind everything you need in one place", color: Color(0xFFD4A674)),
    OnboardingModel(icon: Icons.local_shipping, title: "Fast & Free\nDelivery",
      subtitle: "Get your orders delivered straight to your\ndoorstep. Track every step of the way in real-time.", color: Color(0xFF2D6A4F)),
    OnboardingModel(icon: Icons.shield_outlined, title: "Safe & Secure\nPayments",
      subtitle: "Your payment information is encrypted and protected.\nShop with complete peace of mind.", color: Color(0xFF457B9D)),
  ];

  @override
  void dispose() { _pageController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(builder: (context, _) {
      return Stack(children: [
        Positioned(top: 0, left: 0, right: 0, bottom: 340,
          child: PageView.builder(controller: _pageController, onPageChanged: (i) => setState(() => _currentPage = i), itemCount: pages.length,
            itemBuilder: (context, index) => ListenableBuilder(listenable: _pageController, builder: (context, child) {
              double scale = 1.0, opacity = 1.0;
              if (_pageController.hasClients && _pageController.position.haveDimensions) {
                double page = _pageController.page ?? index.toDouble(); double offset = page - index;
                scale = (1.0 - (offset.abs() * 0.4)).clamp(0.5, 1.0); opacity = (1.0 - (offset.abs() * 0.5)).clamp(0.0, 1.0);
              }
              return Center(child: Opacity(opacity: opacity, child: Container(width: 140 * scale, height: 140 * scale,
                decoration: BoxDecoration(shape: BoxShape.circle, color: pages[index].color.withValues(alpha: 0.1)),
                child: Center(child: CircleAvatar(backgroundColor: pages[index].color, radius: 45 * scale,
                  child: Icon(pages[index].icon, color: Colors.white, size: 35 * scale))))));
            }))),
        Positioned(bottom: 0, left: 0, right: 0, child: Container(
          padding: const EdgeInsets.only(top: 30, bottom: 30),
          decoration: BoxDecoration(color: context.card, borderRadius: const BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32))),
          child: Column(children: [
            AnimatedSwitcher(duration: const Duration(milliseconds: 300),
              child: Text(pages[_currentPage].title, key: ValueKey(_currentPage), textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(color: context.textPrimary, fontWeight: FontWeight.w600, fontSize: 24))),
            const Gap(10),
            AnimatedSwitcher(duration: const Duration(milliseconds: 300),
              child: Text(pages[_currentPage].subtitle, key: ValueKey('sub_$_currentPage'), textAlign: TextAlign.center,
                style: GoogleFonts.outfit(color: context.textSecondary, fontWeight: FontWeight.w400, fontSize: 14))),
            const Gap(30),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(3, (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 300), margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == i ? 24 : 8, height: 8,
              decoration: BoxDecoration(color: _currentPage == i ? AppColors.gold : context.border, borderRadius: BorderRadius.circular(4))))),
            const Gap(30),
            if (_currentPage < 2) Align(alignment: Alignment.centerLeft, child: TextButton(
              onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginView())),
              child: Text("Skip", style: GoogleFonts.outfit(color: context.textHint, fontWeight: FontWeight.w500, fontSize: 14)))),
            if (_currentPage == 2) const Gap(48),
            const Gap(5),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: SizedBox(width: double.infinity, height: 56,
              child: ElevatedButton(
                onPressed: () { if (_currentPage < 2) { _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease); }
                  else { Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginView())); } },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: Text(_currentPage == 2 ? "Get Started" : "Next", style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16))))),
          ]))),
      ]);
    });
  }
}
