import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nukdi4/common/widgets/custom_button.dart';
import 'package:nukdi4/constants/global_variables.dart';
import 'package:nukdi4/common/widgets/custom_textfield.dart';
import 'package:nukdi4/constants/utils.dart';
import 'package:nukdi4/features/admin/services/admin_services.dart';

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
  final _addProductFormKey = GlobalKey<FormState>();

  String category = 'Controller';
  List<File> images = [];

  List<String> productCategories = [
    'Controller',
    'EV Charger',
    'Motor',
    'Charger',
    'Battery',
  ];

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
    if (_addProductFormKey.currentState!.validate() && images.isNotEmpty) {
      adminServices.sellProduct(
        context: context,
        name: productNameController.text,
        description: descriptionController.text,
        price: double.parse(priceController.text),
        quantity: double.parse(quantityController.text),
        category: category,
        images: images,
        carBrand: carBrandController.text,
        carModel: carModelController.text,
        carYear: carYearController.text,
      );
    } else {
      showSnackBar(context, 'Please fill all fields and add images');
    }
  }

  void selectImages() async {
    var res = await pickImages();
    setState(() {
      images.addAll(res); // Append selected images
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the product name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: descriptionController,
                  hintText: 'Description',
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: priceController,
                  hintText: 'Price',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Price must be a number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: quantityController,
                  hintText: 'Quantity',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the quantity';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Quantity must be a number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: carBrandController,
                  hintText: 'Car Brand',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the car brand';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: carModelController,
                  hintText: 'Car Model',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the car model';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: carYearController,
                  hintText: 'Car Year',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the car year';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: DropdownButton(
                    value: category,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: productCategories.map((String item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (String? newVal) {
                      setState(() {
                        category = newVal!;
                      });
                    },
                  ),
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
