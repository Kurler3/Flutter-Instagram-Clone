import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/user.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';

class UserProvider extends ChangeNotifier {
  User? _user;

  User? get getUser => _user;

  // Calling this function will update the user value on this provider
  Future<void> refreshUser() async {
    _user = await AuthMethods().getUserDetails();

    // Makes every single widget that is listening to this value re-render.
    notifyListeners();
  }
}
