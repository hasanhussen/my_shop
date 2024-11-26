import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop/provider/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> orders = [];
  late String authToken;
  late String userId;
  bool isLoading = false;

  getData(String authTok, String uid) {
    authToken = authTok;
    userId = uid;
    notifyListeners();
    init();
  }

  void init() async {
    isLoading = true;
    notifyListeners();
    await fetchAndSetOrders();
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'Your RealTime database url/orders/$userId.json?auth=$authToken';
    try {
      final res = await http.get(Uri.parse(url));
      final extractData = json.decode(res.body) as Map<String, dynamic>?;
      if (extractData == null) {
        return;
      }
      final List<OrderItem> loadedOrders = [];
      extractData.forEach((orderId, orderData) {
        loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  quantity: item['quantity'],
                  price: item['price']))
              .toList(),
        ));
      });
      orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addOrder(List<CartItem> cartProduct, double total) async {
    final url =
        'Your RealTime database url/orders/$userId.json?auth=$authToken';
    try {
      final timestamp = DateTime.now();
      final res = await http.post(Uri.parse(url),
          body: json.encode({
            'amount': total,
            'dateTime': timestamp.toIso8601String(),
            'products': cartProduct
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'quantity': cp.quantity,
                      'price': cp.price,
                    })
                .toList(),
          }));
      orders.insert(
        0,
        OrderItem(
            id: json.decode(res.body)['name'],
            amount: total,
            dateTime: timestamp,
            products: cartProduct),
      );
      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }
}
