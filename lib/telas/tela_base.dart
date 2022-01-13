import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projeto_budega/componentes/drawer/custom_drawer.dart';
import 'package:projeto_budega/models/page_manager.dart';
import 'package:projeto_budega/models/user_manager.dart';
import 'package:projeto_budega/telas/tela_admin_users.dart';
import 'package:projeto_budega/telas/tela_cadastro.dart';
import 'package:projeto_budega/telas/tela_home.dart';
import 'package:projeto_budega/telas/tela_login.dart';
import 'package:projeto_budega/telas/tela_lojas.dart';
import 'package:projeto_budega/telas/tela_pedidos.dart';
import 'package:projeto_budega/telas/tela_pedidos_admin.dart';
import 'package:projeto_budega/telas/tela_produtos.dart';
import 'package:provider/provider.dart';

class TelaBase extends StatefulWidget {
  @override
  _TelaBaseState createState() => _TelaBaseState();
}

class _TelaBaseState extends State<TelaBase> {
  @override
  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    configFCM();
  }
void configFCM(){
    final fcm = FirebaseMessaging();

    if(Platform.isIOS){
      fcm.requestNotificationPermissions(
        const IosNotificationSettings(provisional: true)
      );
    }

    fcm.configure(
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume $message');
      },
      onMessage: (Map<String, dynamic> message) async {
        showNotification(
          message['notification']['title'] as String,
          message['notification']['body'] as String,
        );
      }
    );
  }

  void showNotification(String title, String message){
    Flushbar(
      title: title,
      message: message,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.GROUNDED,
      isDismissible: true,
      backgroundColor: Theme.of(context).primaryColor,
      duration: const Duration(seconds: 5),
      icon: Icon(Icons.shopping_cart, color: Colors.white,),
    ).show(context);
  }


  Widget build(BuildContext context) {
    return Provider<PageManager>(
      create: (_) => PageManager(pageController),
      builder: (_, pageManager) {
        return Consumer<UserManager>(
          builder: (_, userManager, __) {
            return PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                TelaHome(),
                TelaProdutos(),
                TelaPedidos(),
                TelaLojas(),
                if (userManager.adminEnabled) ...[
                  TelaAdminUsers(),
                  TelaPedidosAdmin(),
                ]
              ],
            );
          },
        );
      },
    );
  }
}
