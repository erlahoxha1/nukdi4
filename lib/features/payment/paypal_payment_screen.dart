import 'package:flutter/material.dart';

class PaypalPaymentScreen extends StatelessWidget {
  static const String routeName = '/paypal-payment';

  final String address;
  final double totalAmount;

  const PaypalPaymentScreen({
    Key? key,
    required this.address,
    required this.totalAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pay with PayPal")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Address: $address", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text(
              "Total: \$${totalAmount.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // 👉 Here you'll trigger PayPal SDK / API (not implemented)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("PayPal payment coming soon!"),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 32,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Continue with PayPal"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
