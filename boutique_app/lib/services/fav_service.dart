import 'dart:convert';
import 'package:http/http.dart' as http;

class FavoritesService {
  static const String baseUrl =
      'http://localhost:5000/favorites'; // Replace with your backend base URL

  /// Add a product to the user's favorites
  static Future<Map<String, dynamic>> addToFavorites({
    required int userId,
    required int productId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'product_id': productId,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        // Check if the favorite_id exists in the response and is valid
        if (responseData['favorite_id'] != null) {
          return responseData;
        } else {
          throw Exception('Favorite ID is null');
        }
      } else {
        throw Exception('Failed to add product to favorites: ${response.body}');
      }
    } catch (error) {
      throw Exception('Error in addToFavorites: $error');
    }
  }

  /// Remove a product from the user's favorites
  static Future<Map<String, dynamic>> removeFromFavorites({
    required int favoriteId,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/remove'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'favorite_id': favoriteId,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'Failed to remove product from favorites: ${response.body}');
      }
    } catch (error) {
      throw Exception('Error in removeFromFavorites: $error');
    }
  }
}
