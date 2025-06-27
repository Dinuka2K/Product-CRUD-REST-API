import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/user.dart';
import '../models/product.dart';

class ApiService with ChangeNotifier {
  static const String baseUrl = 'http://192.168.8.102:5000/api';
  String? authToken;
  User? currentUser;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('authToken');
    notifyListeners();
  }

  Future<void> register(String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 201) {
        await _saveAuthData(responseData['user']);
        Fluttertoast.showToast(msg: 'Registration successful');
      } else {
        throw responseData['message'];
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      rethrow;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        await _saveAuthData(responseData['user']);
        Fluttertoast.showToast(msg: 'Login successful');
      } else {
        throw responseData['message'];
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      rethrow;
    }
  }

  Future<void> _saveAuthData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', 'dummy_token'); // In real app, use JWT
    currentUser = User.fromJson(userData);
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    authToken = null;
    currentUser = null;
    notifyListeners();
  }

  Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw 'Failed to load products';
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      rethrow;
    }
  }

  Future<Product> getProductById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/$id'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        return Product.fromJson(jsonDecode(response.body));
      } else {
        throw 'Failed to load product';
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      rethrow;
    }
  }

  Future<Product> createProduct(Product product) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/products'),
        headers: _getHeaders(),
        body: jsonEncode(product.toJson()),
      );

      if (response.statusCode == 201) {
        Fluttertoast.showToast(msg: 'Product created successfully');
        return Product.fromJson(jsonDecode(response.body));
      } else {
        throw 'Failed to create product';
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      rethrow;
    }
  }

  Future<Product> updateProduct(Product product) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/products/${product.id}'),
        headers: _getHeaders(),
        body: jsonEncode(product.toJson()),
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'Product updated successfully');
        return Product.fromJson(jsonDecode(response.body));
      } else {
        throw 'Failed to update product';
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      rethrow;
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/products/$id'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'Product deleted successfully');
      } else {
        throw 'Failed to delete product';
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      rethrow;
    }
  }

  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      if (authToken != null) 'Authorization': 'Bearer $authToken',
    };
  }
}
