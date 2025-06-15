// models/user_model.dart
import 'package:flutter/foundation.dart';

class UserModel with ChangeNotifier {
  String _name = '';
  String _email = '';
  String _phone = '';
  String _address = '';

  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  String get address => _address;

  void updateUser({
    required String name,
    required String email,
    required String phone,
    required String address,
  }) {
    _name = name;
    _email = email;
    _phone = phone;
    _address = address;
    notifyListeners();
  }
}
