class ProductModel {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final double oldPrice;
  final double rating;
  final int reviews;
  final int discount;
  final String category;

  ProductModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.oldPrice,
    required this.rating,
    required this.reviews,
    required this.discount,
    required this.category,
  });
}