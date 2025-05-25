import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nukdi4/models/order.dart';
import 'package:nukdi4/models/product.dart';

class OrderDetailScreen extends StatelessWidget {
  static const routeName = '/order-details';

  const OrderDetailScreen({Key? key}) : super(key: key);

  String _statusText(int code) {
    switch (code) {
      case 0:
        return 'Pending';
      case 1:
        return 'Paid';
      case 2:
        return 'Shipped';
      case 3:
        return 'Delivered';
      default:
        return 'Unknown';
    }
  }

  Color _statusColor(int code) {
    switch (code) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.purple;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Order order = ModalRoute.of(context)!.settings.arguments as Order;
    final formattedDate = DateFormat(
      'dd MMM yyyy • HH:mm',
    ).format(DateTime.fromMillisecondsSinceEpoch(order.orderedAt));
    final df = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Order Details',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Summary card
                  Container(
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
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _twoCol('Order ID', order.id),
                        const SizedBox(height: 6),
                        _twoCol('Date', formattedDate),
                        const SizedBox(height: 6),
                        _twoCol('Address', order.address),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Text(
                              'Status',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _statusColor(
                                  order.status,
                                ).withOpacity(.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _statusText(order.status),
                                style: TextStyle(
                                  color: _statusColor(order.status),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 28, color: Colors.white24),
                        _twoCol(
                          'Total Paid',
                          df.format(order.totalPrice),
                          boldRight: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Items header
                  const Text(
                    'Items',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Items list
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: order.products.length,
                    itemBuilder: (context, idx) {
                      final Product p = order.products[idx];
                      final int qty = order.quantity[idx];
                      final double lineTotal = p.price * qty;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  p.images.isNotEmpty
                                      ? p.images[0]
                                      : 'https://via.placeholder.com/60',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      p.name,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'x$qty  •  ${df.format(p.price)}',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                df.format(lineTotal),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _twoCol(String left, String right, {bool boldRight = false}) => Row(
    children: [
      Text(
        left,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      const Spacer(),
      Flexible(
        child: Text(
          right,
          textAlign: TextAlign.end,
          style: TextStyle(
            fontWeight: boldRight ? FontWeight.w700 : FontWeight.w400,
            color: Colors.white70,
          ),
        ),
      ),
    ],
  );
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
