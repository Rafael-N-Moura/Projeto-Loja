import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:projeto_budega/models/appuser.dart';
import 'package:projeto_budega/models/order.dart';

class OrdersManager extends ChangeNotifier {
  AppUser user;

  List<Order> orders = [];

  StreamSubscription _subscription;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void updateUser(AppUser user) {
    this.user = user;
    orders.clear();

    _subscription?.cancel();

    if (user != null) {
      _listenToOrders();
    }
  }

  void _listenToOrders() {
    _subscription = firestore
        .collection('orders')
        .where('user', isEqualTo: user.id)
        .snapshots()
        .listen((event) {
      orders.clear();
      for (final doc in event.docs) {
        orders.add(Order.fromDocument(doc));
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }
}
