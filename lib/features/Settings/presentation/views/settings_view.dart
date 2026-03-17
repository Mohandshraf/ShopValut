import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopvalut/core/cubits/theme/theme_cubit.dart';
import 'package:shopvalut/core/theme/app_colors.dart';
import 'package:shopvalut/core/theme/theme_extension.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, _) {
        return Scaffold(
          backgroundColor: context.bg,
          appBar: _appBar(context),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _section(context, 'General', [
                  _item(
                    context,
                    Icons.language,
                    const Color(0xFF457B9D),
                    'Language',
                    trailing: 'English',
                  ),
                  _item(
                    context,
                    Icons.attach_money,
                    AppColors.green,
                    'Currency',
                    trailing: 'USD',
                  ),
                  _toggle(
                    context,
                    Icons.notifications_outlined,
                    AppColors.gold,
                    'Push Notifications',
                    true,
                  ),
                ]),
                const Gap(16),
                _section(context, 'Privacy & Security', [
                  _item(
                    context,
                    Icons.lock_outline,
                    AppColors.green,
                    'Change Password',
                  ),
                  _toggle(
                    context,
                    Icons.fingerprint,
                    const Color(0xFF457B9D),
                    'Biometric Login',
                    false,
                  ),
                ]),
                const Gap(16),
                _section(context, 'Data', [
                  _item(
                    context,
                    Icons.cached,
                    context.textSecondary,
                    'Clear Cache',
                  ),
                  _item(
                    context,
                    Icons.delete_forever,
                    AppColors.red,
                    'Delete Account',
                    isDestructive: true,
                  ),
                ]),
              ],
            ),
          ),
        );
      },
    );
  }

  AppBar _appBar(BuildContext c) => AppBar(
    backgroundColor: c.bg,
    elevation: 0,
    leading: GestureDetector(
      onTap: () => Navigator.pop(c),
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: c.card,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: c.border, width: 1.5),
        ),
        child: Icon(Icons.arrow_back_ios_new, size: 16, color: c.iconColor),
      ),
    ),
    title: Text(
      'Settings',
      style: GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: c.textPrimary,
      ),
    ),
    centerTitle: true,
  );
  Widget _section(BuildContext c, String title, List<Widget> items) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: c.textHint,
        ),
      ),
      const Gap(8),
      Container(
        decoration: BoxDecoration(
          color: c.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: c.border, width: 1),
        ),
        child: Column(
          children: List.generate(
            items.length * 2 - 1,
            (i) => i.isOdd
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Divider(height: 1, color: c.border),
                  )
                : items[i ~/ 2],
          ),
        ),
      ),
    ],
  );
  Widget _item(
    BuildContext c,
    IconData icon,
    Color color,
    String title, {
    String? trailing,
    bool isDestructive = false,
  }) => InkWell(
    onTap: () {},
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const Gap(14),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDestructive ? AppColors.red : c.textPrimary,
              ),
            ),
          ),
          if (trailing != null)
            Text(
              trailing,
              style: GoogleFonts.outfit(fontSize: 13, color: c.textHint),
            ),
          const Gap(4),
          Icon(Icons.chevron_right, color: c.textHint, size: 20),
        ],
      ),
    ),
  );
  Widget _toggle(
    BuildContext c,
    IconData icon,
    Color color,
    String title,
    bool val,
  ) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    child: Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const Gap(14),
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: c.textPrimary,
            ),
          ),
        ),
        Switch(value: val, onChanged: (_) {}, activeThumbColor: AppColors.gold),
      ],
    ),
  );
}
