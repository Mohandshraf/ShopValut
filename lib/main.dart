import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';
import 'package:shopvalut/core/cubits/theme/theme_cubit.dart';
import 'package:shopvalut/core/cubits/wishlist/wishlist_cubit.dart';
import 'package:shopvalut/core/cubits/cart/cart_cubit.dart';
import 'package:shopvalut/core/theme/app_colors.dart';
import 'package:shopvalut/features/SplashView/presentation/views/splash_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(DevicePreview(enabled: true, builder: (_) => const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => WishlistCubit()),
        BlocProvider(create: (_) => CartCubit()),
      ],
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, isDark) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            useInheritedMediaQuery: true,
            locale: DevicePreview.locale(context),
            builder: DevicePreview.appBuilder,
            theme: ThemeData(brightness: Brightness.light, scaffoldBackgroundColor: AppColors.lightBg),
            darkTheme: ThemeData(brightness: Brightness.dark, scaffoldBackgroundColor: AppColors.darkBg),
            themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
            home: const SplashView(),
          );
        },
      ),
    );
  }
}
