import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:nukdi4/features/home/screens/category_products_screen.dart';
import 'package:nukdi4/features/home/services/category_services.dart';
import 'package:nukdi4/features/home/services/home_services.dart';
import 'package:nukdi4/features/search/screens/filterscreen.dart';
import 'package:nukdi4/models/category.dart';
import 'package:nukdi4/models/product.dart';
import 'package:nukdi4/provider/user_provider.dart';
import 'package:nukdi4/features/product_details/screens/product_details_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CategoryService categoryService = CategoryService();
  final HomeServices homeServices = HomeServices();

  final ImagePicker picker = ImagePicker();

  List<Category> categories = [];
  List<Product> searchResults = [];
  bool loading = true;
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final cats = await categoryService.fetchAll();
    setState(() {
      categories = cats;
      loading = false;
    });
  }

  void searchProducts(String query) async {
    if (query.isEmpty) {
      setState(() {
        isSearching = false;
        searchResults = [];
      });
      return;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final results = await homeServices.searchProducts(
      context: context,
      query: query,
      token: userProvider.user.token,
    );

    setState(() {
      isSearching = true;
      searchResults = results;
    });
  }

  void navigateToCategory(Category category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => CategoryProductsScreen(
              categoryId: category.id,
              categoryName: category.name,
            ),
      ),
    );
  }

  void navigateToProduct(Product product) {
    Navigator.pushNamed(
      context,
      ProductDetailScreen.routeName,
      arguments: product,
    );
  }

  void navigateToFilter() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FilterScreen(onApply: (filteredProducts) {}),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: const Color.fromARGB(255, 104, 9, 9)), // dark red
          ClipPath(
            clipper: SteepDiagonalClipper(),
            child: Container(color: const Color(0xFF1C1C1E)), // dark grey
          ),
          SafeArea(
            child:
                loading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // SEARCH BAR
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                const Icon(Icons.search, color: Colors.grey),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    decoration: const InputDecoration(
                                      hintText: "Search part name",
                                      border: InputBorder.none,
                                    ),
                                    onChanged: searchProducts,
                                  ),
                                ),
                                if (isSearching)
                                  IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isSearching = false;
                                        searchResults = [];
                                      });
                                    },
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // HEADER
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                isSearching
                                    ? "Search Results"
                                    : "Explore Categories",
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                onTap: navigateToFilter,
                                child: const Icon(
                                  Icons.tune,
                                  color: Colors.white70,
                                  size: 28,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // GRID VIEW
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount:
                                isSearching
                                    ? searchResults.length
                                    : categories.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1,
                                  crossAxisSpacing: 14,
                                  mainAxisSpacing: 14,
                                ),
                            itemBuilder: (context, index) {
                              if (isSearching) {
                                final product = searchResults[index];
                                return GestureDetector(
                                  onTap: () => navigateToProduct(product),
                                  child: _buildItemContainer(
                                    imageUrl: product.images[0],
                                    label: product.name,
                                  ),
                                );
                              } else {
                                final category = categories[index];
                                return GestureDetector(
                                  onTap: () => navigateToCategory(category),
                                  child: _buildItemContainer(
                                    imageUrl: category.imageUrl,
                                    label: category.name,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            backgroundColor: Colors.white,
            builder: (context) {
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Part Identification',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        buildUploadButton(),
                        const SizedBox(height: 10),
                        buildUploadButton(),
                        const SizedBox(height: 10),
                        buildUploadButton(),
                        const SizedBox(height: 20),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Car Name: Toyota'),
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Year: 2005'),
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Car Part: ClockSpring'),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () {
                              // Handle suppliers link click
                            },
                            child: const Text(
                              'Suppliers',
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: FloatingActionButton(
                      mini: true,
                      backgroundColor: Colors.black,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.language, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildItemContainer({
    required String imageUrl,
    required String label,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              height: 90,
              width: 90,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.broken_image,
                  size: 60,
                  color: Colors.white,
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget buildUploadButton() {
    return ElevatedButton.icon(
      onPressed: () async {
        final XFile? image = await picker.pickImage(
          source: ImageSource.gallery,
        );

        if (image != null) {
          print('Selected image path: ${image.path}');
          // You can add upload or preview logic here
        } else {
          print('No image selected.');
        }
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: Colors.grey.shade200,
        foregroundColor: Colors.black,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      icon: const Icon(Icons.upload),
      label: const Text('Upload'),
    );
  }
}

class SteepDiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width, size.height * 0.3);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
