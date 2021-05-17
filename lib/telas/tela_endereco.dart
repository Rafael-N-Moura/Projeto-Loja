import 'package:flutter/material.dart';
import 'package:projeto_budega/componentes/address/address_card.dart';
import 'package:projeto_budega/componentes/price_card.dart';
import 'package:projeto_budega/models/cart_manager.dart';
import 'package:provider/provider.dart';

class TelaEndereco extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrega'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          AddressCard(),
          Consumer<CartManager>(
            builder: (_, cartManager, __) {
              return PriceCard(
                buttonText: 'Continuar para o Pagamento',
                onPressed: cartManager.isAddressValid
                    ? () {
                        Navigator.of(context).pushNamed('/checkout');
                      }
                    : null,
              );
            },
          ),
        ],
      ),
    );
  }
}
