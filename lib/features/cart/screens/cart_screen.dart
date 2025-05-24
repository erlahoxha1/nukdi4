import 'package:flutter/material.dart';
import 'package:nukdi4/constants/global_variables.dart';
import 'package:nukdi4/features/address/screens/address_screen.dart';
import 'package:nukdi4/features/cart/widgets/cart_product.dart';
import 'package:nukdi4/common/widgets/bottom_bar.dart';
import 'package:nukdi4/provider/user_provider.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void navigateToAddress(double sum) {
    Navigator.pushNamed(
      context,
      AddressScreen.routeName,
      arguments: sum.toStringAsFixed(2),
    );
  }

  void goBackToShopping() {
    Navigator.pushReplacementNamed(context, BottomBar.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    double sum = 0;
    bool hasInvalidQuantity = false;

    for (var e in user.cart) {
      final quantity = int.tryParse(e['quantity'].toString()) ?? 0;

      final product = e['product'];
      sum += quantity * product['price'];

      if (quantity > product['quantity']) {
        hasInvalidQuantity = true;
      }
    }

    final bool isCartEmpty = user.cart.isEmpty;
    final bool hasAddress = user.address.trim().isNotEmpty;
    final bool isProceedEnabled =
        !isCartEmpty && hasAddress && !hasInvalidQuantity;

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

              // Subtotal
              Row(
                children: [
                  const Text('Subtotal ', style: TextStyle(fontSize: 18)),
                  Text(
                    '\$${sum.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // ❗ Explanation if disabled
              if (isCartEmpty)
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    '🛒 Your cart is empty. Add items to continue.',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                )
              else if (!hasAddress)
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    '📬 Please save a shipping address before proceeding.',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                )
              else if (hasInvalidQuantity)
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    '⚠️ Some items exceed available stock. Please adjust quantities.',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),

              // ✅ Proceed button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    backgroundColor:
                        isProceedEnabled ? Colors.blue : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed:
                      isProceedEnabled ? () => navigateToAddress(sum) : null,
                  child: Text(
                    'Proceed to Buy (${user.cart.length} items)',
                    style: TextStyle(
                      fontSize: 18,
                      color: isProceedEnabled ? Colors.white : Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Cart items
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: user.cart.length,
                itemBuilder: (context, index) {
                  return CartProduct(index: index);
                },
              ),

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
