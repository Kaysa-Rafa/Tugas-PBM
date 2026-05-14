// lib/pages/submit_page.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SubmitPage extends StatefulWidget {
  @override
  _SubmitPageState createState() => _SubmitPageState();
}

class _SubmitPageState extends State<SubmitPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  // Inisialisasi controller dengan nilai default langsung
  final _repoController = TextEditingController(
    text: 'https://github.com/Kaysa-Rafa/Tugas-PBM',
  );
  final ApiService _apiService = ApiService();
  bool _isSubmitting = false;

  // Regex untuk validasi URL GitHub
  final _githubUrlRegex = RegExp(
    r'^https?:\/\/github\.com\/[a-zA-Z0-9\-_]+\/[a-zA-Z0-9\-_\.]+$',
  );

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    try {
      final price = double.tryParse(
            _priceController.text.replaceAll(',', '.'),
          ) ??
          0;
      await _apiService.submitTask(
        name: _nameController.text.trim(),
        price: price,
        description: _descController.text.trim(),
        githubUrl: _repoController.text.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tugas berhasil disubmit!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descController.dispose();
    _repoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Submit Tugas')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration('Nama Produk'),
                validator: (v) =>
                    v!.trim().isEmpty ? 'Nama produk wajib diisi' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: _inputDecoration('Harga'),
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
                decoration: _inputDecoration('Deskripsi Produk'),
                maxLines: 3,
                validator: (v) =>
                    v!.trim().isEmpty ? 'Deskripsi wajib diisi' : null,
              ),
              SizedBox(height: 16),
              // Field URL GitHub dengan nilai default
              TextFormField(
                controller: _repoController,
                decoration: _inputDecoration('URL Repository GitHub'),
                keyboardType: TextInputType.url,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'URL wajib diisi';
                  if (!_githubUrlRegex.hasMatch(v.trim())) {
                    return 'Masukkan URL GitHub yang valid\ncontoh: https://github.com/user/repo';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              _isSubmitting
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submit,
                      child: Text('SUBMIT'),
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
}