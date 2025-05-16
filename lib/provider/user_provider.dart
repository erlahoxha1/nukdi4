import 'package:flutter/material.dart';
import 'package:nukdi2/models/user.dart';
import 'dart:convert'; // ✅ Add this at the top


class UserProvider extends ChangeNotifier {
  User _user = User(
  id: '',
  name: '',
  email: '', // ✅ Add this line
  password: '',
  address: '',
  type: '',
  token: '',
);


    User get user => _user;
    void setUser(String user) {
      _user = User.fromJson(user);
      notifyListeners();
    }
}
