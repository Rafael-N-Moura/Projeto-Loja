import 'package:flutter/material.dart';
import 'package:projeto_budega/componentes/images_form.dart';
import 'package:projeto_budega/models/product.dart';
import 'package:projeto_budega/models/product_manager.dart';
import 'package:provider/provider.dart';

class TelaEditarProduto extends StatelessWidget {
  TelaEditarProduto(Product p)
      : editing = p != null,
        product = p != null ? p.clone() : Product();

  final Product product;
  final bool editing;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        appBar: AppBar(
          title: Text(editing ? 'Editar Produto' : 'Criar Produto'),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              ImagesForm(product),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                        initialValue: product.name,
                        decoration: const InputDecoration(
                          hintText: 'Título',
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                        validator: (name) {
                          if (name.length < 3) return 'Título muito curto';
                          return null;
                        },
                        onSaved: (name) => product.name = name),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'A partir de',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ),
                    TextFormField(
                      initialValue: "${product.price.toStringAsFixed(2)}",
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                      decoration: const InputDecoration(
                          prefixText: 'R\$',
                          hintText: 'Preço',
                          border: InputBorder.none),
                      validator: (price) {
                        if (num.tryParse(price) == null) return 'Inválido';
                        return null;
                      },
                      onSaved: (price) => product.price = num.tryParse(price),
                    ),
                    // Text(
                    //   'R\$ ${product.price}',
                    //   style: TextStyle(
                    //     fontSize: 22,
                    //     fontWeight: FontWeight.bold,
                    //     color: primaryColor,
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        'Descrição',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    TextFormField(
                      initialValue: product.description,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                          hintText: 'Descrição', border: InputBorder.none),
                      maxLines: null,
                      validator: (desc) {
                        if (desc.length < 5) return 'Descrição muito curta';
                        return null;
                      },
                      onSaved: (desc) => product.description = desc,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        'Estoque',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    TextFormField(
                      initialValue: product.stock.toString(),
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                          hintText: 'Estoque', border: InputBorder.none),
                      maxLines: null,
                      validator: (stock) {
                        if (int.tryParse(stock) == null) return 'Inválido';
                        return null;
                      },
                      onSaved: (stock) => product.stock = int.tryParse(stock),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Consumer<Product>(
                      builder: (_, product, __) {
                        return SizedBox(
                          height: 44,
                          child: RaisedButton(
                            onPressed: !product.loading
                                ? () async {
                                    if (formKey.currentState.validate()) {
                                      formKey.currentState.save();
                                      await product.save();
                                      context
                                          .read<ProductManager>()
                                          .update(product);

                                      Navigator.of(context).pop();
                                    }
                                  }
                                : null,
                            textColor: Colors.white,
                            color: primaryColor,
                            disabledColor: primaryColor.withAlpha(100),
                            child: product.loading
                                ? CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.white),
                                  )
                                : const Text(
                                    'Salvar',
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
