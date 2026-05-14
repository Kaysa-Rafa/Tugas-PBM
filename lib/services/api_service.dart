import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import 'auth_service.dart';

class ApiService {
  static const String baseUrl = 'https://task.itprojects.web.id/api';
  final AuthService _authService = AuthService();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _authService.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // LOGIN
  Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'username': username, 'password': password}),
      ).timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final token = data['data']?['token'];
        if (token != null) {
          await _authService.saveToken(token);
          return true;
        } else {
          throw Exception('Token tidak ditemukan dalam response');
        }
      } else {
        throw Exception(data['message'] ?? 'Login gagal');
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } on http.ClientException {
      throw Exception('Gagal menghubungi server');
    } catch (e) {
      rethrow;
    }
  }

  // GET PRODUCTS (parsing fleksibel)
  Future<List<Product>> getProducts() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/products'),
        headers: headers,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final dynamic decoded = jsonDecode(response.body);
        List<dynamic> productList;

        if (decoded is List) {
          productList = decoded;
        } else if (decoded is Map<String, dynamic>) {
          if (decoded.containsKey('data') && decoded['data'] is List) {
            productList = decoded['data'];
          } else if (decoded.containsKey('products') && decoded['products'] is List) {
            productList = decoded['products'];
          } else {
            // Cari nilai pertama yang bertipe List
            final listEntry = decoded.values.firstWhere(
              (v) => v is List,
              orElse: () => <dynamic>[],
            );
            productList = listEntry;
          }
        } else {
          throw Exception('Format respons tidak dikenali');
        }

        return productList
            .map((json) => Product.fromJson(json as Map<String, dynamic>))
            .toList();
      } else if (response.statusCode == 401) {
        await _authService.deleteToken();
        throw Exception('Sesi habis, silakan login kembali');
      } else {
        final msg = jsonDecode(response.body)['message'] ?? 'Gagal memuat produk';
        throw Exception(msg);
      }
    } catch (e) {
      rethrow;
    }
  }

  // ADD PRODUCT
  Future<Product> addProduct(Product product) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/products'),
        headers: headers,
        body: jsonEncode(product.toJson()),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 201 || response.statusCode == 200) {
        final dynamic decoded = jsonDecode(response.body);
        Map<String, dynamic> productData;

        if (decoded is Map<String, dynamic>) {
          productData = (decoded.containsKey('data') && decoded['data'] is Map)
              ? decoded['data']
              : decoded;
        } else {
          throw Exception('Response tambah produk tidak valid');
        }
        return Product.fromJson(productData);
      } else if (response.statusCode == 401) {
        await _authService.deleteToken();
        throw Exception('Sesi habis, silakan login kembali');
      } else {
        final msg = jsonDecode(response.body)['message'] ?? 'Gagal menambah produk';
        throw Exception(msg);
      }
    } catch (e) {
      rethrow;
    }
  }

  // DELETE PRODUCT
  Future<void> deleteProduct(int id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/products/$id'),
        headers: headers,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return;
      } else if (response.statusCode == 401) {
        await _authService.deleteToken();
        throw Exception('Sesi habis, silakan login kembali');
      } else {
        final msg = jsonDecode(response.body)['message'] ?? 'Gagal menghapus produk';
        throw Exception(msg);
      }
    } catch (e) {
      rethrow;
    }
  }

  // SUBMIT TUGAS
  Future<void> submitTask({
    required String name,
    required double price,
    required String description,
    required String githubUrl,
  }) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/products/submit'),
        headers: headers,
        body: jsonEncode({
          'name': name,
          'price': price,
          'description': description,
          'github_url': githubUrl,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else if (response.statusCode == 401) {
        await _authService.deleteToken();
        throw Exception('Sesi habis, silakan login kembali');
      } else {
        final msg = jsonDecode(response.body)['message'] ?? 'Gagal submit';
        throw Exception(msg);
      }
    } catch (e) {
      rethrow;
    }
  }
}