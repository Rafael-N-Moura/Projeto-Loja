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
