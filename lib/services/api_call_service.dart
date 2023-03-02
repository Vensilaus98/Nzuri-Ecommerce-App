import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ApiCallService {
  
  static const String url = "https://fakestoreapi.com/products";

  static List<Product> getParsedProducts(String response) {
    final list = jsonDecode(response).cast<Map<String, dynamic>>();
    return list.map<Product>((json) => Product.fromJson(json)).toList();
  }

  static Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return compute(getParsedProducts, response.body);
    } else {
      throw Exception('Failed to get products');
    }
  }
}
