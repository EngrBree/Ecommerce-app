import 'dart:convert';
import 'package:http/http.dart' as http;

class CartService {
  static const String baseUrl =
      'http://localhost:5000/cart'; // Replace with your backend URL

  /// Add a product to the cart
  static Future<Map<String, dynamic>> addToCart({
    required int userId,
    required int productId,
    required int quantity,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'product_id': productId,
          'quantity': quantity,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to add product to cart: ${response.body}');
      }
    } catch (error) {
      throw Exception('Error in addToCart: $error');
    }
  }

  /// Remove a product from the cart
  static Future<Map<String, dynamic>> removeFromCart({
    required int cartId,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/remove'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'cart_id': cartId,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to remove product from cart: ${response.body}');
      }
    } catch (error) {
      throw Exception('Error in removeFromCart: $error');
    }
  }
}
