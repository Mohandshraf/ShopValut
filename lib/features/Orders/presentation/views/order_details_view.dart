import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopvalut/core/cubits/theme/theme_cubit.dart';
import 'package:shopvalut/core/theme/app_colors.dart';
import 'package:shopvalut/core/theme/theme_extension.dart';

class OrderDetailsView extends StatelessWidget {
  final String orderId;
  final String status;
  const OrderDetailsView({super.key, required this.orderId, required this.status});

  @override
  Widget build(BuildContext context) {
    final steps = [
      {'title': 'Order Placed', 'time': 'Feb 28, 10:30 AM', 'done': true},
      {'title': 'Confirmed', 'time': 'Feb 28, 11:00 AM', 'done': true},
      {'title': 'Shipped', 'time': status != 'Cancelled' ? 'Mar 1, 2:00 PM' : '', 'done': status == 'Delivered'},
      {'title': 'Out for Delivery', 'time': status == 'Delivered' ? 'Mar 2, 9:00 AM' : '', 'done': status == 'Delivered'},
      {'title': 'Delivered', 'time': status == 'Delivered' ? 'Mar 2, 3:30 PM' : '', 'done': status == 'Delivered'},
    ];
    final currentStep = status == 'Delivered' ? 5 : status == 'Cancelled' ? 2 : 2;

    return BlocBuilder<ThemeCubit, bool>(builder: (context, _) {
      return Scaffold(backgroundColor: context.bg,
        appBar: AppBar(backgroundColor: context.bg, elevation: 0,
          leading: GestureDetector(onTap: () => Navigator.pop(context), child: Container(margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: context.card, borderRadius: BorderRadius.circular(10), border: Border.all(color: context.border, width: 1.5)),
            child: Icon(Icons.arrow_back_ios_new, size: 16, color: context.iconColor))),
          title: Text('Order $orderId', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: context.textPrimary)), centerTitle: true,
          actions: [Padding(padding: const EdgeInsets.only(right: 16), child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(color: (status == 'Delivered' ? AppColors.green : status == 'Cancelled' ? AppColors.red : AppColors.gold).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
            child: Center(child: Text(status, style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w600,
              color: status == 'Delivered' ? AppColors.green : status == 'Cancelled' ? AppColors.red : AppColors.gold)))))]),
        body: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Tracking', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: context.textPrimary)),
          const Gap(16),
          // Timeline
          ...List.generate(steps.length, (i) {
            final s = steps[i]; final done = i < currentStep;
            final isCurrent = i == currentStep - 1 && status != 'Delivered';
            final clr = done ? AppColors.green : isCurrent ? AppColors.gold : context.border;
            return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Column(children: [
                Container(width: 24, height: 24, decoration: BoxDecoration(color: done ? clr : Colors.transparent, shape: BoxShape.circle,
                  border: Border.all(color: clr, width: 2)),
                  child: done ? const Icon(Icons.check, size: 14, color: Colors.white) : null),
                if (i < steps.length - 1) Container(width: 2, height: 40, color: done ? AppColors.green : context.border),
              ]),
              const Gap(14),
              Expanded(child: Padding(padding: const EdgeInsets.only(bottom: 24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(s['title'] as String, style: GoogleFonts.outfit(fontSize: 14, fontWeight: done || isCurrent ? FontWeight.bold : FontWeight.w400,
                  color: done || isCurrent ? context.textPrimary : context.textHint)),
                if ((s['time'] as String).isNotEmpty) Text(s['time'] as String, style: GoogleFonts.outfit(fontSize: 12, color: context.textHint)),
              ]))),
            ]);
          }),
          if (status == 'Cancelled') ...[
            const Gap(8),
            Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.red.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.red.withValues(alpha: 0.2))),
              child: Row(children: [const Icon(Icons.cancel_outlined, color: AppColors.red, size: 20), const Gap(10),
                Expanded(child: Text('This order was cancelled', style: GoogleFonts.outfit(fontSize: 13, color: AppColors.red)))])),
          ],
          const Gap(24),
          Text('Order Summary', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: context.textPrimary)),
          const Gap(12),
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: context.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: context.border, width: 1)),
            child: Column(children: [
              _row(context, 'Subtotal', '\$249.98'), const Gap(8), _row(context, 'Shipping', '\$9.99'), const Gap(8),
              Divider(color: context.border), const Gap(8),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Total', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: context.textPrimary)),
                Text('\$259.97', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.green))])])),
          const Gap(24),
          Text('Shipping Address', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: context.textPrimary)),
          const Gap(12),
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: context.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: context.border, width: 1)),
            child: Row(children: [Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.red.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.location_on, color: AppColors.red, size: 20)), const Gap(14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Home', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: context.textPrimary)),
                Text('123 Main St, Cairo, Egypt', style: GoogleFonts.outfit(fontSize: 12, color: context.textSecondary))]))])),
          const Gap(30),
        ])));
    });
  }

  Widget _row(BuildContext c, String l, String v) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Text(l, style: GoogleFonts.outfit(fontSize: 14, color: c.textSecondary)),
    Text(v, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: c.textPrimary))]);
}
