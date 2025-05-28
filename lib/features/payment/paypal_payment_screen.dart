import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:nukdi4/provider/user_provider.dart';

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

    await Future.delayed(const Duration(seconds: 2));

    try {
      final response = await http.post(
        Uri.parse('http://192.168.100.60:3000/api/save-order'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: json.encode({
          'totalPrice': widget.totalAmount,
          'address': widget.address,
          'status': 1,
          'orderedAt': DateTime.now().millisecondsSinceEpoch,
          'products': [],
        }),
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment Successful! Order saved.')),
        );
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
      body: Stack(
        children: [
          Container(color: const Color.fromARGB(255, 104, 9, 9)),
          ClipPath(
            clipper: DiagonalClipper(),
            child: Container(color: const Color(0xFF1C1C1E)),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 104, 9, 9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(6),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      "Pay with PayPal",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Shipping Address",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.address,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Total Amount",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "\$${widget.totalAmount.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : fakePayPalFlow,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          81,
                          168,
                          245,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child:
                          isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text(
                                "Continue with PayPal",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
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
