import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopvalut/core/cubits/theme/theme_cubit.dart';
import 'package:shopvalut/core/theme/app_colors.dart';
import 'package:shopvalut/core/theme/theme_extension.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});
  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final user = FirebaseAuth.instance.currentUser;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _dobCtrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: user?.displayName ?? '');
    _emailCtrl = TextEditingController(text: user?.email ?? '');
    _phoneCtrl = TextEditingController(text: '+20 ');
    _dobCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _dobCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty) {
      _showSnack('Name cannot be empty', isError: true);
      return;
    }
    setState(() => _isLoading = true);
    try {
      await user?.updateDisplayName(_nameCtrl.text.trim());
      if (mounted) {
        _showSnack('Profile updated successfully ✓');
        Navigator.pop(context);
      }
    } catch (e) {
      _showSnack('Failed to update: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: GoogleFonts.outfit()),
        backgroundColor: isError ? AppColors.red : AppColors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  String get _initials {
    final n = _nameCtrl.text.trim();
    if (n.isEmpty) return '?';
    final parts = n.split(' ');
    return parts.length >= 2
        ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
        : n[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, _) {
        return Scaffold(
          backgroundColor: context.bg,
          appBar: AppBar(
            backgroundColor: context.bg,
            elevation: 0,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
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
              'Edit Profile',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: context.textPrimary,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Gap(10),
                // ── Avatar ──
                Stack(
                  children: [
                    AnimatedBuilder(
                      animation: _nameCtrl,
                      builder: (_, _) => CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.gold,
                        child: Text(
                          _initials,
                          style: GoogleFonts.outfit(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: AppColors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: context.bg, width: 3),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(30),
                // ── Fields ──
                _field(context, 'Full Name', Icons.person_outline, _nameCtrl),
                const Gap(14),
                _field(
                  context,
                  'Email',
                  Icons.email_outlined,
                  _emailCtrl,
                  enabled: false,
                ),
                const Gap(14),
                _field(
                  context,
                  'Phone',
                  Icons.phone_outlined,
                  _phoneCtrl,
                  keyboard: TextInputType.phone,
                ),
                const Gap(14),
                _field(
                  context,
                  'Date of Birth',
                  Icons.calendar_today_outlined,
                  _dobCtrl,
                  keyboard: TextInputType.datetime,
                  hint: 'DD/MM/YYYY',
                ),
                const Gap(30),
                // ── Save button ──
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          )
                        : Text(
                            'Save Changes',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const Gap(20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _field(
    BuildContext c,
    String label,
    IconData icon,
    TextEditingController ctrl, {
    bool enabled = true,
    TextInputType keyboard = TextInputType.text,
    String? hint,
  }) => TextField(
    controller: ctrl,
    enabled: enabled,
    keyboardType: keyboard,
    style: GoogleFonts.outfit(
      fontSize: 14,
      color: enabled ? c.textPrimary : c.textHint,
    ),
    decoration: InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: GoogleFonts.outfit(fontSize: 13, color: c.textHint),
      hintStyle: GoogleFonts.outfit(fontSize: 13, color: c.textHint),
      prefixIcon: Icon(icon, color: c.textHint, size: 20),
      filled: true,
      fillColor: enabled ? c.inputFill : c.shimmer,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: c.border, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: c.border, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: c.border, width: 1.5),
      ),
    ),
  );
}
