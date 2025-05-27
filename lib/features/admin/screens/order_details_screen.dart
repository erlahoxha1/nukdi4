import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nukdi4/models/order.dart';
import 'package:nukdi4/models/product.dart';
import 'package:nukdi4/features/admin/services/admin_services.dart';

class AdminOrderDetailScreen extends StatelessWidget {
  static const routeName = '/admin-order-details';

  final Order order;
  const AdminOrderDetailScreen({Key? key, required this.order}) : super(key: key);

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
    final formattedDate = DateFormat('dd MMM yyyy • HH:mm').format(
      DateTime.fromMillisecondsSinceEpoch(order.orderedAt),
    );
    final df = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 104, 9, 9),
        title: const Text('Admin Order Details'),
      ),
      backgroundColor: const Color(0xFF1C1C1E),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _twoCol('Order ID', order.id),
            _twoCol('Date', formattedDate),
            _twoCol('Address', order.address),
            Row(
              children: [
                const Text(
                  'Status',
                  style: TextStyle(color: Colors.white),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor(order.status).withOpacity(0.2),
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
            const Divider(height: 30, color: Colors.white24),
            _twoCol('Total Paid', df.format(order.totalPrice), boldRight: true),

            const SizedBox(height: 20),
            const Text(
              'Items',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              itemCount: order.products.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final Product product = order.products[index];
                final int qty = order.quantity[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      product.images.isNotEmpty ? product.images[0] : '',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.broken_image, color: Colors.white38),
                    ),
                  ),
                  title: Text(product.name, style: const TextStyle(color: Colors.white)),
                  subtitle: Text('x$qty', style: const TextStyle(color: Colors.white70)),
                  trailing: Text(
                    df.format(product.price * qty),
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              },
            ),

            if (order.status < 3)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 104, 9, 9),
                  ),
                  onPressed: () {
                    final nextStatus = order.status + 1;
                    AdminServices().changeOrderStatus(
                      context: context,
                      status: nextStatus,
                      order: order,
                      onSuccess: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Order marked as ${_statusText(nextStatus)}',
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Text('Mark as ${_statusText(order.status + 1)}'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _twoCol(String label, String value, {bool boldRight = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            Flexible(
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: boldRight ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      );
}
