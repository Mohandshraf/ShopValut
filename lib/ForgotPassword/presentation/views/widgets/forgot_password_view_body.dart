import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopvalut/core/cubits/theme/theme_cubit.dart';
import 'package:shopvalut/core/theme/app_colors.dart';
import 'package:shopvalut/core/theme/theme_extension.dart';
import 'package:shopvalut/core/services/auth_service.dart';

class ForgotPasswordViewBody extends StatefulWidget {
  const ForgotPasswordViewBody({super.key});
  @override
  State<ForgotPasswordViewBody> createState() => _ForgotPasswordViewBodyState();
}

class _ForgotPasswordViewBodyState extends State<ForgotPasswordViewBody> {
  final _authService = AuthService();
  final _emailController = TextEditingController();
  bool _isLoading = false, _emailSent = false;

  @override
  void dispose() { _emailController.dispose(); super.dispose(); }

  Future<void> _resetPassword() async {
    if (_emailController.text.isEmpty) { _showError('Please enter your email address'); return; }
    setState(() => _isLoading = true);
    try { await _authService.resetPassword(_emailController.text.trim()); if (mounted) setState(() => _emailSent = true);
    } catch (e) { _showError(e.toString()); } finally { if (mounted) setState(() => _isLoading = false); }
  }

  void _showError(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m), backgroundColor: Colors.red.shade400));

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(builder: (context, _) {
      return SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Gap(60),
        GestureDetector(onTap: () => Navigator.pop(context),
          child: Container(width: 40, height: 40, decoration: BoxDecoration(color: context.card, borderRadius: BorderRadius.circular(10), border: Border.all(color: context.border, width: 1.5)),
            child: Icon(Icons.arrow_back_ios_new, size: 16, color: context.iconColor))),
        const Gap(30),
        Text("Forgot", style: GoogleFonts.playfairDisplay(fontSize: 32, fontWeight: FontWeight.bold, color: context.textPrimary)),
        Text("Password?", style: GoogleFonts.playfairDisplay(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.gold)),
        const Gap(8),
        Text("Don't worry! Enter your email and we'll send you a link to reset your password.", style: GoogleFonts.outfit(fontSize: 14, color: context.textSecondary)),
        const Gap(40),
        if (!_emailSent) ...[
          TextField(controller: _emailController, keyboardType: TextInputType.emailAddress,
            style: GoogleFonts.outfit(fontSize: 14, color: context.textPrimary),
            decoration: InputDecoration(hintText: "Email address", hintStyle: GoogleFonts.outfit(fontSize: 14, color: context.textHint),
              prefixIcon: Icon(Icons.mail_outline, color: context.textHint, size: 20), filled: true, fillColor: context.inputFill,
              contentPadding: const EdgeInsets.symmetric(vertical: 18),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.border, width: 1.5)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.border, width: 1.5)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFD4A574), width: 1.5)))),
          const Gap(24),
          SizedBox(width: double.infinity, height: 56, child: ElevatedButton(
            onPressed: _isLoading ? null : _resetPassword,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
            child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : Text("Send Reset Link", style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)))),
        ] else ...[
          Container(width: double.infinity, padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: context.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: context.border, width: 1.5)),
            child: Column(children: [
              Container(width: 60, height: 60, decoration: BoxDecoration(color: AppColors.green.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: const Icon(Icons.mark_email_read_outlined, color: Color(0xFF2D6A4F), size: 30)),
              const Gap(16),
              Text("Check Your Email", style: GoogleFonts.playfairDisplay(fontSize: 20, fontWeight: FontWeight.bold, color: context.textPrimary)),
              const Gap(8),
              Text("We've sent a password reset link to\n${_emailController.text.trim()}", textAlign: TextAlign.center, style: GoogleFonts.outfit(fontSize: 14, color: context.textSecondary)),
              const Gap(24),
              SizedBox(width: double.infinity, height: 56, child: ElevatedButton(onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
                child: Text("Back to Sign In", style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)))),
              const Gap(12),
              GestureDetector(onTap: () => setState(() => _emailSent = false),
                child: Text("Didn't receive the email? Try again", style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.gold))),
            ])),
        ],
        const Gap(30),
        if (!_emailSent) Center(child: GestureDetector(onTap: () => Navigator.pop(context),
          child: RichText(text: TextSpan(style: GoogleFonts.outfit(fontSize: 14, color: context.textSecondary), children: [
            const TextSpan(text: "Remember your password? "),
            TextSpan(text: "Sign In", style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.gold)),
          ])))),
        const Gap(30),
      ]));
    });
  }
}
