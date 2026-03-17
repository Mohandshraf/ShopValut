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
import 'package:shopvalut/features/Home/data/dummy_data.dart';
import 'package:shopvalut/features/Home/data/models/product_model.dart';
import 'package:shopvalut/features/Home/presentation/views/home_view.dart';
import 'package:shopvalut/features/Search/presentation/views/search_view.dart';
import 'package:shopvalut/features/Notifications/presentation/views/notifications_view.dart';
import 'package:shopvalut/features/ProductDetails/presentation/views/product_details_view.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});
  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  final user = FirebaseAuth.instance.currentUser;
  int _currentBanner = 0, _selectedCategory = 0;
  final PageController _bannerController = PageController();
  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  String get _firstName => (user?.displayName ?? 'Friend').split(' ').first;
  List<ProductModel> _filter(List<ProductModel> list) {
    if (_selectedCategory == 0) return list;
    final cat = DummyData.categories[_selectedCategory]['name'];
    return list.where((p) => p.category == cat).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, _) {
        return BlocBuilder<WishlistCubit, WishlistState>(
          builder: (context, _) {
            final flash = _filter(DummyData.flashDeals),
                popular = _filter(DummyData.popular);
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(16),
                    _header(context),
                    const Gap(16),
                    _searchBar(context),
                    const Gap(20),
                    _banner(context),
                    const Gap(24),
                    _categories(context),
                    const Gap(24),
                    _sectionTitle(context, 'Flash Deals 🔥', true),
                    const Gap(12),
                    flash.isEmpty
                        ? _empty(context, 'No flash deals')
                        : _productList(context, flash),
                    const Gap(24),
                    _sectionTitle(context, 'Popular', false),
                    const Gap(12),
                    popular.isEmpty
                        ? _empty(context, 'No popular items')
                        : _productList(context, popular),
                    const Gap(20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _header(BuildContext c) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Hi, $_firstName 👋',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: c.textPrimary,
          ),
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsView()),
              ),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: c.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: c.border, width: 1.5),
                ),
                child: Icon(
                  Icons.notifications_outlined,
                  size: 20,
                  color: c.iconColor,
                ),
              ),
            ),
            const Gap(8),
            GestureDetector(
              onTap: () => context
                  .findAncestorStateOfType<HomeViewState>()
                  ?.changeTab(4),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.gold,
                child: Text(
                  _firstName[0].toUpperCase(),
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _searchBar(BuildContext c) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SearchView()),
      ),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: c.inputFill,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: c.border, width: 1.5),
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: c.textHint, size: 20),
            const Gap(10),
            Expanded(
              child: Text(
                'Search products, brands...',
                style: GoogleFonts.outfit(fontSize: 13, color: c.textHint),
              ),
            ),
            Icon(Icons.mic_none, color: c.textHint, size: 20),
          ],
        ),
      ),
    ),
  );

  Widget _banner(BuildContext c) => Column(
    children: [
      SizedBox(
        height: 160,
        child: PageView.builder(
          controller: _bannerController,
          onPageChanged: (i) => setState(() => _currentBanner = i),
          itemCount: 3,
          itemBuilder: (_, i) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Color(0xFFD4A574), Color(0xFFB8865C)],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'SUMMER SALE',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                      letterSpacing: 1,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    'Up to 50% Off',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Gap(12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: c.isDark ? const Color(0xFF1A1A1A) : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Shop Now →',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: c.isDark
                            ? Colors.white
                            : const Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      const Gap(12),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          3,
          (i) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: _currentBanner == i ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: _currentBanner == i ? AppColors.gold : c.border,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    ],
  );

  Widget _categories(BuildContext c) => SizedBox(
    height: 90,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: DummyData.categories.length,
      itemBuilder: (_, i) {
        final cat = DummyData.categories[i];
        final sel = _selectedCategory == i;
        return GestureDetector(
          onTap: () => setState(() => _selectedCategory = i),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 70,
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: sel ? AppColors.gold : c.card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: sel ? AppColors.gold : c.border,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      cat['icon'],
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                ),
                const Gap(6),
                Text(
                  cat['name'],
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: sel ? FontWeight.bold : FontWeight.w500,
                    color: sel ? AppColors.gold : c.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    ),
  );

  Widget _sectionTitle(BuildContext c, String t, bool timer) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              t,
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: c.textPrimary,
              ),
            ),
            if (timer) ...[
              const Gap(8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '02:34:13',
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
        Text(
          'See All >',
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.gold,
          ),
        ),
      ],
    ),
  );

  Widget _productList(BuildContext c, List<ProductModel> p) => SizedBox(
    height: 300,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: p.length,
      itemBuilder: (_, i) => _productCard(c, p[i]),
    ),
  );

  Widget _empty(BuildContext c, String m) => SizedBox(
    height: 150,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 40, color: c.border),
          const Gap(8),
          Text(m, style: GoogleFonts.outfit(fontSize: 13, color: c.textHint)),
        ],
      ),
    ),
  );

  Widget _productCard(BuildContext c, ProductModel p) {
    final w = context.read<WishlistCubit>();
    final isW = w.isInWishlist(p.id);
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ProductDetailsView(product: p)),
      ),
      child: Container(
        width: 170,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: c.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: c.border, width: 1),
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
                    color: c.shimmer,
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
                          color: c.border,
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
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => w.toggle(p),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: c.card,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        isW ? Icons.favorite : Icons.favorite_border,
                        size: 16,
                        color: AppColors.red,
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.cairo(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: c.textPrimary,
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
                          color: c.textSecondary,
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
                          color: c.textHint,
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
  }
}
