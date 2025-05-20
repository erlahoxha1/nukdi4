import 'package:flutter/material.dart';
import 'package:nukdi4/common/widgets/custom_button.dart';
import 'package:nukdi4/constants/global_variables.dart';
import 'package:nukdi4/features/address/screens/address_screen.dart';
import 'package:nukdi4/features/cart/widgets/cart_product.dart';
import 'package:nukdi4/common/widgets/bottom_bar.dart'; // ✅ Use BottomBar, not HomeScreen
import 'package:nukdi4/provider/user_provider.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void navigateToAddress(int sum) {
    Navigator.pushNamed(
      context,
      AddressScreen.routeName,
      arguments: sum.toString(),
    );
  }

  void goBackToShopping() {
    // ✅ This will restore the bottom bar and navigate to home tab
    Navigator.pushReplacementNamed(context, BottomBar.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    int sum = 0;
    user.cart
        .map((e) => sum += e['quantity'] * e['product']['price'] as int)
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Shopping Cart',
          style: TextStyle(fontSize: 22, color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.blue),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
          child: Column(
            children: [
              const SizedBox(height: 10),
              _buildStepperBar(),
              const SizedBox(height: 20),

              // Subtotal + Proceed button
              Row(
                children: [
                  const Text('Subtotal ', style: TextStyle(fontSize: 18)),
                  Text(
                    '\$$sum',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => navigateToAddress(sum),
                  child: Text(
                    'Proceed to Buy (${user.cart.length} items)',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              // Cart items
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: user.cart.length,
                itemBuilder: (context, index) {
                  return CartProduct(index: index);
                },
              ),

              // Go Back to Shopping
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: goBackToShopping,
                icon: const Icon(Icons.arrow_back),
                label: const Text('Go back to shopping'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepperBar() {
    return Row(
      children: [
        _buildStep(icon: Icons.shopping_cart, label: 'Cart', isActive: true),
        const Expanded(child: Divider(thickness: 1, color: Colors.grey)),
        _buildStep(icon: Icons.payment, label: 'Checkout', isActive: false),
        const Expanded(child: Divider(thickness: 1, color: Colors.grey)),
        _buildStep(icon: Icons.receipt_long, label: 'Order', isActive: false),
      ],
    );
  }

  Widget _buildStep({
    required IconData icon,
    required String label,
    required bool isActive,
  }) {
    return Column(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: isActive ? Colors.blue : Colors.grey.shade300,
          child: Icon(
            icon,
            size: 20,
            color: isActive ? Colors.white : Colors.black45,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isActive ? Colors.black : Colors.grey,
          ),
        ),
      ],
    );
  }
}
