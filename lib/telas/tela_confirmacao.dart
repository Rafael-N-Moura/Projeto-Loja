import 'package:flutter/material.dart';
import 'package:projeto_budega/componentes/drawer/custom_drawer.dart';
import 'package:projeto_budega/componentes/order/order_product_tile.dart';
import 'package:projeto_budega/models/order.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen(this.order);

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, "/base");
          },
          child: Icon(Icons.arrow_back),
        ),
        title: const Text('Pedido Confirmado'),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      order.formattedId,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Text(
                      'R\$ ${order.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: order.items.map((e) {
                  return OrderProductTile(e);
                }).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
