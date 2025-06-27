import 'package:intl/intl.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    this.createdAt,
    this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? json['_id'],
      name: json['name'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'price': price, 'quantity': quantity};
  }

  String get formattedPrice {
    return NumberFormat.currency(locale: 'en_US', symbol: '\$').format(price);
  }
}
