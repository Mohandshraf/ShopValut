import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopvalut/core/cubits/theme/theme_cubit.dart';
import 'package:shopvalut/core/theme/app_colors.dart';
import 'package:shopvalut/core/theme/theme_extension.dart';
import 'package:shopvalut/features/Home/data/dummy_data.dart';
import 'package:shopvalut/features/Home/data/models/product_model.dart';
import 'package:shopvalut/features/ProductDetails/presentation/views/product_details_view.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});
  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final _ctrl = TextEditingController();
  final _focus = FocusNode();
  bool _searching = false;
  List<ProductModel> _results = [];
  final List<String> _recent = [
    'Headphones',
    'Nike shoes',
    'MacBook',
    'Sunglasses',
    'Plant pot',
  ];
  final _trending = [
    'iPhone 16 Pro',
    'Nike Air Max',
    'MacBook Pro',
    'PS5',
    'Samsung TV',
    'AirPods',
    'Dyson',
    'Lego',
  ];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _search(String q) {
    if (q.isEmpty) {
      setState(() {
        _searching = false;
        _results = [];
      });
      return;
    }
    setState(() {
      _searching = true;
      _results = [
        ...DummyData.flashDeals,
        ...DummyData.popular,
      ].where((p) => p.name.toLowerCase().contains(q.toLowerCase())).toList();
    });
  }

  void _tap(String t) {
    _ctrl.text = t;
    _search(t);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, _) {
        return Scaffold(
          backgroundColor: context.bg,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: context.card,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: context.border,
                              width: 1.5,
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            size: 16,
                            color: context.iconColor,
                          ),
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: TextField(
                          controller: _ctrl,
                          focusNode: _focus,
                          onChanged: _search,
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            color: context.textPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search products, brands...',
                            hintStyle: GoogleFonts.outfit(
                              fontSize: 13,
                              color: context.textHint,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: context.textHint,
                              size: 20,
                            ),
                            filled: true,
                            fillColor: context.inputFill,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                color: context.border,
                                width: 1.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                color: context.border,
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: Color(0xFFD4A574),
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(16),
                Expanded(child: _searching ? _buildResults() : _buildDefault()),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDefault() => SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_recent.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary,
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _recent.clear()),
                  child: Text(
                    'Clear All',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Gap(8),
          ...List.generate(
            _recent.length,
            (i) => InkWell(
              onTap: () => _tap(_recent[i]),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Icon(Icons.access_time, size: 18, color: context.textHint),
                    const Gap(14),
                    Expanded(
                      child: Text(
                        _recent[i],
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: context.textPrimary,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _recent.removeAt(i)),
                      child: Icon(
                        Icons.close,
                        size: 18,
                        color: context.textHint,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Gap(16),
        ],
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Trending 🔥',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: context.textPrimary,
            ),
          ),
        ),
        const Gap(12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _trending
                .map(
                  (t) => GestureDetector(
                    onTap: () => _tap(t),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: context.card,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: context.border, width: 1),
                      ),
                      child: Text(
                        t,
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: context.textPrimary,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const Gap(30),
      ],
    ),
  );
  Widget _buildResults() {
    if (_results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 60, color: context.border),
            const Gap(12),
            Text(
              'No products found',
              style: GoogleFonts.outfit(fontSize: 16, color: context.textHint),
            ),
          ],
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.65,
      ),
      itemCount: _results.length,
      itemBuilder: (_, i) {
        final p = _results[i];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ProductDetailsView(product: p)),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: context.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.border, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 140,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: context.shimmer,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: Image.network(
                          p.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Center(
                            child: Icon(
                              Icons.image_outlined,
                              size: 50,
                              color: context.border,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '-${p.discount}%',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.cairo(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: context.textPrimary,
                        ),
                      ),
                      const Gap(4),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 14,
                            color: Color(0xFFFFB800),
                          ),
                          const Gap(4),
                          Text(
                            '${p.rating} (${p.reviews})',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              color: context.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const Gap(6),
                      Row(
                        children: [
                          Text(
                            '\$${p.price}',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.green,
                            ),
                          ),
                          const Gap(6),
                          Text(
                            '\$${p.oldPrice}',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              color: context.textHint,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
