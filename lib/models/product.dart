class Product {
  final int id;
  final String name;
  final double price;
  final String? description;
  final String? createdAt;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.description,
    this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Parsing harga yang aman
    double parsedPrice = 0.0;
    final priceValue = json['price'] ?? json['harga'];
    if (priceValue is int) {
      parsedPrice = priceValue.toDouble();
    } else if (priceValue is double) {
      parsedPrice = priceValue;
    } else if (priceValue is String) {
      parsedPrice = double.tryParse(priceValue) ?? 0.0;
    }

    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? json['product_name'] ?? 'Tanpa Nama',
      price: parsedPrice,
      description: json['description'] ?? json['desc'],
      createdAt: json['created_at'] ?? json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'created_at': createdAt,
    };
  }
}