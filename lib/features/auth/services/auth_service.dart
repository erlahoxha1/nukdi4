import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:nukdi4/models/user.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:nukdi4/constants/error_handling.dart';
import 'package:nukdi4/constants/global_variables.dart';
import 'package:nukdi4/constants/utils.dart';
import 'package:nukdi4/provider/user_provider.dart';

import 'package:nukdi4/features/auth/screens/auth_screen.dart';
import 'package:nukdi4/features/admin/screens/admin_screen.dart';
import 'package:nukdi4/common/widgets/bottom_bar.dart';

class AuthService {
  // Sign Up
  void signUpUser({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      User user = User(
        id: '',
        name: name,
        email: email,
        password: password,
        address: '',
        type: 'user',
        token: '',
        cart: [], // ✅ This line fixes the problem
      );

      http.Response res = await http.post(
        Uri.parse('$uri/api/signup'),
        body: user.toJson(),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(
            context,
            'Account created! Login with the same credentials',
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // Sign In
  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/signin'),
        body: jsonEncode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          final decodedUser = jsonDecode(res.body);

          // Save user in provider
          Provider.of<UserProvider>(context, listen: false).setUser(res.body);

          // Save token
          await prefs.setString('x-auth-token', decodedUser['token']);

          // Navigate based on user type
          if (decodedUser['type'] == 'admin') {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AdminScreen.routeName,
              (route) => false,
            );
          } else {
            Navigator.pushNamedAndRemoveUntil(
              context,
              BottomBar.routeName,
              (route) => false,
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // Get user data on app start
  void getUserData(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
        return;
      }

      // Check if token is valid
      http.Response tokenRes = await http.post(
        Uri.parse('$uri/tokenIsValid'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );

      var isValid = jsonDecode(tokenRes.body);

      if (isValid == true) {
        // Get user data
        http.Response userRes = await http.get(
          Uri.parse('$uri/'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
        );

        // Set user in provider
        Provider.of<UserProvider>(context, listen: false).setUser(userRes.body);
      }
    } catch (e) {
      showSnackBar(context, 'Something went wrong: ${e.toString()}');
    }
  }
}
