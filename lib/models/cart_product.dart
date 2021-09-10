import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:projeto_budega/models/product.dart';

class CartProduct extends ChangeNotifier {
  CartProduct.fromProduct(this._product) {
    productId = product.id;
    quantity = 1;
    price = product.price;
  }

  CartProduct.fromDocument(DocumentSnapshot document) {
    id = document.id;
    productId = document.data()['pid'] as String;
    quantity = document.data()['quantity'] as int;
    price = document.data()['price'] as num;

    firestore.doc('products/$productId').get().then(
      (doc) {
        product = Product.fromDocument(doc);
        //notifyListeners();
      },
    );
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String productId;
  num price;
  int quantity;
  String id;
  num fixedPrice;

  Product _product;
  Product get product => _product;
  set product(Product value) {
    _product = value;
    notifyListeners();
  }

  CartProduct.fromMap(Map<String, dynamic> map) {
    productId = map['pid'] as String;
    quantity = map['quantity'] as int;
    fixedPrice = map['fixedPrice'] as num;

    firestore.doc('products/$productId').get().then((doc) {
      product = Product.fromDocument(doc);
    });
  }

  Map<String, dynamic> toCartItemMap() {
    return {
      'pid': productId,
      'quantity': quantity,
      'price': price,
    };
  }

  Map<String, dynamic> toOrderItemMap() {
    return {
      'pid': productId,
      'quantity': quantity,
      'fixedPrice': fixedPrice ?? price,
    };
  }

  bool stackable(Product product) {
    return product.id == productId;
  }

  void increment() {
    quantity++;
    notifyListeners();
  }

  void decrement() {
    quantity--;
    notifyListeners();
  }

  num get totalPrice => price * quantity;

  bool get hasStock {
    if (product == null && product.deleted) return false;
    return product.stock >= quantity;
  }
}
