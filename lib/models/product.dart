class Product {
  final int? id;
  final String name;
  final int price;
  final String description;
  final String? createdAt;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.description,
    this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'] is int ? json['price'] : int.parse(json['price'].toString()),
      description: json['description'] ?? '',
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'description': description,
    };
  }
}