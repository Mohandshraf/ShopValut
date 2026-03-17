import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopvalut/core/cubits/theme/theme_cubit.dart';
import 'package:shopvalut/core/theme/app_colors.dart';
import 'package:shopvalut/core/theme/theme_extension.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final notifs = [
      {
        'icon': Icons.local_shipping,
        'color': AppColors.green,
        'title': 'Order Shipped',
        'desc': 'Your order #1234 has been shipped and is on its way!',
        'time': '2 hours ago',
        'read': false,
      },
      {
        'icon': Icons.local_offer,
        'color': AppColors.gold,
        'title': 'Flash Sale!',
        'desc': 'Up to 50% off on electronics. Don\'t miss out!',
        'time': '5 hours ago',
        'read': false,
      },
      {
        'icon': Icons.check_circle,
        'color': AppColors.green,
        'title': 'Order Delivered',
        'desc': 'Your order #1230 has been delivered successfully.',
        'time': '1 day ago',
        'read': true,
      },
      {
        'icon': Icons.card_giftcard,
        'color': AppColors.gold,
        'title': 'New Coupon',
        'desc': 'You got a 15% discount coupon. Use code SAVE15.',
        'time': '2 days ago',
        'read': true,
      },
      {
        'icon': Icons.info,
        'color': const Color(0xFF457B9D),
        'title': 'App Update',
        'desc': 'A new version of ShopVault is available.',
        'time': '3 days ago',
        'read': true,
      },
    ];
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
              'Notifications',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: context.textPrimary,
              ),
            ),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Mark All Read',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.gold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: notifs.length,
            separatorBuilder: (_, _) => const Gap(8),
            itemBuilder: (_, i) {
              final n = notifs[i];
              final isRead = n['read'] as bool;
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: context.card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isRead
                        ? context.border
                        : AppColors.gold.withValues(alpha: 0.3),
                    width: isRead ? 1 : 1.5,
                  ),
                  boxShadow: isRead
                      ? []
                      : [
                          BoxShadow(
                            color: AppColors.gold.withValues(alpha: 0.05),
                            blurRadius: 8,
                          ),
                        ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: (n['color'] as Color).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        n['icon'] as IconData,
                        color: n['color'] as Color,
                        size: 20,
                      ),
                    ),
                    const Gap(12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            n['title'] as String,
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: isRead
                                  ? FontWeight.w500
                                  : FontWeight.bold,
                              color: context.textPrimary,
                            ),
                          ),
                          const Gap(4),
                          Text(
                            n['desc'] as String,
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              color: context.textSecondary,
                            ),
                          ),
                          const Gap(6),
                          Text(
                            n['time'] as String,
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              color: context.textHint,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.gold,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
