import 'package:flutter/material.dart';
import 'package:flutter_danthocode_instagram_clone/models/user_model.dart';
import 'package:flutter_danthocode_instagram_clone/resources/auth_method.dart';

class UserModelProvider with ChangeNotifier {
  UserModel? _userModel;
  final AuthMethod _authMethod = AuthMethod();

  UserModel get getUser => _userModel!;

  Future<void> refreshUser() async {
    UserModel user = await _authMethod.getUserDetails();
    _userModel = user;
    notifyListeners();
  }
}
