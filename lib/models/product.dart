import 'dart:convert';
import 'package:nukdi4/models/rating.dart';

class Product {
  final String name;
  final String description;
  final double quantity;
  final List<String> images;
  final String categoryId;
  final String categoryName;
  final double price;
  final String carBrand;
  final String carModel;
  final String carYear;
  final String? id;
  final List<Rating>? rating;

  Product({
    required this.name,
    required this.description,
    required this.quantity,
    required this.images,
    required this.categoryId,
    required this.categoryName,
    required this.price,
    required this.carBrand,
    required this.carModel,
    required this.carYear,
    this.id,
    this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'quantity': quantity,
      'images': images,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'price': price,
      'carBrand': carBrand,
      'carModel': carModel,
      'carYear': carYear,
      'id': id,
      'ratings': rating?.map((x) => x.toMap()).toList(),
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      quantity: map['quantity']?.toDouble() ?? 0.0,
      images: List<String>.from(map['images']),
      categoryId: map['categoryId'] ?? '',
      categoryName: map['categoryName'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      carBrand: map['carBrand'] ?? '',
      carModel: map['carModel'] ?? '',
      carYear: map['carYear'] ?? '',
      id: map['_id'],
      rating:
          map['ratings'] != null
              ? List<Rating>.from(map['ratings']?.map((x) => Rating.fromMap(x)))
              : null,
    );
  }

  String toJson() => json.encode(toMap());
  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));
}
