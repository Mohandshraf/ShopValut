import 'package:shopvalut/features/Home/data/models/product_model.dart';

class CartItem {
  final ProductModel product;
  final int quantity;
  CartItem({required this.product, this.quantity = 1});
  CartItem copyWith({int? quantity}) => CartItem(product: product, quantity: quantity ?? this.quantity);
  double get total => product.price * quantity;
}

class CartState {
  final List<CartItem> items;
  const CartState({this.items = const []});
  CartState copyWith({List<CartItem>? items}) => CartState(items: items ?? this.items);
  int get totalItems => items.fold(0, (sum, i) => sum + i.quantity);
  double get subtotal => items.fold(0.0, (sum, i) => sum + i.total);
  double get shipping => items.isEmpty ? 0 : 9.99;
  double get totalPrice => subtotal + shipping;
}
