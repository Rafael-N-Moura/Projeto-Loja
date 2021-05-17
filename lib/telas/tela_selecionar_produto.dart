import 'package:flutter/material.dart';
import 'package:projeto_budega/models/product_manager.dart';
import 'package:provider/provider.dart';

class TelaSelecionarProduto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vincular Produto'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Consumer<ProductManager>(
        builder: (_, productManager, __) {
          return ListView.builder(
            itemCount: productManager.allProducts.length,
            itemBuilder: (_, index) {
              final product = productManager.allProducts[index];
              return ListTile(
                leading: Image.network(product.images.first),
                title: Text(product.name),
                subtitle: Text('R\$ ${product.price.toStringAsFixed(2)}'),
                onTap: () {
                  Navigator.of(context).pop(product);
                },
              );
            },
          );
        },
      ),
    );
  }
}
