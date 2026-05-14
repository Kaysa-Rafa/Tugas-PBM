import 'package:flutter/material.dart';
import '../services/api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _nimController = TextEditingController();
  final _passController = TextEditingController();
  final _apiService = ApiService();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);
    try {
      await _apiService.login(
        _nimController.text.trim(),
        _passController.text.trim(),
      );
      
      // FIX: Cek if mounted setelah await
      if (!mounted) return;
      
      // Navigasi ke halaman produk setelah login berhasil
      Navigator.pushReplacementNamed(context, '/products');
    } catch (e) {
      if (!mounted) return; // FIX: Cek if mounted setelah await
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://images.unsplash.com/photo-1558346490-a72e53ae2d2f?q=80&w=2070',
            ),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xCC0A0E21),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFF00E5FF).withOpacity(0.5),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00E5FF).withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.rocket_launch,
                      size: 56, color: const Color(0xFF00E5FF).withOpacity(0.9)),
                  const SizedBox(height: 16),
                  Text(
                    'LOGIN SYSTEM',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          letterSpacing: 4,
                          color: const Color(0xFF00E5FF),
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _nimController,
                    decoration: const InputDecoration(
                      labelText: 'NIM (Username)',
                      prefixIcon: Icon(Icons.face, color: Color(0xFF00E5FF)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password (NIM)',
                      prefixIcon: Icon(Icons.lock, color: Color(0xFF00E5FF)),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                  color: Colors.black, strokeWidth: 2),
                            )
                          : const Text('MASUK',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}