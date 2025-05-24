import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class PayPalPaymentScreen extends StatefulWidget {
  @override
  _PayPalPaymentScreenState createState() => _PayPalPaymentScreenState();
}

class _PayPalPaymentScreenState extends State<PayPalPaymentScreen> {
  bool isLoading = false;

  Future<void> launchPayPal() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.post(
      Uri.parse('http://192.168.1.49:3000/api/create-paypal-order'),
      headers: {'Content-Type': 'application/json'},
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final approvalUrl = jsonResponse['approvalUrl'];

      if (await canLaunchUrl(Uri.parse(approvalUrl))) {
        await launchUrl(
          Uri.parse(approvalUrl),
          mode: LaunchMode.externalApplication,
        );

        // ✅ After launching, you can mark the order as completed or show success
        // For example:
        Navigator.pop(context, 'Payment Successful!');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Payment successful!')));
      } else {
        throw 'Could not launch PayPal URL';
      }
    } else {
      print('Failed to create PayPal order: ${response.body}');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to create PayPal order')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pay with PayPal')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Address: trr, 4444, tr, tr', // Replace with dynamic address if needed
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            const Text(
              'Total: \$3.00', // Replace with dynamic total if needed
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed:
                    isLoading
                        ? null
                        : () {
                          print('✅ Launching PayPal payment...');
                          launchPayPal();
                        },
                child:
                    isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                          'Continue with PayPal',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
