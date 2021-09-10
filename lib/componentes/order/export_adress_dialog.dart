import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:projeto_budega/models/address.dart';
import 'package:screenshot/screenshot.dart';

class ExportAddressDialog extends StatelessWidget {
  ExportAddressDialog(this.address);

  final Address address;

  final ScreenshotController screenshotController = ScreenshotController();

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
            '${address.street}, ${address.number} ${address.complement}\n'
            '${address.district}\n'
            '${address.city}/${address.state}\n'
            '${address.zipCode}',
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
