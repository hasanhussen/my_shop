import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  bool isLoading = false;

  final formkey = GlobalKey<FormState>();
  bool isLogin = true;
  String email = '';
  String password = '';
  TextEditingController controller = TextEditingController();

  bool get isAuth {
    // tryAutoLogin();
    return _token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token!;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:${urlSegment}?key=[API_KEY]';
    try {
      final res = await http.post(Uri.parse(url),
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      //final res = await http.get(Uri.parse(url));
      print(res.body);
      final responseData = json.decode(res.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      autologout();
      notifyListeners();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String(),
      });
      prefs.setString('userData', userData);
    } catch (e) {
      throw e;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) return false;
    final Map<String, dynamic> extractData = json
        .decode(prefs.getString('userData') as String) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractData['expiryDate'].toString());
    if (expiryDate.isBefore(DateTime.now())) return false;

    _token = extractData['token'].toString();
    _userId = extractData['userId'].toString();
    _expiryDate = expiryDate;
    autologout();
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<void> autologout() async {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  void showErrorDialog(String erorr, BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('An Error Occurred!'),
              content: Text(erorr),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text('Okay'))
              ],
            ));
  }

  submitAuthForm(
      bool isLogin, String email, String password, BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {
      if (isLogin) {
        await login(email, password);
      } else {
        await signUp(email, password);
      }
    } on HttpException catch (error) {
      var erorrMssage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        erorrMssage = 'This email is already used';
      }
      if (error.toString().contains('INVALID_EMAIL')) {
        erorrMssage = 'This is invalid email';
      }
      if (error.toString().contains('WEAK_PASSWORD')) {
        erorrMssage = 'This password is too weak';
      }
      if (error.toString().contains('EMAIL_NOT_FOUND')) {
        erorrMssage = 'could not found a user with this email';
      }
      if (error.toString().contains('INVALID_PASSWORD')) {
        erorrMssage = 'Invalid password';
      }
      // ignore: use_build_context_synchronously
      showErrorDialog(erorrMssage, context);
    } catch (e) {
      const error = 'could not authenticate you , Pleas try again later';
      // ignore: use_build_context_synchronously
      showErrorDialog(error, context);
      print(e);
    }
  }

  void submit(BuildContext context) {
    final isvalid = formkey.currentState?.validate();
    FocusScope.of(context).unfocus();
    notifyListeners();

    if (isvalid!) {
      formkey.currentState?.save();
      submitAuthForm(isLogin, email, password, context);
    }
  }

  onTextButton() {
    isLogin = !isLogin;
    notifyListeners();
  }
}
