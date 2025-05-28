import 'dart:ui';
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
      'http://192.168.100.60:3000/api/products/filter'
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
      body: Stack(
        children: [
          Container(color: const Color.fromARGB(255, 91, 6, 6)),
          ClipPath(
            clipper: DiagonalClipper(),
            child: Container(color: const Color(0xFF1C1C1E)),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildCustomTopBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildGlassInput(
                          'Car Brand',
                          (value) => selectedBrand = value,
                        ),
                        const SizedBox(height: 12),
                        _buildGlassInput(
                          'Car Model',
                          (value) => selectedModel = value,
                        ),
                        const SizedBox(height: 12),
                        _buildGlassInput(
                          'Car Year',
                          (value) => selectedYear = value,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 20),
                        isLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  91,
                                  6,
                                  6,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                'Apply Filter',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              onPressed: fetchFilteredProducts,
                            ),
                        const SizedBox(height: 20),
                        filteredProducts.isEmpty
                            ? const Text(
                              'No products found.',
                              style: TextStyle(color: Colors.white),
                            )
                            : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: filteredProducts.length,
                              itemBuilder: (context, index) {
                                final product = filteredProducts[index];
                                return GestureDetector(
                                  onTap: () => navigateToProductDetail(product),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.5),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: Image.network(
                                            product['images'][0],
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                            errorBuilder: (
                                              context,
                                              error,
                                              stackTrace,
                                            ) {
                                              return Container(
                                                width: 60,
                                                height: 60,
                                                color: Colors.grey,
                                                child: const Icon(
                                                  Icons.broken_image,
                                                  color: Colors.white,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                product['name'] ?? 'No name',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                "\$${product['price'] ?? 'N/A'}",
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 91, 6, 6),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          const SizedBox(width: 20),
          const Text(
            'Filter Products',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassInput(
    String label,
    Function(String) onChanged, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: TextField(
            style: const TextStyle(color: Colors.white),
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: label,
              hintStyle: const TextStyle(color: Colors.white70),
              border: InputBorder.none,
            ),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}

class DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width, 0);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
