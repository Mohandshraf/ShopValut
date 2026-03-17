import 'package:shopvalut/features/Home/data/models/product_model.dart';

class WishlistState {
  final List<ProductModel> items;

  const WishlistState({this.items = const []});

  WishlistState copyWith({List<ProductModel>? items}) {
    return WishlistState(items: items ?? this.items);
  }
}
