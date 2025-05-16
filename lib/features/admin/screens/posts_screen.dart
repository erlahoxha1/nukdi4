import 'package:flutter/material.dart';
import 'package:nukdi2/features/admin/screens/add_product_screen.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({Key? key}) : super(key: key);

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  void navigateToAddProduct() {
    Navigator.pushNamed(context, AddProductScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text('Products')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: navigateToAddProduct,
        tooltip: 'Add Product',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
