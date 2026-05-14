import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import 'auth_service.dart';

const String baseUrl = 'https://task.itprojects.web.id';

class ApiService {
  final AuthService _authService = AuthService();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _authService.getToken();
    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token ?? ''}',
    };
  }

  Future<String?> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/api/auth/login');
    final response = await http.post(
      url,
      headers: {'Accept': 'application/json'},
      body: {'username': username, 'password': password},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['data']['token'];
      await _authService.saveToken(token);
      return token;
    } else {
      throw Exception('Login gagal: ${response.body}');
    }
  }

  Future<List<Product>> getProducts() async {
    final headers = await _getHeaders();
    final url = Uri.parse('$baseUrl/api/products');
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List productsJson = data['data'] ?? [];
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat produk: ${response.body}');
    }
  }

  Future<Product> createProduct(Product product) async {
    final token = await _authService.getToken();
    final url = Uri.parse('$baseUrl/api/products');
    
    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${token ?? ''}',
      },
      body: {
        'name': product.name,
        'price': product.price.toString(),
        'description': product.description,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Product.fromJson(data['data']);
    } else {
      throw Exception('Gagal menyimpan produk: ${response.body}');
    }
  }

  Future<void> deleteProduct(int id) async {
    final headers = await _getHeaders();
    final url = Uri.parse('$baseUrl/api/products/$id');
    final response = await http.delete(url, headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus produk: ${response.body}');
    }
  }

  Future<void> submitAssignment({
    required String name,
    required int price,
    required String description,
    required String githubUrl,
  }) async {
    final token = await _authService.getToken();
    final url = Uri.parse('$baseUrl/api/products/submit');
    
    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${token ?? ''}',
      },
      body: {
        'name': name,
        'price': price.toString(),
        'description': description,
        'github_url': githubUrl,
      },
    );
    
    if (response.statusCode != 200) {
      throw Exception('Submit gagal: ${response.body}');
    }
  }
}