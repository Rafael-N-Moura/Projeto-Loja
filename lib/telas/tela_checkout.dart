import 'package:flutter/material.dart';
import 'package:projeto_budega/componentes/checkout/credit_card_widget.dart';
import 'package:projeto_budega/componentes/price_card.dart';
import 'package:projeto_budega/models/cart_manager.dart';
import 'package:projeto_budega/models/checkout_manager.dart';
import 'package:provider/provider.dart';

class TelaCheckout extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<CartManager, CheckoutManager>(
      create: (_) => CheckoutManager(),
      update: (_, cartManager, checkoutManager) =>
          checkoutManager..updateCart(cartManager),
      lazy: false,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text('Pagamento'),
          centerTitle: true,
        ),
        body: Consumer<CheckoutManager>(
          builder: (_, checkoutManager, __) {
            if (checkoutManager.loading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Processando seu pagamento...',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 16),
                    )
                  ],
                ),
              );
            }

            return Form(
              key: formKey,
              child: ListView(
                children: <Widget>[
                  CreditCardWidget(),
                  PriceCard(
                    buttonText: 'Finalizar Pedido',
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                        checkoutManager.checkout(onStockFail: (e) {
                          Navigator.of(context).popUntil(
                              (route) => route.settings.name == '/cart');
                        }, onSuccess: (order) {
                          Navigator.of(context)
                              .popUntil((route) => route.settings.name == '/');
                          Navigator.of(context)
                              .pushNamed('/confirmation', arguments: order);
                        });
                      }
                    },
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
