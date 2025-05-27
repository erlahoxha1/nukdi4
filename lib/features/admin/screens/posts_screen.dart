import 'package:flutter/material.dart';
import 'package:nukdi4/features/admin/screens/add_product_screen.dart';
import 'package:nukdi4/features/admin/screens/admincategory.dart';
import 'package:nukdi4/features/home/services/category_services.dart';
import 'package:nukdi4/models/category.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({Key? key}) : super(key: key);

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final CategoryService categoryService = CategoryService();
  List<Category> categories = [];
  bool loading = true;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 104, 9, 9),
        title: const Text(
          'Product Categories',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : categories.isEmpty
              ? const Center(
                  child: Text(
                    'No categories found',
                    style: TextStyle(color: Colors.white70),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: GridView.builder(
                    itemCount: categories.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 3 / 2,
                    ),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AdminCategoryProductsScreen(
                                categoryId: category.id,
                                categoryName: category.name,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 8,
                                offset: const Offset(2, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              category.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 104, 9, 9),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddProductScreen()),
          );
        },
        child: const Icon(Icons.add, size: 28, color: Colors.white),
      ),
    );
  }
}
