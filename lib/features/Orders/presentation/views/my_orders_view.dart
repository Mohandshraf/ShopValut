import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopvalut/core/cubits/theme/theme_cubit.dart';
import 'package:shopvalut/core/theme/app_colors.dart';
import 'package:shopvalut/core/theme/theme_extension.dart';
import 'package:shopvalut/features/Orders/presentation/views/order_details_view.dart';

class MyOrdersView extends StatefulWidget {
  const MyOrdersView({super.key});
  @override
  State<MyOrdersView> createState() => _MyOrdersViewState();
}

class _MyOrdersViewState extends State<MyOrdersView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final _orders = [
    {
      'id': '#1234',
      'date': 'Feb 28, 2026',
      'items': 3,
      'total': 259.97,
      'status': 'In Progress',
      'statusColor': AppColors.gold,
    },
    {
      'id': '#1230',
      'date': 'Feb 25, 2026',
      'items': 2,
      'total': 189.50,
      'status': 'Delivered',
      'statusColor': AppColors.green,
    },
    {
      'id': '#1228',
      'date': 'Feb 20, 2026',
      'items': 1,
      'total': 49.99,
      'status': 'Delivered',
      'statusColor': AppColors.green,
    },
    {
      'id': '#1225',
      'date': 'Feb 18, 2026',
      'items': 4,
      'total': 320.00,
      'status': 'Cancelled',
      'statusColor': AppColors.red,
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
              'My Orders',
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
              tabs: const [
                Tab(text: 'Active'),
                Tab(text: 'Completed'),
                Tab(text: 'Cancelled'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _orderList(
                _orders.where((o) => o['status'] == 'In Progress').toList(),
              ),
              _orderList(
                _orders.where((o) => o['status'] == 'Delivered').toList(),
              ),
              _orderList(
                _orders.where((o) => o['status'] == 'Cancelled').toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _orderList(List<Map<String, dynamic>> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined, size: 60, color: context.border),
            const Gap(12),
            Text(
              'No orders here',
              style: GoogleFonts.outfit(fontSize: 16, color: context.textHint),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: orders.length,
      itemBuilder: (_, i) {
        final o = orders[i];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OrderDetailsView(
                orderId: o['id'] as String,
                status: o['status'] as String,
              ),
            ),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.border, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order ${o['id']}',
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: context.textPrimary,
                      ),
                    ),
                    Text(
                      o['date'] as String,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: context.textHint,
                      ),
                    ),
                  ],
                ),
                const Gap(12),
                Row(
                  children: List.generate(
                    3,
                    (j) => Container(
                      margin: const EdgeInsets.only(right: 6),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: context.shimmer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.shopping_bag,
                        size: 18,
                        color: context.border,
                      ),
                    ),
                  ),
                ),
                const Gap(12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${o['items']} items • \$${(o['total'] as double).toStringAsFixed(2)}',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        color: context.textSecondary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: (o['statusColor'] as Color).withValues(
                          alpha: 0.1,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        o['status'] as String,
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: o['statusColor'] as Color,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
