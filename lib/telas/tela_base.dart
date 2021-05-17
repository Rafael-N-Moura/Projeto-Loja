import 'package:flutter/material.dart';
import 'package:projeto_budega/componentes/drawer/custom_drawer.dart';
import 'package:projeto_budega/models/page_manager.dart';
import 'package:projeto_budega/models/user_manager.dart';
import 'package:projeto_budega/telas/tela_admin_users.dart';
import 'package:projeto_budega/telas/tela_cadastro.dart';
import 'package:projeto_budega/telas/tela_home.dart';
import 'package:projeto_budega/telas/tela_login.dart';
import 'package:projeto_budega/telas/tela_produtos.dart';
import 'package:provider/provider.dart';

class TelaBase extends StatelessWidget {
  @override
  final PageController pageController = PageController();

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
                Scaffold(
                  drawer: CustomDrawer(),
                  appBar: AppBar(
                    title: const Text('Home3'),
                  ),
                ),
                Scaffold(
                  drawer: CustomDrawer(),
                  appBar: AppBar(
                    title: const Text('Home4'),
                  ),
                ),
                if (userManager.adminEnabled) ...[
                  TelaAdminUsers(),
                  Scaffold(
                    drawer: CustomDrawer(),
                    appBar: AppBar(
                      title: const Text('Pedidos'),
                    ),
                  ),
                ]
              ],
            );
          },
        );
      },
    );
  }
}
