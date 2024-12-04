import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import "prouctDetail.dart";

class ShopScreen extends StatefulWidget {
  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  List<dynamic> products = []; // To hold the product list
  bool isLoading = true; // To manage loading state

  @override
  void initState() {
    super.initState();
    fetchProducts(); // Fetch products when the widget is initialized
  }

  // Fetch products from backend
  Future<void> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:5000/products/all'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body); // Parse as list
        setState(() {
          products = List<Map<String, dynamic>>.from(data); // Explicit casting
          isLoading = false; // Stop the loading state
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false; // Stop loading if there’s an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
      ),
      body: isLoading
          ? Center(
              child:
                  CircularProgressIndicator()) // Show a loader when fetching data
          : products.isEmpty
              ? Center(
                  child: Text(
                    'No products available',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : GridView.builder(
                  padding: EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Display 2 cards in a row
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 2 / 3, // Adjust card dimensions
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index]; // Fetch each product
                    return ProductCard(product: product);
                  },
                ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;

  ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    String imageUrl = product['image_url'] ?? '';
    print('Image URL: $imageUrl');

    return GestureDetector(
      onTap: () {
        // Navigate to the product detail page when the card is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: product),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.image_not_supported,
                              size: 50); // Fallback for image load failure
                        },
                      )
                    : Icon(Icons.image_not_supported,
                        size: 50), // Fallback for missing image
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'] ?? 'Unnamed Product',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    product['category_name'] ?? 'Uncategorized',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '\$${product['price'].toString()}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
