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
  final placeholder = 'https://via.placeholder.com/80x80.png?text=No+Image';

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

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

  @override
  Widget build(BuildContext context) {
    if (orders == null) {
      return const Scaffold(body: Loader());
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(color: const Color(0xFF680909)), // dark red
          ClipPath(
            clipper: SteepDiagonalClipper(),
            child: Container(
              color: const Color(0xFF1C1C1E),
            ), // dark gray overlay
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Your Orders',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child:
                      orders!.isEmpty
                          ? const Center(
                            child: Text(
                              'You haven’t placed any orders yet.',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 18,
                              ),
                            ),
                          )
                          : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: orders!.length,
                            itemBuilder: (context, index) {
                              final order = orders![index];
                              final hasProduct = order.products.isNotEmpty;
                              final product =
                                  hasProduct ? order.products[0] : null;
                              final imageUrl =
                                  (hasProduct && product!.images.isNotEmpty)
                                      ? product.images[0]
                                      : placeholder;

                              return InkWell(
                                onTap:
                                    hasProduct
                                        ? () => Navigator.pushNamed(
                                          context,
                                          OrderDetailScreen.routeName,
                                          arguments: order,
                                        )
                                        : null,
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(16),
                                          bottomLeft: Radius.circular(16),
                                        ),
                                        child: Image.network(
                                          imageUrl,
                                          width: 100,
                                          height: 80,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Text(
                                          hasProduct
                                              ? product!.name
                                              : 'Empty order',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(right: 12),
                                        child: Icon(
                                          Icons.chevron_right,
                                          color: Colors.white70,
                                          size: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SteepDiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width, size.height * 0.3);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
