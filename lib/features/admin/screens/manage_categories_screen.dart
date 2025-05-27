import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nukdi4/features/home/services/category_services.dart';
import 'package:nukdi4/models/category.dart';

class ManageCategoriesScreen extends StatefulWidget {
  @override
  _ManageCategoriesScreenState createState() => _ManageCategoriesScreenState();
}

class _ManageCategoriesScreenState extends State<ManageCategoriesScreen> {
  final CategoryService _service = CategoryService();
  List<Category> _categories = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final cats = await _service.fetchAll();
    setState(() {
      _categories = cats;
      _loading = false;
    });
  }

  Future<void> _addCategory() async {
    final nameController = TextEditingController();
    XFile? picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2E),
        title: const Text(
          'New Category',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: nameController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'Category Name',
            labelStyle: TextStyle(color: Colors.white70),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white30),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () async {
              await _service.create(nameController.text, picked.path);
              Navigator.pop(context);
              _loadCategories();
            },
            child: const Text('Create', style: TextStyle(color: Colors.greenAccent)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteCategory(String id) async {
    await _service.delete(id);
    _loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 104, 9, 9),
        title: const Text(
          'Manage Categories',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: _addCategory,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (_, index) {
                final cat = _categories[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        cat.imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, color: Colors.white38),
                      ),
                    ),
                    title: Text(
                      cat.name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      onPressed: () => _deleteCategory(cat.id),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
