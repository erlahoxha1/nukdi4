import 'package:flutter/material.dart';
import 'package:nukdi4/constants/global_variables.dart';
import 'package:nukdi4/features/address/screens/address_screen.dart';
import 'package:nukdi4/features/cart/widgets/cart_product.dart';
import 'package:nukdi4/common/widgets/bottom_bar.dart';
import 'package:nukdi4/models/product.dart';
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
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.user;

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
      body: Stack(
        children: [
          Container(color: const Color.fromARGB(255, 104, 9, 9)),
          ClipPath(
            clipper: DiagonalClipper(),
            child: Container(color: const Color(0xFF1C1C1E)),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const Center(
                      child: Text(
                        'Shopping Cart',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildStepperBar(),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        const Text(
                          'Subtotal ',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        Text(
                          '\$${sum.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    if (isCartEmpty)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          '🛒 Your cart is empty. Add items to continue.',
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      )
                    else if (!hasAddress)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          '📬 Please save a shipping address before proceeding.',
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      )
                    else if (hasInvalidQuantity)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          '⚠️ Some items exceed available stock. Please adjust quantities.',
                          style: TextStyle(
                            color: Color.fromARGB(255, 104, 9, 9),
                          ),
                        ),
                      ),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          backgroundColor:
                              isProceedEnabled
                                  ? const Color.fromARGB(255, 104, 9, 9)
                                  : Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed:
                            isProceedEnabled
                                ? () => navigateToAddress(sum)
                                : null,
                        child: Text(
                          'Proceed to Buy (${user.cart.length} items)',
                          style: TextStyle(
                            fontSize: 18,
                            color:
                                isProceedEnabled
                                    ? Colors.white
                                    : const Color.fromARGB(255, 255, 255, 255),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: user.cart.length,
                      itemBuilder: (context, index) {
                        final product = Product.fromMap(
                          user.cart[index]['product'],
                        );
                        return Dismissible(
                          key: Key(product.id.toString()),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            color: Colors.redAccent,
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          onDismissed: (direction) {
                            setState(() {
                              user.cart.removeAt(index);
                              userProvider.notifyListeners();
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Item removed from cart'),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CartProduct(index: index),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    OutlinedButton.icon(
                      onPressed: goBackToShopping,
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      label: const Text(
                        'Go back to shopping',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white),
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
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
          backgroundColor:
              isActive
                  ? const Color.fromARGB(255, 104, 9, 9)
                  : Colors.grey.shade700,
          child: Icon(
            icon,
            size: 20,
            color: isActive ? Colors.white : Colors.white70,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isActive ? Colors.white : Colors.white70,
          ),
        ),
      ],
    );
  }
}

class DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width, 0);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
