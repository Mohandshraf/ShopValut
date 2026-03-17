import 'package:flutter/material.dart';
import 'package:shopvalut/features/Categories/data/models/category_model.dart';

class CategoriesData {
  static List<CategoryModel> categories = [
    CategoryModel(
      name: 'Electronics',
      icon: Icons.phone_iphone,
      color: const Color(0xFF2C3E50),
    ),
    CategoryModel(
      name: 'Fashion',
      icon: Icons.checkroom,
      color: const Color(0xFF6B3A5D),
    ),
    CategoryModel(
      name: 'Home & Garden',
      icon: Icons.home_outlined,
      color: const Color(0xFF2D6A4F),
    ),
    CategoryModel(
      name: 'Beauty',
      icon: Icons.auto_awesome,
      color: const Color(0xFFB8935A),
    ),
    CategoryModel(
      name: 'Sports & Fitness',
      icon: Icons.fitness_center,
      color: const Color(0xFFE74C3C),
    ),
    CategoryModel(
      name: 'Books & Stationery',
      icon: Icons.menu_book,
      color: const Color(0xFF5B7B8A),
    ),
    CategoryModel(
      name: 'Groceries',
      icon: Icons.shopping_cart_outlined,
      color: const Color(0xFF8B9A46),
    ),
    CategoryModel(
      name: 'Toys & Games',
      icon: Icons.sports_esports,
      color: const Color(0xFFD4956A),
    ),
    CategoryModel(
      name: 'Automotive',
      icon: Icons.directions_car_outlined,
      color: const Color(0xFF34495E),
    ),
    CategoryModel(
      name: 'Health & Wellness',
      icon: Icons.health_and_safety_outlined,
      color: const Color(0xFF17A2B8),
    ),
    CategoryModel(
      name: 'Jewelry & Watches',
      icon: Icons.diamond_outlined,
      color: const Color(0xFF8B6914),
    ),
    CategoryModel(
      name: 'Pet Supplies',
      icon: Icons.pets,
      color: const Color(0xFFC68B59),
    ),
  ];
}