import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopvalut/core/cubits/theme/theme_cubit.dart';
import 'package:shopvalut/core/cubits/wishlist/wishlist_cubit.dart';
import 'package:shopvalut/core/cubits/wishlist/wishlist_state.dart';
import 'package:shopvalut/core/theme/app_colors.dart';
import 'package:shopvalut/core/theme/theme_extension.dart';
import 'package:shopvalut/core/services/auth_service.dart';
import 'package:shopvalut/features/LoginView/presentation/views/login_view.dart';
import 'package:shopvalut/features/Settings/presentation/views/settings_view.dart';
import 'package:shopvalut/features/Settings/presentation/views/about_view.dart';
import 'package:shopvalut/features/Settings/presentation/views/help_view.dart';
import 'package:shopvalut/features/Settings/presentation/views/edit_profile_view.dart';
import 'package:shopvalut/features/Orders/presentation/views/my_orders_view.dart';
import 'package:shopvalut/features/Addresses/presentation/views/addresses_view.dart';
import 'package:shopvalut/features/Payment/presentation/views/payment_methods_view.dart';
import 'package:shopvalut/features/Coupons/presentation/views/coupons_view.dart';

class ProfileViewBody extends StatefulWidget {
  const ProfileViewBody({super.key});
  @override
  State<ProfileViewBody> createState() => _ProfileViewBodyState();
}

class _ProfileViewBodyState extends State<ProfileViewBody> {
  final _authService = AuthService();
  final user = FirebaseAuth.instance.currentUser;

  String get _displayName => user?.displayName ?? 'User';
  String get _email => user?.email ?? 'user@email.com';
  String get _initials {
    final p = _displayName.split(' ');
    return p.length >= 2
        ? '${p[0][0]}${p[1][0]}'.toUpperCase()
        : _displayName[0].toUpperCase();
  }

  void _signOut() {
    showDialog(
      context: context,
      builder: (ctx) => BlocBuilder<ThemeCubit, bool>(
        builder: (ctx, _) => AlertDialog(
          backgroundColor: ctx.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Sign Out',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ctx.textPrimary,
            ),
          ),
          content: Text(
            'Are you sure you want to sign out?',
            style: GoogleFonts.outfit(fontSize: 14, color: ctx.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Cancel',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: ctx.textSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(ctx);
                await _authService.signOut();
                if (mounted)
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginView()),
                    (r) => false,
                  );
              },
              child: Text(
                'Sign Out',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _nav(Widget page) =>
      Navigator.push(context, MaterialPageRoute(builder: (_) => page));

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, isDark) {
        return BlocBuilder<WishlistCubit, WishlistState>(
          builder: (context, wishState) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Gap(30),
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: AppColors.gold,
                      child: Text(
                        _initials,
                        style: GoogleFonts.outfit(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Gap(12),
                    Text(
                      _displayName,
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: context.textPrimary,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      _email,
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        color: context.textHint,
                      ),
                    ),
                    const Gap(12),
                    GestureDetector(
                      onTap: () => _nav(const EditProfileView()),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: context.border, width: 1.5),
                        ),
                        child: Text(
                          'Edit Profile',
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: context.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    const Gap(24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _stat('12', 'Orders'),
                          Container(
                            width: 1,
                            height: 30,
                            color: context.border,
                          ),
                          _stat('${wishState.items.length}', 'Wishlist'),
                          Container(
                            width: 1,
                            height: 30,
                            color: context.border,
                          ),
                          _stat('3', 'Coupons'),
                        ],
                      ),
                    ),
                    const Gap(24),
                    _section([
                      _menuItem(
                        Icons.shopping_bag_outlined,
                        AppColors.green,
                        'My Orders',
                        () => _nav(const MyOrdersView()),
                      ),
                      _menuItem(
                        Icons.location_on_outlined,
                        AppColors.red,
                        'Shipping Addresses',
                        () => _nav(const AddressesView()),
                      ),
                      _menuItem(
                        Icons.credit_card_outlined,
                        const Color(0xFF457B9D),
                        'Payment Methods',
                        () => _nav(const PaymentMethodsView()),
                      ),
                      _menuItem(
                        Icons.confirmation_number_outlined,
                        AppColors.gold,
                        'My Coupons',
                        () => _nav(const CouponsView()),
                      ),
                    ]),
                    const Gap(16),
                    _section([
                      _menuItem(
                        Icons.settings_outlined,
                        context.textSecondary,
                        'Settings',
                        () => _nav(const SettingsView()),
                      ),
                      _darkModeItem(isDark),
                      _menuItem(
                        Icons.help_outline,
                        const Color(0xFF457B9D),
                        'Help & Support',
                        () => _nav(const HelpView()),
                      ),
                      _menuItem(
                        Icons.info_outline,
                        context.textHint,
                        'About',
                        () => _nav(const AboutView()),
                      ),
                    ]),
                    const Gap(16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton.icon(
                          onPressed: _signOut,
                          icon: const Icon(
                            Icons.logout,
                            color: Color(0xFFE74C3C),
                            size: 20,
                          ),
                          label: Text(
                            'Log Out',
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.red,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            side: const BorderSide(
                              color: Color(0xFFE74C3C),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Gap(30),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _stat(String v, String l) => Column(
    children: [
      Text(
        v,
        style: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: context.textPrimary,
        ),
      ),
      const Gap(2),
      Text(l, style: GoogleFonts.outfit(fontSize: 12, color: context.textHint)),
    ],
  );

  Widget _section(List<Widget> items) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Container(
      decoration: BoxDecoration(
        color: context.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.border, width: 1),
      ),
      child: Column(
        children: List.generate(
          items.length * 2 - 1,
          (i) => i.isOdd
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(height: 1, color: context.border),
                )
              : items[i ~/ 2],
        ),
      ),
    ),
  );

  Widget _menuItem(
    IconData icon,
    Color color,
    String title,
    VoidCallback onTap,
  ) => InkWell(
    onTap: onTap,
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
                color: context.textPrimary,
              ),
            ),
          ),
          Icon(Icons.chevron_right, color: context.textHint, size: 20),
        ],
      ),
    ),
  );

  Widget _darkModeItem(bool isDark) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    child: Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: context.textPrimary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.dark_mode_outlined,
            color: context.textPrimary,
            size: 18,
          ),
        ),
        const Gap(14),
        Expanded(
          child: Text(
            'Dark Mode',
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: context.textPrimary,
            ),
          ),
        ),
        Switch(
          value: isDark,
          onChanged: (_) => context.read<ThemeCubit>().toggle(),
          activeThumbColor: AppColors.gold,
        ),
      ],
    ),
  );
}
