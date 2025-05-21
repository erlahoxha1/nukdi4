import 'package:flutter/material.dart';
import 'package:nukdi4/constants/global_variables.dart';
import 'package:nukdi4/features/product_details/services/product_details_services.dart';
import 'package:nukdi4/models/product.dart';
import 'package:nukdi4/constants/utils.dart';

class ProductDetailScreen extends StatefulWidget {
  static const String routeName = '/product-details';
  final Product product;

  const ProductDetailScreen({Key? key, required this.product})
    : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductDetailsServices productDetailsServices =
      ProductDetailsServices();
  int userQuantity = 1;

  void addToCart() {
    print('📦 DEBUG: Add to Cart pressed');
    print('Product Name: ${widget.product.name}');
    print('carBrand: ${widget.product.carBrand}');
    print('carModel: ${widget.product.carModel}');
    print('carYear: ${widget.product.carYear}');

    if (userQuantity <= widget.product.quantity) {
      if (widget.product.carBrand.isEmpty ||
          widget.product.carModel.isEmpty ||
          widget.product.carYear.isEmpty) {
        showSnackBar(context, 'Error: Product is missing car information.');
        return;
      }

      productDetailsServices.addToCart(
        context: context,
        product: widget.product,
        quantity: userQuantity,
      );

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Added to Cart'),
            content: const Text(
              'Do you want to go to your cart or continue shopping?',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Continue Shopping'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/cart');
                },
                child: const Text('Go to Cart'),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot add more than stock available')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: GlobalVariables.selectedNavBarColor,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.lightBlueAccent),
              onPressed: () => Navigator.pop(context),
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
                shape: const CircleBorder(),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.product.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const Icon(Icons.favorite_border, color: Colors.white),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              widget.product.images[0],
              height: 250,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.product.description,
                      style: const TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Text("Quantity:", style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            if (userQuantity > 1) {
                              setState(() {
                                userQuantity--;
                              });
                            }
                          },
                        ),
                        Text(
                          '$userQuantity',
                          style: const TextStyle(fontSize: 16),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            if (userQuantity < widget.product.quantity) {
                              setState(() {
                                userQuantity++;
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('No stock available'),
                                ),
                              );
                            }
                          },
                        ),
                        const Spacer(),
                        Text(
                          '${widget.product.quantity} in stock',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          '\$${widget.product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                GlobalVariables.selectedNavBarColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          onPressed: addToCart,
                          child: const Text(
                            'Add to Cart',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
