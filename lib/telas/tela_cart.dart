import 'package:flutter/material.dart';
import 'package:projeto_budega/componentes/cart/cart_tile.dart';
import 'package:projeto_budega/componentes/empty_card.dart';
import 'package:projeto_budega/componentes/login_card.dart';
import 'package:projeto_budega/componentes/price_card.dart';
import 'package:projeto_budega/models/cart_manager.dart';
import 'package:provider/provider.dart';

class TelaCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
        centerTitle: true,
      ),
      body: Consumer<CartManager>(
        builder: (_, cartManager, __) {
          if (cartManager.user == null) {
            return LoginCard();
          }

          if (cartManager.items.isEmpty) {
            return EmptyCard(
              iconData: Icons.remove_shopping_cart,
              title: 'Nenhum produto no carrinho!',
            );
          }

          return ListView(
            children: <Widget>[
              Column(
                children: cartManager.items
                    .map((cartProduct) => CartTile(cartProduct))
                    .toList(),
              ),
              PriceCard(
                buttonText: 'Continuar para Entrega',
                onPressed: cartManager.isCartValid
                    ? () {
                        Navigator.of(context).pushNamed('/address');
                      }
                    : null,
              ),
            ],
          );
        },
      ),
    );
  }
}
