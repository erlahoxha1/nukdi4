import 'package:flutter/material.dart';
import 'package:nukdi4/features/address/services/address_services.dart';
import 'package:nukdi4/features/payment/paypal_payment_screen.dart';
import 'package:nukdi4/provider/user_provider.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatelessWidget {
  static const String routeName = '/address';
  final String totalAmount;

  const AddressScreen({Key? key, required this.totalAmount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final address = context.watch<UserProvider>().user.address;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back, size: 28),
              ),
              const SizedBox(height: 10),
              _buildStepperBar(),
              const SizedBox(height: 30),
              const Text(
                "Your Shipping Address",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade100,
                  border: Border.all(color: Colors.black12),
                ),
                child: Text(address, style: const TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 30),
              const Text(
                "Do you want to continue with this address?",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      PaypalPaymentScreen.routeName,
                      arguments: {
                        'address': address,
                        'totalAmount': double.parse(totalAmount),
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    "Yes, Continue to Payment",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/add-address');
                },
                icon: const Icon(Icons.edit_location_alt_outlined, size: 20),
                label: const Text(
                  "No, Change Address",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  side: const BorderSide(color: Colors.black12),
                  foregroundColor: Colors.black87,
                  minimumSize: const Size.fromHeight(50),
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
        _buildStep(icon: Icons.shopping_cart, label: 'Cart', isActive: false),
        const Expanded(child: Divider(thickness: 1, color: Colors.grey)),
        _buildStep(icon: Icons.payment, label: 'Checkout', isActive: true),
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
