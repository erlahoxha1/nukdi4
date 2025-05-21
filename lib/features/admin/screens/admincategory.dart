import 'package:flutter/material.dart';
import 'package:nukdi4/features/admin/services/admin_services.dart';
import 'package:nukdi4/models/product.dart';

class AdminCategoryProductsScreen extends StatefulWidget {
  final String category;
  const AdminCategoryProductsScreen({super.key, required this.category});

  @override
  State<AdminCategoryProductsScreen> createState() =>
      _AdminCategoryProductsScreenState();
}

class _AdminCategoryProductsScreenState
    extends State<AdminCategoryProductsScreen> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  void fetchProducts() async {
    final all = await AdminServices().fetchAllProducts(context);
    if (!mounted) return;
    setState(() {
      products = all.where((p) => p.category == widget.category).toList();
    });
  }

  void deleteProduct(Product product) {
    AdminServices().deleteProduct(
      context: context,
      product: product,
      onSuccess: () {
        if (!mounted) return;
        setState(() {
          products.remove(product);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category)),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 250,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (context, index) {
          final product = products[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Image.network(
                  product.images[0],
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              Text(product.name, maxLines: 1),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => deleteProduct(product),
              ),
            ],
          );
        },
      ),
    );
  }
}
