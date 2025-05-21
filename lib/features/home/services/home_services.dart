import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:nukdi4/constants/error_handling.dart';
import 'package:nukdi4/constants/global_variables.dart';
import 'package:nukdi4/constants/utils.dart';
import 'package:nukdi4/models/product.dart';
import 'package:nukdi4/provider/user_provider.dart';

class HomeServices {
  Future<List<Product>> fetchCategoryProducts({
    required BuildContext context,
    required String category,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];

    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/products?category=$category'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          final List decoded = jsonDecode(res.body);
          for (var productMap in decoded) {
            print(
              "Fetched: ${productMap['name']} | Brand: ${productMap['carBrand']}, Model: ${productMap['carModel']}, Year: ${productMap['carYear']}",
            );

            productList.add(Product.fromMap(productMap));
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }

    return productList;
  }

  Future<Product> fetchDealOfDay({required BuildContext context}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    Product product = Product(
      name: '',
      description: '',
      quantity: 0,
      images: [],
      category: '',
      price: 0,
      carBrand: '',
      carModel: '',
      carYear: '',
    );

    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/deal-of-day'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          final map = jsonDecode(res.body);
          print(
            "Deal of Day: ${map['name']} | Brand: ${map['carBrand']}, Model: ${map['carModel']}, Year: ${map['carYear']}",
          );
          product = Product.fromMap(map);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }

    return product;
  }
}
