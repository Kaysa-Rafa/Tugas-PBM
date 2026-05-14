import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isSaving = false;

  Future<void> _addProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      final price = double.tryParse(_priceController.text.replaceAll(',', '.')) ?? 0;
      final product = Product(
        id: 0,
        name: _nameController.text.trim(),
        price: price,
        description: _descController.text.trim(),
      );
      await _apiService.addProduct(product);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Produk berhasil ditambahkan')),
        );
        // Perbaikan: reset form
        _formKey.currentState?.reset();
        _nameController.clear();
        _priceController.clear();
        _descController.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Produk')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration('Nama Produk'),
                validator: (v) => v!.trim().isEmpty ? 'Nama wajib diisi' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: _inputDecoration('Harga'),
                // Perbaikan: validasi harga desimal yang lebih fleksibel
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Harga wajib diisi';
                  final cleaned = v.replaceAll(',', '.');
                  final parsed = double.tryParse(cleaned);
                  if (parsed == null) return 'Masukkan angka yang valid';
                  if (parsed <= 0) return 'Harga harus lebih dari 0';
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: _inputDecoration('Deskripsi (opsional)'),
                maxLines: 3,
              ),
              SizedBox(height: 24),
              _isSaving
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _addProduct,
                      child: Text('SIMPAN'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Color(0xFF00E5FF)),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF00E5FF).withOpacity(0.5)),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF00E5FF), width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descController.dispose();
    super.dispose();
  }
}