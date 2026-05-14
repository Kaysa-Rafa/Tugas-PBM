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
    // Mengonversi price dengan aman dari berbagai kemungkinan tipe
    double parsedPrice;
    final priceValue = json['price'];
    if (priceValue is int) {
      parsedPrice = priceValue.toDouble();
    } else if (priceValue is double) {
      parsedPrice = priceValue;
    } else if (priceValue is String) {
      parsedPrice = double.tryParse(priceValue) ?? 0.0;
    } else {
      parsedPrice = 0.0; // Fallback jika null atau tipe tidak dikenal
    }

    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Tanpa Nama',
      price: parsedPrice,
      description: json['description'],
      createdAt: json['created_at'],
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

  @override
  String toString() => 'Product(id: $id, name: $name, price: $price)';
}