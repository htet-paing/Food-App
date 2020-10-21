import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  User _user;
  User get user => _user;
  
  void setUser(User user) {
    _user = user;
    notifyListeners();
  }
}