import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopvalut/features/OnboardingView/presentation/views/onboarding_view.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody>
    with TickerProviderStateMixin {
  late AnimationController _logoScaleController;
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;

  late AnimationController _logoMoveController;
  late Animation<double> _logoMove;

  late AnimationController _nameController;
  late Animation<double> _nameFade;
  late Animation<double> _nameMove;

  late AnimationController _taglineController;
  late Animation<double> _taglineFade;
  late Animation<double> _taglineMove;

  @override
  void initState() {
    super.initState();

    _logoScaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _logoScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _logoScaleController, curve: Curves.ease),
    );
    _logoFade = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(parent: _logoScaleController, curve: Curves.ease),
    );

    _logoMoveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _logoMove = Tween<double>(
      begin: 0,
      end: -80,
    ).animate(CurvedAnimation(parent: _logoMoveController, curve: Curves.ease));

    _nameController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _nameFade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _nameController, curve: Curves.ease));
    _nameMove = Tween<double>(
      begin: 20,
      end: 0,
    ).animate(CurvedAnimation(parent: _nameController, curve: Curves.ease));

    _taglineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _taglineFade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _taglineController, curve: Curves.ease));
    _taglineMove = Tween<double>(
      begin: 20,
      end: 0,
    ).animate(CurvedAnimation(parent: _taglineController, curve: Curves.ease));

    _startAnimation();
  }

  void _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 300));
    await _logoScaleController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _logoMoveController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _nameController.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    await _taglineController.forward();
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingView()),
      );
    }
  }

  @override
  void dispose() {
    _logoScaleController.dispose();
    _logoMoveController.dispose();
    _nameController.dispose();
    _taglineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        _logoScaleController,
        _logoMoveController,
        _nameController,
        _taglineController,
      ]),
      builder: (context, child) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.translate(
                offset: Offset(0, _logoMove.value),
                child: Opacity(
                  opacity: _logoFade.value,
                  child: Transform.scale(
                    scale: _logoScale.value,
                    child: Image.asset("assets/images/lock.png", width: 100),
                  ),
                ),
              ),
              const Gap(16),
              Transform.translate(
                offset: Offset(0, _nameMove.value + _logoMove.value),
                child: Opacity(
                  opacity: _nameFade.value,
                  child: Text(
                    'ShopVault',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const Gap(5),
              Transform.translate(
                offset: Offset(0, _taglineMove.value + _logoMove.value),
                child: Opacity(
                  opacity: _taglineFade.value,
                  child: Text(
                    'Everything you need, one tap away',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
