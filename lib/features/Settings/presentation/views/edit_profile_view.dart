import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopvalut/core/cubits/theme/theme_cubit.dart';
import 'package:shopvalut/core/theme/app_colors.dart';
import 'package:shopvalut/core/theme/theme_extension.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final name = user?.displayName ?? 'User';
    final email = user?.email ?? '';
    final initials = name.split(' ').length >= 2 ? '${name.split(' ')[0][0]}${name.split(' ')[1][0]}'.toUpperCase() : name[0].toUpperCase();
    return BlocBuilder<ThemeCubit, bool>(builder: (context, _) {
      return Scaffold(backgroundColor: context.bg, appBar: AppBar(backgroundColor: context.bg, elevation: 0,
        leading: GestureDetector(onTap: () => Navigator.pop(context), child: Container(margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: context.card, borderRadius: BorderRadius.circular(10), border: Border.all(color: context.border, width: 1.5)),
          child: Icon(Icons.arrow_back_ios_new, size: 16, color: context.iconColor))),
        title: Text('Edit Profile', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: context.textPrimary)), centerTitle: true),
      body: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(children: [
        const Gap(10),
        Stack(children: [
          CircleAvatar(radius: 50, backgroundColor: AppColors.gold,
            child: Text(initials, style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white))),
          Positioned(bottom: 0, right: 0, child: Container(width: 34, height: 34,
            decoration: BoxDecoration(color: AppColors.green, shape: BoxShape.circle, border: Border.all(color: context.bg, width: 3)),
            child: const Icon(Icons.camera_alt, color: Colors.white, size: 16))),
        ]),
        const Gap(30),
        _field(context, 'Full Name', Icons.person_outline, name),
        const Gap(14), _field(context, 'Email', Icons.email_outlined, email, enabled: false),
        const Gap(14), _field(context, 'Phone', Icons.phone_outlined, '+20 '),
        const Gap(14), _field(context, 'Date of Birth', Icons.calendar_today_outlined, ''),
        const Gap(30),
        SizedBox(width: double.infinity, height: 52, child: ElevatedButton(onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0),
          child: Text('Save Changes', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)))),
      ])));
    });
  }
  Widget _field(BuildContext c, String label, IconData icon, String init, {bool enabled = true}) => TextField(
    controller: TextEditingController(text: init), enabled: enabled,
    style: GoogleFonts.outfit(fontSize: 14, color: enabled ? c.textPrimary : c.textHint),
    decoration: InputDecoration(labelText: label, labelStyle: GoogleFonts.outfit(fontSize: 13, color: c.textHint),
      prefixIcon: Icon(icon, color: c.textHint, size: 20), filled: true, fillColor: enabled ? c.inputFill : c.shimmer,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: c.border, width: 1.5)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: c.border, width: 1.5)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFD4A574), width: 1.5)),
      disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: c.border, width: 1.5))));
}
