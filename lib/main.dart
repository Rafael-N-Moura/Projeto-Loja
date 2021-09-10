import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_budega/models/admin_orders_manager.dart';
import 'package:projeto_budega/models/admin_users_manager.dart';
import 'package:projeto_budega/models/cart_manager.dart';
import 'package:projeto_budega/models/home_manager.dart';
import 'package:projeto_budega/models/order.dart';
import 'package:projeto_budega/models/orders_manager.dart';
import 'package:projeto_budega/models/page_manager.dart';
import 'package:projeto_budega/models/product.dart';
import 'package:projeto_budega/models/product_manager.dart';
import 'package:projeto_budega/models/user_manager.dart';
import 'package:projeto_budega/services/cepaberto_service.dart';
import 'package:projeto_budega/telas/tela_base.dart';
import 'package:projeto_budega/telas/tela_cadastro.dart';
import 'package:projeto_budega/telas/tela_cart.dart';
import 'package:projeto_budega/telas/tela_checkout.dart';
import 'package:projeto_budega/telas/tela_confirmacao.dart';
import 'package:projeto_budega/telas/tela_editar_produto.dart';
import 'package:projeto_budega/telas/tela_endereco.dart';
import 'package:projeto_budega/telas/tela_login.dart';
import 'package:projeto_budega/telas/tela_produto.dart';
import 'package:projeto_budega/telas/tela_selecionar_produto.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  Provider.debugCheckInvalidValueType = null;

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool _initialized = false;
  bool _error = false;

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
    CepAbertoService()
        .getAddressFromCep('65.609-240')
        .then((address) => print(address));
    ;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => ProductManager(),
          lazy: false,
        ),
        Provider(
          create: (_) => CartManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => HomeManager(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<UserManager, CartManager>(
          create: (_) => CartManager(),
          lazy: false,
          update: (_, userManager, cartManager) =>
              cartManager..updateUser(userManager),
        ),
        ChangeNotifierProxyProvider<UserManager, OrdersManager>(
          create: (_) => OrdersManager(),
          lazy: false,
          update: (_, userManager, ordersManager) =>
              ordersManager..updateUser(userManager.user),
        ),
        ChangeNotifierProxyProvider<UserManager, AdminUsersManager>(
          create: (_) => AdminUsersManager(),
          lazy: false,
          update: (_, userManager, adminUsersManager) =>
              adminUsersManager..updateUser(userManager),
        ),
        ChangeNotifierProxyProvider<UserManager, AdminOrdersManager>(
          create: (_) => AdminOrdersManager(),
          lazy: false,
          update: (_, userManager, adminOrdersManager) => adminOrdersManager
            ..updateAdmin(adminEnabled: userManager.adminEnabled),
        )
      ],
      child: MaterialApp(
        //aqui inves de ter um metodo proprio vc coloca um widget acima
        title: 'Budega',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(
                builder: (_) => TelaBase(),
              );
            case '/signup':
              return MaterialPageRoute(
                builder: (_) => TelaCadastro(),
              );
            case '/cart':
              return MaterialPageRoute(
                  builder: (_) => TelaCart(), settings: settings);
            case '/checkout':
              return MaterialPageRoute(builder: (_) => TelaCheckout());
            case '/login':
              return MaterialPageRoute(
                builder: (_) => TelaLogin(),
              );
            case '/confirmation':
              return MaterialPageRoute(
                  builder: (_) =>
                      ConfirmationScreen(settings.arguments as Order));
            case '/edit_product':
              return MaterialPageRoute(
                builder: (_) =>
                    TelaEditarProduto(settings.arguments as Product),
              );
            case '/select_product':
              return MaterialPageRoute(
                builder: (_) => TelaSelecionarProduto(),
              );
            case '/address':
              return MaterialPageRoute(builder: (_) => TelaEndereco());
            case '/product':
              return MaterialPageRoute(
                  builder: (_) => ProductScreen(settings.arguments as Product));
            default:
              return MaterialPageRoute(
                  builder: (_) => TelaBase(), settings: settings);
          }
        },
        theme: ThemeData(
          primaryColor: Color.fromARGB(255, 4, 125, 141),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: Color.fromARGB(255, 4, 125, 141),
          appBarTheme: AppBarTheme(
            elevation: 0,
          ),
        ),
      ),
    );
  }
}

class MyAwesomeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: TelaBase());
  }
}

//ADICIONAR NO BANCO DE DADOS
class AddUser extends StatelessWidget {
  final String fullName;
  final String company;
  final int age;

  AddUser(this.fullName, this.company, this.age);

  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called users that references the firestore collection
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    Future<void> addUser() {
      // Call the user's CollectionReference to add a new user
      return users
          .add({
            'full_name': fullName, // John Doe
            'company': company, // Stokes and Sons
            'age': age // 42
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    return FlatButton(
      onPressed: addUser,
      child: Text(
        "Add User",
      ),
    );
  }
}
