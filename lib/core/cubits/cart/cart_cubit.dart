import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopvalut/core/cubits/cart/cart_state.dart';
import 'package:shopvalut/features/Home/data/models/product_model.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  bool isInCart(String id) => state.items.any((i) => i.product.id == id);

  void addToCart(ProductModel product) {
    final items = List<CartItem>.from(state.items);
    final idx = items.indexWhere((i) => i.product.id == product.id);
    if (idx >= 0) {
      items[idx] = items[idx].copyWith(quantity: items[idx].quantity + 1);
    } else {
      items.add(CartItem(product: product));
    }
    emit(state.copyWith(items: items));
  }

  void removeFromCart(String id) {
    final items = List<CartItem>.from(state.items);
    items.removeWhere((i) => i.product.id == id);
    emit(state.copyWith(items: items));
  }

  void updateQuantity(String id, int qty) {
    if (qty <= 0) { removeFromCart(id); return; }
    final items = List<CartItem>.from(state.items);
    final idx = items.indexWhere((i) => i.product.id == id);
    if (idx >= 0) items[idx] = items[idx].copyWith(quantity: qty);
    emit(state.copyWith(items: items));
  }

  void clear() => emit(const CartState());
}
