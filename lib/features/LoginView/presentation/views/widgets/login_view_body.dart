import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopvalut/ForgotPassword/presentation/views/forgot_password_view.dart';
import 'package:shopvalut/core/cubits/theme/theme_cubit.dart';
import 'package:shopvalut/core/theme/app_colors.dart';
import 'package:shopvalut/core/theme/theme_extension.dart';
import 'package:shopvalut/core/services/auth_service.dart';
import 'package:shopvalut/features/Home/presentation/views/home_view.dart';
import 'package:shopvalut/features/SignUp/presentation/views/sign_up_view.dart';

class LoginViewBody extends StatefulWidget {
  const LoginViewBody({super.key});
  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<LoginViewBody> {
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() { _emailController.dispose(); _passwordController.dispose(); super.dispose(); }

  Future<void> _signInWithEmail() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) { _showError('Please fill in all fields'); return; }
    setState(() => _isLoading = true);
    try {
      final user = await _authService.signInWithEmail(_emailController.text.trim(), _passwordController.text);
      if (user != null && mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeView()));
    } catch (e) { _showError(e.toString()); } finally { if (mounted) setState(() => _isLoading = false); }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final user = await _authService.signInWithGoogle();
      if (user != null && mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeView()));
    } catch (e) { _showError(e.toString()); } finally { if (mounted) setState(() => _isLoading = false); }
  }

  void _showError(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red.shade400));

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
        Text("Welcome", style: GoogleFonts.playfairDisplay(fontSize: 32, fontWeight: FontWeight.bold, color: context.textPrimary)),
        Text("Back", style: GoogleFonts.playfairDisplay(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.gold)),
        const Gap(8),
        Text("Sign in to your account to continue shopping", style: GoogleFonts.outfit(fontSize: 14, color: context.textSecondary)),
        const Gap(40),
        TextField(controller: _emailController, keyboardType: TextInputType.emailAddress,
          style: GoogleFonts.outfit(fontSize: 14, color: context.textPrimary),
          decoration: _inputDec(context, "Email address", Icons.mail_outline)),
        const Gap(16),
        TextField(controller: _passwordController, obscureText: _obscurePassword,
          style: GoogleFonts.outfit(fontSize: 14, color: context.textPrimary),
          decoration: _inputDec(context, "Password", Icons.lock_outline,
            suffix: IconButton(icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: context.textHint, size: 20),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword)))),
        const Gap(8),
        Align(alignment: Alignment.centerRight, child: TextButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPasswordView())),
          child: Text("Forgot Password?", style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.gold)))),
        const Gap(16),
        SizedBox(width: double.infinity, height: 56, child: ElevatedButton(
          onPressed: _isLoading ? null : _signInWithEmail,
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
          child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : Text("Sign In", style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)))),
        const Gap(24),
        Row(children: [
          Expanded(child: Divider(color: context.border)),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text("OR", style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w500, color: context.textHint))),
          Expanded(child: Divider(color: context.border)),
        ]),
        const Gap(24),
        Row(children: [
          Expanded(child: SizedBox(height: 52, child: OutlinedButton.icon(
            onPressed: _isLoading ? null : _signInWithGoogle,
            icon: Image.asset('assets/images/google.png', width: 20, height: 20),
            label: Text("Google", style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w500, color: context.textPrimary)),
            style: OutlinedButton.styleFrom(backgroundColor: context.card,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              side: BorderSide(color: context.border, width: 1.5))))),
          const Gap(12),
          Expanded(child: SizedBox(height: 52, child: ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.apple, color: context.isDark ? Colors.black : Colors.white, size: 20),
            label: Text("Apple", style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w500, color: context.isDark ? Colors.black : Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: context.isDark ? Colors.white : const Color(0xFF1A1A1A),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0)))),
        ]),
        const Gap(30),
        Center(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("Don't have an account? ", style: GoogleFonts.outfit(fontSize: 14, color: context.textSecondary)),
          GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignUpView())),
            child: Text("Sign Up", style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.gold))),
        ])),
        const Gap(30),
      ]));
    });
  }
}
