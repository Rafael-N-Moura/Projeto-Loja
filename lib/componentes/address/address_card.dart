import 'package:flutter/material.dart';
import 'package:projeto_budega/componentes/address/address_input_field.dart';
import 'package:projeto_budega/componentes/address/cep_input_field.dart';
import 'package:projeto_budega/models/address.dart';
import 'package:projeto_budega/models/cart_manager.dart';
import 'package:provider/provider.dart';

class AddressCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartManager>(
      builder: (_, cartManager, __) {
        final address = cartManager.address ?? Address();

        return Form(
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Endereço de Entrega',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  CepInputField(address),
                  AddressInputField(address),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
