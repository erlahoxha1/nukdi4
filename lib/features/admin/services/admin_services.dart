import 'dart:convert';
import 'dart:io';
import 'package:nukdi4/constants/error_handling.dart';
import 'package:nukdi4/constants/global_variables.dart';
import 'package:nukdi4/constants/utils.dart';
import 'package:nukdi4/features/admin/models/sales.dart';
import 'package:nukdi4/models/order.dart';
import 'package:nukdi4/models/product.dart';
import 'package:nukdi4/provider/user_provider.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';


class AdminServices {
  void sellProduct({
    required BuildContext context,
    required String name,
    required String description,
    required double price,
    required double quantity,
    required String categoryId, // backend expects this as 'category'
    required String categoryName, // we pass name too
    required List<File> images,
    required String carBrand,
    required String carModel,
    required String carYear,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);


    try {
      final cloudinary = CloudinaryPublic('denfgaxvg', 'uszbstnu');
      List<String> imageUrls = [];


      for (int i = 0; i < images.length; i++) {
        CloudinaryResponse res = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(images[i].path, folder: name),
        );
        imageUrls.add(res.secureUrl);
      }


      final Map<String, dynamic> productData = {
        'name': name,
        'description': description,
        'price': price,
        'quantity': quantity,
        'category': categoryId, // ✅ backend uses 'category' for ID
        'categoryName': categoryName, // ✅ extra name passed
        'images': imageUrls,
        'carBrand': carBrand,
        'carModel': carModel,
        'carYear': carYear,
      };


      http.Response res = await http.post(
        Uri.parse('$uri/admin/add-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode(productData),
      );


      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Product Added Successfully!');
          Navigator.pop(context);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }


  Future<List<Product>> fetchAllProducts(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/admin/get-products'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );


      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            productList.add(
              Product.fromJson(jsonEncode(jsonDecode(res.body)[i])),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return productList;
  }


  void deleteProduct({
    required BuildContext context,
    required Product product,
    required VoidCallback onSuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);


    try {
      http.Response res = await http.post(
        Uri.parse('$uri/admin/delete-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({'id': product.id}),
      );


      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          onSuccess();
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }


  Future<List<Order>> fetchAllOrders(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Order> orderList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/admin/get-orders'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );


      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            orderList.add(Order.fromJson(jsonEncode(jsonDecode(res.body)[i])));
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return orderList;
  }


  void changeOrderStatus({
    required BuildContext context,
    required int status,
    required Order order,
    required VoidCallback onSuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);


    try {
      http.Response res = await http.post(
        Uri.parse('$uri/admin/change-order-status'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({'id': order.id, 'status': status}),
      );


      httpErrorHandle(response: res, context: context, onSuccess: onSuccess);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }


  Future<Map<String, dynamic>> getEarnings(BuildContext context) async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  List<Sales> sales = [];
  int totalEarning = 0;


  try {
    http.Response res = await http.get(
      Uri.parse('$uri/admin/analytics'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      },
    );


    httpErrorHandle(
      response: res,
      context: context,
      onSuccess: () {
        var response = jsonDecode(res.body);
        totalEarning = response['totalEarnings'];
        sales = (response['sales'] as List)
            .map((e) => Sales(e['label'], e['earning'] ?? 0))
            .toList();
      },
    );
  } catch (e) {
    showSnackBar(context, e.toString());
  }


  return {'sales': sales, 'totalEarnings': totalEarning};
}


}
