import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nukdi4/constants/error_handling.dart';
import 'package:nukdi4/constants/global_variables.dart';
import 'package:nukdi4/constants/utils.dart';
import 'package:nukdi4/models/order.dart';
import 'package:nukdi4/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nukdi4/features/auth/screens/auth_screen.dart';

class AccountServices {
  /* ───────────────────────── MY ORDERS ───────────────────────── */

  Future<List<Order>> fetchMyOrders({required BuildContext context}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final List<Order> orderList = [];

    try {
      final res = await http.get(
        Uri.parse('$uri/api/orders/me'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          final data = jsonDecode(res.body);
          if (data is List) {
            for (final item in data) {
              try {
                orderList.add(Order.fromMap(item));
              } catch (_) {
                // Skip malformed item but keep going
              }
            }
          }
        },
      );
    } catch (e) {
      showSnackBar(context, 'Error fetching orders: $e');
    }

    // Always return a list (possibly empty)
    return orderList;
  }

  /* ─────────────────────────── LOG-OUT ────────────────────────── */

  Future<void> logOut(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('x-auth-token');

      // Clear provider state if you keep user info there
      // Provider.of<UserProvider>(context, listen: false).clear();

      Navigator.pushNamedAndRemoveUntil(
        context,
        AuthScreen.routeName,
        (_) => false,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
