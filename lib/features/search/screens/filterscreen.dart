import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:nukdi4/provider/user_provider.dart';
import 'package:nukdi4/models/product.dart';
import 'package:nukdi4/features/product_details/screens/product_details_screen.dart';

class FilterScreen extends StatefulWidget {
  static const String routeName = '/filter';
  final Function(List<dynamic>) onApply;

  const FilterScreen({super.key, required this.onApply});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String selectedBrand = '';
  String selectedModel = '';
  String selectedYear = '';

  bool isLoading = false;
  List<dynamic> filteredProducts = [];

  Future<void> fetchFilteredProducts() async {
    setState(() => isLoading = true);

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final token = userProvider.user.token;

    final uri = Uri.parse(
      'http://192.168.1.49:3000/api/products/filter'
      '?brand=$selectedBrand&model=$selectedModel&year=$selectedYear',
    );

    try {
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );

      if (response.statusCode == 200) {
        final List<dynamic> products = json.decode(response.body);
        setState(() {
          filteredProducts = products;
          isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${response.body}')));
        setState(() => isLoading = false);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Request failed: $e')));
      setState(() => isLoading = false);
    }
  }

  void navigateToProductDetail(dynamic productMap) {
    final product = Product.fromMap(productMap);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Filter Products')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Car Brand'),
              onChanged: (value) => selectedBrand = value,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Car Model'),
              onChanged: (value) => selectedModel = value,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Car Year'),
              keyboardType: TextInputType.number,
              onChanged: (value) => selectedYear = value,
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: fetchFilteredProducts,
                  child: const Text('Apply Filter'),
                ),
            const SizedBox(height: 20),
            Expanded(
              child:
                  filteredProducts.isEmpty
                      ? const Text('No products found.')
                      : ListView.builder(
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return GestureDetector(
                            onTap: () => navigateToProductDetail(product),
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    blurRadius: 5,
                                    offset: const Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['name'] ?? 'No name',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text("Price: \$${product['price'] ?? 'N/A'}"),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
