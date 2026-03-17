import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopvalut/core/cubits/theme/theme_cubit.dart';
import 'package:shopvalut/core/theme/app_colors.dart';
import 'package:shopvalut/core/theme/theme_extension.dart';

class AddressesView extends StatefulWidget {
  const AddressesView({super.key});
  @override
  State<AddressesView> createState() => _AddressesViewState();
}

class _AddressesViewState extends State<AddressesView> {
  int _selectedIdx = 0;
  final _addresses = [
    {
      'label': 'Home',
      'address': '123 Main Street, Apt 4B',
      'city': 'Cairo, Egypt',
      'phone': '+20 123 456 789',
      'icon': Icons.home_outlined,
      'color': AppColors.gold,
    },
    {
      'label': 'Work',
      'address': '456 Business Ave, Floor 8',
      'city': 'Cairo, Egypt',
      'phone': '+20 987 654 321',
      'icon': Icons.work_outline,
      'color': const Color(0xFF457B9D),
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
              'Shipping Addresses',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: context.textPrimary,
              ),
            ),
            centerTitle: true,
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              ...List.generate(_addresses.length, (i) {
                final a = _addresses[i];
                final sel = _selectedIdx == i;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIdx = i),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: context.card,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: sel ? AppColors.gold : context.border,
                        width: sel ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: (a['color'] as Color).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            a['icon'] as IconData,
                            color: a['color'] as Color,
                            size: 22,
                          ),
                        ),
                        const Gap(14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    a['label'] as String,
                                    style: GoogleFonts.outfit(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: context.textPrimary,
                                    ),
                                  ),
                                  if (sel) ...[
                                    const Gap(8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.gold.withValues(
                                          alpha: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'Default',
                                        style: GoogleFonts.outfit(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.gold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const Gap(4),
                              Text(
                                a['address'] as String,
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  color: context.textSecondary,
                                ),
                              ),
                              Text(
                                a['city'] as String,
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  color: context.textHint,
                                ),
                              ),
                              const Gap(2),
                              Text(
                                a['phone'] as String,
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  color: context.textHint,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Radio<int>(
                              value: i,
                              groupValue: _selectedIdx,
                              onChanged: (v) =>
                                  setState(() => _selectedIdx = v!),
                              activeColor: AppColors.gold,
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Text(
                                'Edit',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.gold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const Gap(8),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.gold.withValues(alpha: 0.4),
                      width: 1.5,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        color: AppColors.gold,
                        size: 22,
                      ),
                      const Gap(10),
                      Text(
                        'Add New Address',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.gold,
                        ),
                      ),
                    ],
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
