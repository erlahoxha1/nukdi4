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
      builder:
          (_) => AlertDialog(
            title: Text('New Category'),
            content: TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Category Name'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  await _service.create(nameController.text, picked.path);
                  Navigator.pop(context);
                  _loadCategories();
                },
                child: Text('Create'),
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
      appBar: AppBar(
        title: Text('Manage Categories'),
        actions: [IconButton(icon: Icon(Icons.add), onPressed: _addCategory)],
      ),
      body:
          _loading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: _categories.length,
                itemBuilder: (_, index) {
                  final cat = _categories[index];
                  return ListTile(
                    leading: Image.network(
                      cat.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(cat.name),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteCategory(cat.id),
                    ),
                  );
                },
              ),
    );
  }
}
