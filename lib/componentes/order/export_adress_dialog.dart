import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:projeto_budega/models/address.dart';
import 'package:projeto_budega/models/order.dart';
import 'package:screenshot/screenshot.dart';

class ExportAddressDialog extends StatefulWidget {
  ExportAddressDialog(this.order);

  final Order order;

  @override
  _ExportAddressDialogState createState() => _ExportAddressDialogState();
}

class _ExportAddressDialogState extends State<ExportAddressDialog> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final ScreenshotController screenshotController = ScreenshotController();

  String nome;

  Future<void> getName() async {
    final ref = firestore.doc('users/${widget.order.userId}');

    try {
      await firestore.runTransaction((tx) async {
        final doc = await tx.get(ref);
        final name = doc.data()['name'] as String;
        //await tx.update(ref, {'stock': stock + item.quantity});
        setState(() {
          nome = name;
        });
      });
    } catch (e) {
      debugPrint(e.toString());
      return Future.error('Falha ao obter nome');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getName();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Endereço de Entrega'),
      content: Screenshot(
        controller: screenshotController,
        child: Container(
          padding: const EdgeInsets.all(8),
          color: Colors.white,
          child: Text(
            '${widget.order.address.street}, ${widget.order.address.number} ${widget.order.address.complement}\n'
            '${widget.order.address.district}\n'
            '${widget.order.address.city}/${widget.order.address.state}\n'
            '${widget.order.address.zipCode}\n'
            '${nome ?? ''}\n'
            '${widget.order.address.telefone}',
          ),
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      actions: <Widget>[
        FlatButton(
          onPressed: () async {
            Navigator.of(context).pop();
            await screenshotController
                .capture(delay: const Duration(milliseconds: 10))
                .then((Uint8List image) async {
              if (image != null) {
                final directory = await getApplicationDocumentsDirectory();
                String fileName =
                    DateTime.now().microsecondsSinceEpoch.toString();
                final imagePath =
                    await File('${directory.path}/$fileName.png').create();
                await imagePath.writeAsBytes(image);

                /// Share Plugin
                //await Share.shareFiles([imagePath.path]);
                await GallerySaver.saveImage(imagePath.path);
              }
            });
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Exportar'),
        )
      ],
    );
  }
}
