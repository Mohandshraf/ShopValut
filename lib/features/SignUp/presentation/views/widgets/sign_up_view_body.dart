import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopvalut/core/cubits/theme/theme_cubit.dart';
import 'package:shopvalut/core/theme/app_colors.dart';
import 'package:shopvalut/core/theme/theme_extension.dart';
import 'package:shopvalut/core/services/auth_service.dart';

class SignUpViewBody extends StatefulWidget {
  const SignUpViewBody({super.key});
  @override
  State<SignUpViewBody> createState() => _SignUpViewBodyState();
}

class _SignUpViewBodyState extends State<SignUpViewBody> {
  final _authService = AuthService();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true, _obscureConfirm = true, _agreeTerms = false, _isLoading = false;

  @override
  void dispose() { _nameController.dispose(); _emailController.dispose(); _passwordController.dispose(); _confirmPasswordController.dispose(); super.dispose(); }

  Future<void> _signUp() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty || _confirmPasswordController.text.isEmpty) { _showError('Please fill in all fields'); return; }
    if (_passwordController.text != _confirmPasswordController.text) { _showError('Passwords do not match'); return; }
    if (!_agreeTerms) { _showError('Please agree to the Terms of Service'); return; }
    setState(() => _isLoading = true);
    try {
      final user = await _authService.signUpWithEmail(_emailController.text.trim(), _passwordController.text);
      if (user != null && mounted) { await user.updateDisplayName(_nameController.text.trim()); _showSuccess('Account created successfully!'); Navigator.pop(context); }
    } catch (e) { _showError(e.toString()); } finally { if (mounted) setState(() => _isLoading = false); }
  }

  void _showError(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m), backgroundColor: Colors.red.shade400));
  void _showSuccess(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m), backgroundColor: AppColors.green));

  InputDecoration _inputDec(BuildContext c, String hint, IconData icon, {Widget? suffix}) => InputDecoration(
    hintText: hint, hintStyle: GoogleFonts.outfit(fontSize: 14, color: c.textHint),
    prefixIcon: Icon(icon, color: c.textHint, size: 20), suffixIcon: suffix,
    filled: true, fillColor: c.inputFill, contentPadding: const EdgeInsets.symmetric(vertical: 18),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: c.border, width: 1.5)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: c.border, width: 1.5)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFD4A574), width: 1.5)));

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(builder: (context, _) {
      return SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Gap(80),
        Text("Create", style: GoogleFonts.playfairDisplay(fontSize: 32, fontWeight: FontWeight.bold, color: context.textPrimary)),
        Text("Account", style: GoogleFonts.playfairDisplay(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.gold)),
        const Gap(8),
        Text("Join ShopVault and start your shopping journey", style: GoogleFonts.outfit(fontSize: 14, color: context.textSecondary)),
        const Gap(40),
        TextField(controller: _nameController, style: GoogleFonts.outfit(fontSize: 14, color: context.textPrimary), decoration: _inputDec(context, "Full Name", Icons.person_outline)),
        const Gap(16),
        TextField(controller: _emailController, keyboardType: TextInputType.emailAddress, style: GoogleFonts.outfit(fontSize: 14, color: context.textPrimary), decoration: _inputDec(context, "Email address", Icons.mail_outline)),
        const Gap(16),
        TextField(controller: _passwordController, obscureText: _obscurePassword, style: GoogleFonts.outfit(fontSize: 14, color: context.textPrimary),
          decoration: _inputDec(context, "Password", Icons.lock_outline,
            suffix: IconButton(icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: context.textHint, size: 20),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword)))),
        const Gap(16),
        TextField(controller: _confirmPasswordController, obscureText: _obscureConfirm, style: GoogleFonts.outfit(fontSize: 14, color: context.textPrimary),
          decoration: _inputDec(context, "Confirm Password", Icons.lock_outline,
            suffix: IconButton(icon: Icon(_obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: context.textHint, size: 20),
              onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm)))),
        const Gap(16),
        Row(children: [
          SizedBox(width: 20, height: 20, child: Checkbox(value: _agreeTerms, onChanged: (v) => setState(() => _agreeTerms = v ?? false),
            activeColor: AppColors.gold, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)), side: BorderSide(color: context.border, width: 1.5))),
          const Gap(10),
          Expanded(child: RichText(text: TextSpan(style: GoogleFonts.outfit(fontSize: 12, color: context.textSecondary), children: [
            const TextSpan(text: "I agree to the "),
            TextSpan(text: "Terms of Service", style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.gold)),
            const TextSpan(text: " and "),
            TextSpan(text: "Privacy Policy", style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.gold)),
          ]))),
        ]),
        const Gap(24),
        SizedBox(width: double.infinity, height: 56, child: ElevatedButton(
          onPressed: _isLoading ? null : _signUp,
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
          child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : Text("Create Account", style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)))),
        const Gap(24),
        Center(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("Already have an account? ", style: GoogleFonts.outfit(fontSize: 14, color: context.textSecondary)),
          GestureDetector(onTap: () => Navigator.pop(context), child: Text("Sign In", style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.gold))),
        ])),
        const Gap(30),
      ]));
    });
  }
}
