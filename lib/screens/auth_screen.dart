import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:budget_mate_app/services/api_service.dart';
import 'package:budget_mate_app/screens/main_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  bool _isLoading = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  void _toggleForm() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (_isLogin) {
      if (email.isEmpty || password.isEmpty) {
        _showMessage('Email dan password wajib diisi!');
        return;
      }

      setState(() => _isLoading = true);
      final success = await ApiService.login(email, password);
      setState(() => _isLoading = false);

      if (success) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainScreen()));
      } else {
        _showMessage('Login gagal! Email atau password salah.');
      }
    } else {
      final name = _nameController.text.trim();
      final confirmPassword = _confirmController.text.trim();

      if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
        _showMessage('Semua field wajib diisi!');
        return;
      }

      if (!email.contains('@') || !email.contains('.')) {
        _showMessage('Masukkan email yang valid (cth: user@gmail.com)');
        return;
      }

      if (password != confirmPassword) {
        _showMessage('Password dan konfirmasi tidak sama!');
        return;
      }

      setState(() => _isLoading = true);
      final success = await ApiService.register(name, email, password, confirmPassword);
      setState(() => _isLoading = false);

      if (success) {
        _showMessage('Registrasi berhasil. Silakan login.');
        setState(() {
          _isLogin = true; // Kembali ke mode login
          _passwordController.clear();
          _confirmController.clear();
        });
      } else {
        _showMessage('Registrasi gagal! Email mungkin sudah digunakan.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Login' : 'Registrasi'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!_isLogin)
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama Lengkap'),
              ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email (cth: user@gmail.com)'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            if (!_isLogin)
              const SizedBox(height: 10),
            if (!_isLogin)
              TextField(
                controller: _confirmController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Konfirmasi Password'),
              ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: Text(_isLogin ? 'Login' : 'Daftar'),
                  ),
            TextButton(
              onPressed: _toggleForm,
              child: Text(_isLogin
                  ? 'Belum punya akun? Daftar di sini'
                  : 'Sudah punya akun? Login di sini'),
            )
          ],
        ),
      ),
    );
  }
}
