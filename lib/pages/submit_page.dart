import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SubmitPage extends StatefulWidget {
  const SubmitPage({super.key});
  @override
  State<SubmitPage> createState() => _SubmitPageState();
}

class _SubmitPageState extends State<SubmitPage> {
  final _nameCtrl = TextEditingController(text: 'Produk Final Futuristik');
  final _priceCtrl = TextEditingController(text: '99999');
  final _descCtrl = TextEditingController(text: 'Dikirim dari perangkat quanta');
  final _githubCtrl = TextEditingController(
    text: 'https://github.com/Kaysa-Rafa/Tugas-PBM', 
  );
  final _apiService = ApiService();
  bool _isSubmitting = false;

Future<void> _submit() async {
    // ... (Validasi form sama persis)

    setState(() => _isSubmitting = true);
    try {
      await _apiService.submitAssignment(
        name: _nameCtrl.text,
        price: price!,
        description: _descCtrl.text,
        githubUrl: _githubCtrl.text.trim(),
      );
      
      if (!mounted) return; // FIX
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Tugas terkirim ke server utama'),
            backgroundColor: Colors.greenAccent),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return; // FIX
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Submit gagal: ${e.toString()}'),
            backgroundColor: Colors.redAccent),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SUBMIT TUGAS', style: TextStyle(letterSpacing: 2)),
        backgroundColor: const Color(0xFF0A0E21),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 1.5,
            colors: [Color(0xFF1D1F33), Color(0xFF0A0E21)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: const Color(0xFF1D1F33).withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: const Color(0xFF00E5FF).withOpacity(0.6)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00E5FF).withOpacity(0.3),
                    blurRadius: 25,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.rocket, size: 48, color: Color(0xFF00E5FF)),
                  const SizedBox(height: 16),
                  Text(
                    'FINALISASI MISI',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: const Color(0xFF00E5FF).withOpacity(0.9),
                        letterSpacing: 2),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(
                        labelText: 'Nama Produk',
                        prefixIcon: Icon(Icons.label, color: Color(0xFF00E5FF))),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _priceCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: 'Harga',
                        prefixIcon: Icon(Icons.attach_money, color: Color(0xFF00E5FF))),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _descCtrl,
                    maxLines: 2,
                    decoration: const InputDecoration(
                        labelText: 'Deskripsi',
                        prefixIcon: Icon(Icons.text_snippet, color: Color(0xFF00E5FF))),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _githubCtrl,
                    decoration: const InputDecoration(
                        labelText: 'URL Repository',
                        prefixIcon: Icon(Icons.link, color: Color(0xFF00E5FF))),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00E5FF),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        shadowColor: const Color(0xFF00E5FF).withOpacity(0.8),
                        elevation: 10,
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.black))
                          : const Text('KIRIM TUGAS',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
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