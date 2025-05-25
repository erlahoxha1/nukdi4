import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nukdi4/models/order.dart';
import 'package:nukdi4/models/product.dart';

class OrderDetailScreen extends StatelessWidget {
  static const routeName = '/order-details';

  const OrderDetailScreen({Key? key}) : super(key: key);

  /* ───────────────────────── Helpers ───────────────────────── */

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

  /* ─────────────────────────  UI  ───────────────────────── */

  @override
  Widget build(BuildContext context) {
    final Order order = ModalRoute.of(context)!.settings.arguments as Order;

    final formattedDate = DateFormat(
      'dd MMM yyyy • HH:mm',
    ).format(DateTime.fromMillisecondsSinceEpoch(order.orderedAt));

    final df = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return Scaffold(
      appBar: AppBar(title: const Text('Order Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /* ── Order Summary Card ── */
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
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
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _statusColor(order.status).withOpacity(.15),
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
                    const Divider(height: 28),
                    _twoCol(
                      'Total Paid',
                      df.format(order.totalPrice),
                      boldRight: true,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /* ── Items header ── */
            const Text(
              'Items',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),

            /* ── Items list ── */
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
                  child: Row(
                    children: [
                      /* thumbnail */
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
                      /* description */
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.name,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text('x$qty  •  ${df.format(p.price)}'),
                          ],
                        ),
                      ),
                      /* line total */
                      Text(
                        df.format(lineTotal),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /* helper for summary key-value rows */
  Widget _twoCol(String left, String right, {bool boldRight = false}) => Row(
    children: [
      Text(left, style: const TextStyle(fontWeight: FontWeight.w600)),
      const Spacer(),
      Flexible(
        child: Text(
          right,
          textAlign: TextAlign.end,
          style: TextStyle(
            fontWeight: boldRight ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    ],
  );
}
