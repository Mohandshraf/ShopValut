import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopvalut/core/cubits/wishlist/wishlist_state.dart';
import 'package:shopvalut/features/Home/data/models/product_model.dart';

class WishlistCubit extends Cubit<WishlistState> {
  WishlistCubit() : super(const WishlistState());

  bool isInWishlist(String productId) {
    return state.items.any((p) => p.id == productId);
  }

  void toggle(ProductModel product) {
    final current = List<ProductModel>.from(state.items);
    if (isInWishlist(product.id)) {
      current.removeWhere((p) => p.id == product.id);
    } else {
      current.add(product);
    }
    emit(state.copyWith(items: current));
  }

  void remove(String productId) {
    final current = List<ProductModel>.from(state.items);
    current.removeWhere((p) => p.id == productId);
    emit(state.copyWith(items: current));
  }

  void clear() {
    emit(const WishlistState());
  }
}
