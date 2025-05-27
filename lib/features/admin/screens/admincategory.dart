import 'package:flutter/material.dart';
import 'package:nukdi4/features/admin/services/admin_services.dart';
import 'package:nukdi4/models/product.dart';

class AdminCategoryProductsScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const AdminCategoryProductsScreen({
    Key? key,
    required this.categoryId,
    required this.categoryName,
  }) : super(key: key);

  @override
  State<AdminCategoryProductsScreen> createState() => _AdminCategoryProductsScreenState();
}

class _AdminCategoryProductsScreenState extends State<AdminCategoryProductsScreen> {
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
      products = all.where((p) => p.categoryId == widget.categoryId).toList();
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
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 104, 9, 9),
        title: Text(
          widget.categoryName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: products.isEmpty
          ? const Center(
              child: Text(
                'No products in this category',
                style: TextStyle(color: Colors.white70),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 270,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final product = products[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          child: Image.network(
                            product.images[0],
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(Icons.broken_image, color: Colors.white70, size: 40),
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        child: Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                            IconButton(
                              onPressed: () => deleteProduct(product),
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                              splashRadius: 20,
                              tooltip: 'Delete product',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
