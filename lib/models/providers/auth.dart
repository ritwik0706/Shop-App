import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    if (token != null) {
      return true;
    }
    return false;
  }

  String get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCTfBMiR55JkY7kdGbuyv0dkm3tc4jiMbk';
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));

      final extractedResponse = json.decode(response.body);
      if (extractedResponse['error'] != null) {
        throw HttpException(extractedResponse['error']['message']);
      }

      _token = extractedResponse['idToken'];
      _userId = extractedResponse['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(extractedResponse['expiresIn'])));
      notifyListeners();
      _autoLogout();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'userId': _userId,
        'token': _token,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutologin() async {
    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData')) {
      return false;
    }

    final extractedUserData = json.decode(prefs.getString('userData'));
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if(expiryDate.isBefore(DateTime.now())){ 
      return false;
    }

    _userId = extractedUserData['userId'];
    _token = extractedUserData['token'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logOut() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if(_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();
  }

  void _autoLogout() {
    if(_authTimer != null) {
      _authTimer.cancel();
    }
    final expiryTime = _expiryDate.difference(DateTime.now()).inSeconds;
    Timer(Duration(seconds: expiryTime), logOut);
  }
}
