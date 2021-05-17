import 'package:flutter/material.dart';
import 'package:projeto_budega/componentes/price_card.dart';
import 'package:projeto_budega/models/cart_manager.dart';
import 'package:projeto_budega/models/checkout_manager.dart';
import 'package:provider/provider.dart';

class TelaCheckout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<CartManager, CheckoutManager>(
      create: (_) => CheckoutManager(),
      update: (_, cartManager, checkoutManager) =>
          checkoutManager..updateCart(cartManager),
      lazy: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pagamento'),
          centerTitle: true,
        ),
        body: Consumer<CheckoutManager>(
          builder: (_, checkoutManager, __) {
            return ListView(
              children: <Widget>[
                PriceCard(
                  buttonText: 'Finalizar Pedido',
                  onPressed: () {
                    checkoutManager.checkout();
                  },
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
