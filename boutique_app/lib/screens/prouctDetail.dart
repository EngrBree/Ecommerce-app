import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:boutique_app/services/auth_service.dart';
import 'package:boutique_app/services/addCart_service.dart';
import 'package:boutique_app/services/fav_service.dart';

class ProductDetailPage extends StatefulWidget {
  final Map<String, dynamic> product;

  ProductDetailPage({required this.product});

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailPage> {
  late int userId; // User ID from AuthService
  bool isFavorite = false;
  bool isInCart = false;
  int quantity = 1;

  @override
  void initState() {
    super.initState();

    // Retrieve user ID from AuthService
    final authService = Provider.of<AuthService>(context, listen: false);
    final currentUser = authService.currentUser;

    if (currentUser != null && currentUser['id'] != null) {
      userId = currentUser['id'];
      print('User ID in ProductDetailPage: $userId'); // Debug log
    } else {
      throw Exception('User ID not found. Ensure the user is logged in.');
    }
  }

  Future<void> toggleFavorite() async {
    try {
      if (isFavorite) {
        if (widget.product['favorite_id'] != null) {
          await FavoritesService.removeFromFavorites(
            favoriteId: widget.product['favorite_id'],
          );
          setState(() {
            isFavorite = false;
          });
          print('Removed from Favorites');
        } else {
          print('Error: Favorite ID is null');
        }
      } else {
        final response = await FavoritesService.addToFavorites(
          userId: userId,
          productId: widget.product['id'],
        );
        setState(() {
          isFavorite = true;
        });
        print('Added to Favorites');
      }
    } catch (error) {
      print('Error toggling favorite: $error');
    }
  }

  Future<void> toggleCart() async {
    try {
      if (isInCart) {
        await CartService.removeFromCart(
          cartId: widget.product['cart_id'],
        );
        setState(() {
          isInCart = false;
        });
        print('Removed from Cart');
      } else {
        final response = await CartService.addToCart(
          userId: userId, // Use `userId` retrieved from AuthService
          productId: widget.product['id'],
          quantity: quantity,
        );
        setState(() {
          isInCart = true;
        });
        print('Added to Cart');
      }
    } catch (error) {
      print('Error toggling cart: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product['name'] ?? 'Product Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Center(
              child: Image.network(
                widget.product['image_url'] ?? '',
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.image_not_supported, size: 100);
                },
              ),
            ),
            SizedBox(height: 16),
            // Product Name
            Text(
              widget.product['name'] ?? 'Unnamed Product',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            // Product Price
            Text(
              '\$${widget.product['price'].toString()}',
              style: TextStyle(fontSize: 20, color: Colors.green),
            ),
            SizedBox(height: 16),
            // Quantity Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Quantity: ', style: TextStyle(fontSize: 16)),
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    if (quantity > 1) {
                      setState(() {
                        quantity--;
                      });
                    }
                  },
                ),
                Text(quantity.toString(), style: TextStyle(fontSize: 16)),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      quantity++;
                    });
                  },
                ),
              ],
            ),
            Spacer(),
            // Buttons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Favorite Button
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                  ),
                  iconSize: 32,
                  onPressed: toggleFavorite,
                ),
                // Add to Cart Button
                IconButton(
                  icon: Icon(
                    isInCart ? Icons.check : Icons.add,
                    color: isInCart ? Colors.green : Colors.grey,
                  ),
                  iconSize: 32,
                  onPressed: toggleCart,
                ),
                // Order Now Button
                ElevatedButton(
                  onPressed: () {
                    print('Order placed for product');
                  },
                  child: Text('Order Now'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
