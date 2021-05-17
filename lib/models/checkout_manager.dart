import 'package:flutter/cupertino.dart';
import 'package:projeto_budega/models/cart_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CheckoutManager extends ChangeNotifier {
  CartManager cartManager;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  // ignore: use_setters_to_change_properties
  void updateCart(CartManager cartManager) {
    this.cartManager = cartManager;
  }

  void checkout() {
    _decrementStock();
    _getOrderId().then((value) => print(value));
  }

  Future<int> _getOrderId() async {
    final ref = firestore.doc('aux/ordercounter');

    try {
      final result = await firestore.runTransaction((tx) async {
        final doc = await tx.get(ref);
        final orderId = doc.data()['current'] as int;
        tx.update(ref, {'current': orderId + 1});
        return {'orderId': orderId};
      });
      return result['orderId'];
    } catch (e) {
      debugPrint(e.toString());
      return Future.error('Falha ao gerar número do pedido');
    }
  }

  void _decrementStock() {
    // 1. Ler todos os estoques 3xM
    // 2. Decremento localmente os estoques 2xM
    // 3. Salvar os estoques no firebase 2xM
  }
}
