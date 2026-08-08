import 'package:flutter/foundation.dart';

@immutable
class Rating {
  final double rate;
  final int count;

  const Rating({required this.rate, required this.count});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      rate: (json['rate'] as num?)?.toDouble() ?? 0.0,
      count: json['count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'rate': rate,
        'count': count,
      };
}

@immutable
class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final Rating rating;
  final List<double> priceHistory;
  final int viewCount;
  final bool isTrending;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
    this.priceHistory = const [],
    this.viewCount = 120,
    this.isTrending = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final basePrice = (json['price'] as num?)?.toDouble() ?? 0.0;
    // Generate synthetic 30-day price history around basePrice for chart rendering
    final List<double> history = json['priceHistory'] != null
        ? List<double>.from(json['priceHistory'])
        : [
            basePrice * 1.15,
            basePrice * 1.10,
            basePrice * 1.05,
            basePrice * 1.08,
            basePrice * 0.95,
            basePrice,
          ];

    return Product(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      price: basePrice,
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      image: json['image'] as String? ?? '',
      rating: json['rating'] != null
          ? Rating.fromJson(json['rating'] as Map<String, dynamic>)
          : const Rating(rate: 4.5, count: 50),
      priceHistory: history,
      viewCount: json['viewCount'] as int? ?? (100 + ((json['id'] as int? ?? 1) * 23)),
      isTrending: ((json['id'] as int? ?? 0) % 2 == 0),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'price': price,
        'description': description,
        'category': category,
        'image': image,
        'rating': rating.toJson(),
        'priceHistory': priceHistory,
        'viewCount': viewCount,
        'isTrending': isTrending,
      };

  Product copyWith({
    int? id,
    String? title,
    double? price,
    String? description,
    String? category,
    String? image,
    Rating? rating,
    List<double>? priceHistory,
    int? viewCount,
    bool? isTrending,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      description: description ?? this.description,
      category: category ?? this.category,
      image: image ?? this.image,
      rating: rating ?? this.rating,
      priceHistory: priceHistory ?? this.priceHistory,
      viewCount: viewCount ?? this.viewCount,
      isTrending: isTrending ?? this.isTrending,
    );
  }
}
