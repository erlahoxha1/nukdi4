import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nukdi4/common/widgets/loader.dart';
import 'package:nukdi4/constants/global_variables.dart';
import 'package:nukdi4/features/order_details/screens/order_details.dart';
import 'package:nukdi4/models/order.dart';
import 'package:nukdi4/provider/user_provider.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Order>? orders;
  final placeholder =
      'https://via.placeholder.com/80x80.png?text=No+Image'; // fallback thumbnail

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  /* ────────────────────────── API CALL ────────────────────────── */

  Future<void> fetchOrders() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final res = await http.get(
        Uri.parse('$uri/api/orders/me'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          orders = (data as List)
              .map((e) => Order.fromMap(e))
              .toList(growable: false);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load orders (${res.statusCode})')),
        );
        setState(() => orders = []);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
      setState(() => orders = []);
    }
  }

  /* ───────────────────────────  UI  ─────────────────────────── */

  @override
  Widget build(BuildContext context) {
    // 1) still loading
    if (orders == null) {
      return const Scaffold(body: Loader());
    }

    // 2) empty list
    if (orders!.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Your Orders')),
        body: const Center(child: Text('You haven’t placed any orders yet.')),
      );
    }

    // 3) list of orders
    return Scaffold(
      appBar: AppBar(title: const Text('Your Orders')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders!.length,
        itemBuilder: (context, index) {
          final order = orders![index];

          final hasProduct = order.products.isNotEmpty;
          final product = hasProduct ? order.products[0] : null;
          final imageUrl =
              (hasProduct && product!.images.isNotEmpty)
                  ? product.images[0]
                  : placeholder;

          return GestureDetector(
            onTap:
                hasProduct
                    ? () => Navigator.pushNamed(
                      context,
                      OrderDetailScreen.routeName,
                      arguments: order,
                    )
                    : null,
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: Image.network(imageUrl, fit: BoxFit.cover),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Text(
                        hasProduct ? product!.name : 'Empty order',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
