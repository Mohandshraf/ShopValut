import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopvalut/core/cubits/theme/theme_cubit.dart';
import 'package:shopvalut/core/cubits/cart/cart_cubit.dart';
import 'package:shopvalut/core/cubits/cart/cart_state.dart';
import 'package:shopvalut/core/theme/app_colors.dart';
import 'package:shopvalut/core/theme/theme_extension.dart';
import 'package:shopvalut/features/Categories/presentation/views/widgets/categories_view_body.dart';
import 'package:shopvalut/features/Home/presentation/views/widgets/home_view_body.dart';
import 'package:shopvalut/features/Wishlist/presentation/views/widgets/wishlist_view_body.dart';
import 'package:shopvalut/features/Cart/presentation/views/widgets/cart_view_body.dart';
import 'package:shopvalut/features/profile/presentation/views/widgets/profile_view_body.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  @override
  State<HomeView> createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  int _currentIndex = 0;
  void changeTab(int index) => setState(() => _currentIndex = index);

  final List<Widget> _pages = const [HomeViewBody(), CategoriesViewBody(), WishlistViewBody(), CartViewBody(), ProfileViewBody()];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(builder: (context, _) {
      return Scaffold(backgroundColor: context.bg, body: _pages[_currentIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(color: context.navBar, border: Border(top: BorderSide(color: context.navBarBorder, width: 1))),
          child: BlocBuilder<CartCubit, CartState>(builder: (context, cartState) {
            return BottomNavigationBar(
              currentIndex: _currentIndex, onTap: (i) => setState(() => _currentIndex = i),
              type: BottomNavigationBarType.fixed, backgroundColor: context.navBar, elevation: 0,
              selectedItemColor: AppColors.gold, unselectedItemColor: context.textHint,
              selectedLabelStyle: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w600),
              unselectedLabelStyle: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w500),
              items: [
                const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
                const BottomNavigationBarItem(icon: Icon(Icons.grid_view_outlined), activeIcon: Icon(Icons.grid_view), label: 'Categories'),
                const BottomNavigationBarItem(icon: Icon(Icons.favorite_outline), activeIcon: Icon(Icons.favorite), label: 'Wishlist'),
                BottomNavigationBarItem(
                  icon: Badge(isLabelVisible: cartState.totalItems > 0, label: Text('${cartState.totalItems}', style: const TextStyle(fontSize: 10, color: Colors.white)),
                    backgroundColor: AppColors.red, child: const Icon(Icons.shopping_bag_outlined)),
                  activeIcon: Badge(isLabelVisible: cartState.totalItems > 0, label: Text('${cartState.totalItems}', style: const TextStyle(fontSize: 10, color: Colors.white)),
                    backgroundColor: AppColors.red, child: const Icon(Icons.shopping_bag)),
                  label: 'Cart'),
                const BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
              ]);
          })));
    });
  }
}
