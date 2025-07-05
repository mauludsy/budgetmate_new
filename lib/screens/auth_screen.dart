// lib/screens/auth_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:budget_mate_app/main.dart'; // Import MainScreen dari main.dart

class AuthScreen extends StatefulWidget {
  final VoidCallback? onLoginSuccess; // Ubah menjadi nullable dengan '?'

  const AuthScreen({super.key, this.onLoginSuccess}); // Hapus 'required'

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLogin = true; // true for login, false for register

  Future<void> _authenticate() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    print('Mencoba login dengan Username: $username, Password: $password'); // Debugging

    // Simulasi autentikasi: username 'user', password 'pass'
    if (username == 'user' && password == 'pass') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true); // Set status login true
      print('Login berhasil! isLoggedIn di SharedPreferences: true'); // Debugging

      // Panggil onLoginSuccess hanya jika tidak null
      if (widget.onLoginSuccess != null) {
        widget.onLoginSuccess!(); // Gunakan '!' karena kita sudah cek tidak null
        print('Callback onLoginSuccess dipanggil.'); // Debugging
      }

      // Navigasi ke MainScreen dan hapus semua rute sebelumnya
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MainScreen()), // Hapus 'const' di sini
        (Route<dynamic> route) => false,
      );
    } else {
      print('Login gagal: Username atau Password salah.'); // Debugging
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username atau Password salah!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Login' : 'Daftar'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _authenticate,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
              ),
              child: Text(_isLogin ? 'Login' : 'Daftar'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                setState(() {
                  _isLogin = !_isLogin;
                  // Kosongkan field saat beralih mode
                  _usernameController.clear();
                  _passwordController.clear();
                });
              },
              child: Text(_isLogin ? 'Belum punya akun? Daftar' : 'Sudah punya akun? Login'),
            ),
          ],
        ),
      ),
    );
  }
}