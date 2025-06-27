import 'package:flutter/material.dart';
import 'package:product_mobile/api/api_service.dart';
import 'package:product_mobile/models/product.dart';
import 'package:product_mobile/screens/products/product_details.dart';
import 'package:product_mobile/screens/products/product_form.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _refreshProducts();
  }

  Future<void> _refreshProducts() async {
    setState(() {
      _productsFuture = Provider.of<ApiService>(
        context,
        listen: false,
      ).getProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductFormScreen()),
              ).then((_) => _refreshProducts());
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshProducts,
        child: FutureBuilder<List<Product>>(
          future: _productsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No products found'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final product = snapshot.data![index];
                  return ListTile(
                    title: Text(product.name),
                    subtitle: Text(product.formattedPrice),
                    trailing: Text('Qty: ${product.quantity}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailScreen(productId: product.id),
                        ),
                      ).then((_) => _refreshProducts());
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
