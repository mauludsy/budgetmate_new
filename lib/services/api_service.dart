import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // static const baseUrl = 'http://192.168.0.127:8000';
  // static const baseUrl = 'http://192.168.18.139:8000';
  static const baseUrl = 'http://192.168.100.28:8000';

  



  // LOGIN
  static Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      print('📥 Login Response: ${response.statusCode} → ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("❌ Login error: $e");
      return false;
    }
  }

  // REGISTER
  static Future<bool> register(String name, String email, String password,
      String confirmPassword) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': confirmPassword,
        }),
      );

      print('📥 Register Response: ${response.statusCode} → ${response.body}');
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      print("❌ Register error: $e");
      return false;
    }
  }

  // GET PROFILE
  static Future<Map<String, dynamic>?> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) return null;

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print(
          '👤 Get Profile Response: ${response.statusCode} → ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print("❌ Get profile error: $e");
      return null;
    }
  }

  // LOGOUT
  static Future<bool> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) return false;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/logout'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('🚪 Logout Response: ${response.statusCode} → ${response.body}');

      if (response.statusCode == 200) {
        await prefs.remove('token');
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("❌ Logout error: $e");
      return false;
    }
  }

  // CREATE TRANSACTION
  static Future<bool> createTransaction({
    required double amount,
    required String category,
    required String type,
    required String date,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print("⚠️ Token tidak ditemukan.");
      return false;
    }

    // 🔁 Mapping "Pemasukan"/"Pengeluaran" ke "income"/"expense"
    final Map<String, String> typeMapping = {
      'Pengeluaran': 'expense',
      'Pemasukan': 'income',
      'expense': 'expense',
      'income': 'income',
    };
    final String finalType = typeMapping[type] ?? 'expense';

    final Map<String, dynamic> requestBody = {
      'amount': amount,
      'category': category,
      'type': finalType, // ✅ Dipastikan valid untuk backend
      'date': date,
    };

    print('📤 Kirim Transaksi: $requestBody');

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/transactions'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print('📥 Response Transaksi: ${response.statusCode} → ${response.body}');

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("❌ Error kirim transaksi: $e");
      return false;
    }
  }

  // GET ALL TRANSACTIONS
  static Future<List<dynamic>> getTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print("⚠️ Token tidak ditemukan saat getTransactions");
      throw Exception("Token tidak ditemukan");
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/transactions'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print(
          '📥 Get Transactions Response: ${response.statusCode} → ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['data']; // Laravel API biasanya pakai key "data"
      } else {
        throw Exception('Gagal mengambil data transaksi');
      }
    } catch (e) {
      print("❌ Get transactions error: $e");
      rethrow;
    }
  }
}
