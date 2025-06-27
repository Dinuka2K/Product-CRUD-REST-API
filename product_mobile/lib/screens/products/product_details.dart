import 'package:flutter/material.dart';
import 'package:product_mobile/api/api_service.dart';
import 'package:product_mobile/models/product.dart';
import 'package:product_mobile/screens/products/product_form.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  ProductDetailScreen({required this.productId});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Future<Product> _productFuture;

  @override
  void initState() {
    super.initState();
    _productFuture = Provider.of<ApiService>(
      context,
      listen: false,
    ).getProductById(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product Details')),
      body: FutureBuilder<Product>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Product not found'));
          } else {
            final product = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${product.name}', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 8),
                  Text(
                    'Price: ${product.formattedPrice}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Quantity: ${product.quantity}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductFormScreen(product: product),
                            ),
                          ).then(
                            (_) => setState(() {
                              _productFuture = Provider.of<ApiService>(
                                context,
                                listen: false,
                              ).getProductById(widget.productId);
                            }),
                          );
                        },
                        child: Text('Edit'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            await Provider.of<ApiService>(
                              context,
                              listen: false,
                            ).deleteProduct(product.id);
                            Navigator.pop(context);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to delete product: $e'),
                              ),
                            );
                          }
                        },
                        child: Text('Delete'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
