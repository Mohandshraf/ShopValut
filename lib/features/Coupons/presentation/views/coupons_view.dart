import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopvalut/core/cubits/theme/theme_cubit.dart';
import 'package:shopvalut/core/theme/app_colors.dart';
import 'package:shopvalut/core/theme/theme_extension.dart';

class CouponsView extends StatefulWidget {
  const CouponsView({super.key});
  @override
  State<CouponsView> createState() => _CouponsViewState();
}

class _CouponsViewState extends State<CouponsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final _available = [
    {
      'code': 'SAVE15',
      'discount': '15%',
      'desc': 'On all electronics',
      'expiry': 'Mar 15, 2026',
      'min': '\$50',
    },
    {
      'code': 'SPRING25',
      'discount': '25%',
      'desc': 'On fashion items',
      'expiry': 'Mar 30, 2026',
      'min': '\$100',
    },
    {
      'code': 'FREESHIP',
      'discount': 'Free',
      'desc': 'Free shipping on all orders',
      'expiry': 'Apr 1, 2026',
      'min': '\$30',
    },
  ];
  final _used = [
    {
      'code': 'WINTER10',
      'discount': '10%',
      'desc': 'On all items',
      'expiry': 'Feb 28, 2026',
      'min': '\$25',
    },
  ];

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
              'My Coupons',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: context.textPrimary,
              ),
            ),
            centerTitle: true,
            bottom: TabBar(
              controller: _tabController,
              labelColor: AppColors.gold,
              unselectedLabelColor: context.textHint,
              indicatorColor: AppColors.gold,
              indicatorWeight: 2.5,
              labelStyle: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              tabs: [
                Tab(text: 'Available (${_available.length})'),
                Tab(text: 'Used (${_used.length})'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _couponList(context, _available, false),
              _couponList(context, _used, true),
            ],
          ),
        );
      },
    );
  }

  Widget _couponList(
    BuildContext c,
    List<Map<String, String>> coupons,
    bool used,
  ) {
    if (coupons.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.confirmation_number_outlined, size: 60, color: c.border),
            const Gap(12),
            Text(
              'No coupons',
              style: GoogleFonts.outfit(fontSize: 16, color: c.textHint),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: coupons.length,
      itemBuilder: (_, i) {
        final cp = coupons[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: c.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: c.border, width: 1),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 70,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: used
                            ? c.shimmer
                            : AppColors.gold.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            cp['discount']!,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: used ? c.textHint : AppColors.gold,
                            ),
                          ),
                          if (cp['discount'] != 'Free')
                            Text(
                              'OFF',
                              style: GoogleFonts.outfit(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: used ? c.textHint : AppColors.gold,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const Gap(14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cp['desc']!,
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: used ? c.textHint : c.textPrimary,
                            ),
                          ),
                          const Gap(4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: used ? c.border : AppColors.gold,
                                    width: 1,
                                    style: BorderStyle.solid,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  cp['code']!,
                                  style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                    color: used ? c.textHint : AppColors.gold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Gap(6),
                          Text(
                            'Min. ${cp['min']} • Expires ${cp['expiry']}',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              color: c.textHint,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!used)
                      GestureDetector(
                        onTap: () => ScaffoldMessenger.of(c).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Coupon ${cp['code']} copied!',
                              style: GoogleFonts.outfit(),
                            ),
                            backgroundColor: AppColors.green,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.gold,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Apply',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (used)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: c.textHint.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Used',
                      style: GoogleFonts.outfit(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: c.textHint,
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
