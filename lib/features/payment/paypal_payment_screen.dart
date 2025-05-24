import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:nukdi4/provider/user_provider.dart'; // ✅ adjust this path if needed

class PaypalPaymentScreen extends StatefulWidget {
  static const String routeName = '/paypal-payment';

  final String address;
  final double totalAmount;

  const PaypalPaymentScreen({
    Key? key,
    required this.address,
    required this.totalAmount,
  }) : super(key: key);

  @override
  State<PaypalPaymentScreen> createState() => _PaypalPaymentScreenState();
}

class _PaypalPaymentScreenState extends State<PaypalPaymentScreen> {
  bool isLoading = false;

  Future<void> fakePayPalFlow() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    setState(() {
      isLoading = true;
    });

    // Simulate a delay to mimic redirecting to PayPal and back
    await Future.delayed(const Duration(seconds: 2));

    try {
      // Make a POST request to your backend to save the order
      final response = await http.post(
        Uri.parse('http://192.168.1.49:3000/api/save-order'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token, // ✅ pass the token here
        },
        body: json.encode({
          'totalPrice': widget.totalAmount, // ✅ corrected field name
          'address': widget.address,
          'status': 1, // ✅ pass as number (1 = Paid)
          'orderedAt':
              DateTime.now().millisecondsSinceEpoch, // ✅ pass as number
          'products':
              [], // ✅ empty array (you can fill with real cart items later)
        }),
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment Successful! Order saved.')),
        );

        // Navigate to success screen or pop back
        Navigator.pop(context, 'Payment Success!');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save order: ${response.body}')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pay with PayPal")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Address: ${widget.address}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              "Total: \$${widget.totalAmount.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: isLoading ? null : fakePayPalFlow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 32,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child:
                    isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                          "Continue with PayPal",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
