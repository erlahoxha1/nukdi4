import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nukdi4/common/widgets/custom_button.dart';
import 'package:nukdi4/constants/global_variables.dart';
import 'package:nukdi4/common/widgets/custom_textfield.dart';
import 'package:nukdi4/constants/utils.dart';
import 'package:nukdi4/features/admin/services/admin_services.dart';
import 'package:nukdi4/features/home/services/category_services.dart';
import 'package:nukdi4/models/category.dart';

class AddProductScreen extends StatefulWidget {
  static const String routeName = '/add-product';
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController carBrandController = TextEditingController();
  final TextEditingController carModelController = TextEditingController();
  final TextEditingController carYearController = TextEditingController();

  final AdminServices adminServices = AdminServices();
  final CategoryService categoryService = CategoryService();
  final _addProductFormKey = GlobalKey<FormState>();

  List<Category> categories = [];
  String? selectedCategoryId;
  String? selectedCategoryName;
  bool loadingCategories = true;

  List<File> images = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final cats = await categoryService.fetchAll();
    setState(() {
      categories = cats;
      if (categories.isNotEmpty) {
        selectedCategoryId = categories.first.id;
        selectedCategoryName = categories.first.name;
      }
      loadingCategories = false;
    });
  }

  @override
  void dispose() {
    productNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
    carBrandController.dispose();
    carModelController.dispose();
    carYearController.dispose();
    super.dispose();
  }

  void sellProduct() {
    if (_addProductFormKey.currentState!.validate() &&
        images.isNotEmpty &&
        selectedCategoryId != null) {
      adminServices.sellProduct(
        context: context,
        name: productNameController.text,
        description: descriptionController.text,
        price: double.parse(priceController.text),
        quantity: double.parse(quantityController.text),
        categoryId: selectedCategoryId!,
        categoryName: selectedCategoryName!, // ✅ ADD THIS
        images: images,
        carBrand: carBrandController.text,
        carModel: carModelController.text,
        carYear: carYearController.text,
      );
    } else {
      showSnackBar(
        context,
        'Please fill all fields, select category, and add images',
      );
    }
  }

  void selectImages() async {
    var res = await pickImages();
    setState(() {
      images.addAll(res);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: const Text(
            'Add Product',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _addProductFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ...images.map(
                      (file) => ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          file,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: selectImages,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.add, size: 30),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: productNameController,
                  hintText: 'Product Name',
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Please enter the product name'
                              : null,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: descriptionController,
                  hintText: 'Description',
                  maxLines: 5,
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Please enter the description'
                              : null,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: priceController,
                  hintText: 'Price',
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Please enter the price';
                    if (double.tryParse(value) == null)
                      return 'Price must be a number';
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: quantityController,
                  hintText: 'Quantity',
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Please enter the quantity';
                    if (double.tryParse(value) == null)
                      return 'Quantity must be a number';
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: carBrandController,
                  hintText: 'Car Brand',
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Please enter the car brand'
                              : null,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: carModelController,
                  hintText: 'Car Model',
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Please enter the car model'
                              : null,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: carYearController,
                  hintText: 'Car Year',
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Please enter the car year'
                              : null,
                ),
                const SizedBox(height: 10),
                loadingCategories
                    ? const Center(child: CircularProgressIndicator())
                    : DropdownButtonFormField<String>(
                      value: selectedCategoryId,
                      hint: const Text('Select Category'),
                      items:
                          categories.map((cat) {
                            return DropdownMenuItem<String>(
                              value: cat.id,
                              child: Text(cat.name),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategoryId = value ?? '';
                          selectedCategoryName =
                              categories
                                  .firstWhere(
                                    (cat) => cat.id == value,
                                    orElse:
                                        () => Category(
                                          id: '',
                                          name: '',
                                          imageUrl: '',
                                        ),
                                  )
                                  .name;
                        });
                      },
                    ),
                const SizedBox(height: 10),
                CustomButton(text: 'Sell', onTap: sellProduct),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
