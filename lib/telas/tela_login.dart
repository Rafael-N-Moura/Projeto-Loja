import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projeto_budega/helpers/firebase_erros.dart';
import 'package:projeto_budega/helpers/validators.dart';
import 'package:projeto_budega/models/appuser.dart';
import 'package:projeto_budega/models/user_manager.dart';
import 'package:provider/provider.dart';

class TelaLogin extends StatelessWidget {
  @override
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Entrar"),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/signup');
            },
            textColor: Colors.white,
            child: Text(
              "Criar conta",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
      body: Center(
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            child: Consumer<UserManager>(
              builder: (_, userManager, __) {
                return ListView(
                  padding: EdgeInsets.all(16),
                  shrinkWrap: true,
                  children: <Widget>[
                    TextFormField(
                      controller: emailController,
                      enabled: !userManager.loading,
                      decoration: InputDecoration(hintText: 'E-mail'),
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      validator: (email) {
                        if (!emailValid(email)) {
                          return 'E-mail inválido';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: passController,
                      enabled: !userManager.loading,
                      decoration: InputDecoration(hintText: 'Senha'),
                      autocorrect: false,
                      obscureText: true,
                      validator: (senha) {
                        if (senha.isEmpty || senha.length < 6)
                          return 'Senha inválida';
                        return null;
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {},
                        child: Text("Esqueci minha senha"),
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      height: 44,
                      child: RaisedButton(
                        onPressed: userManager.loading
                            ? null
                            : () {
                                if (formKey.currentState.validate()) {
                                  userManager.signIn(
                                      user: AppUser(
                                        email: emailController.text,
                                        password: passController.text,
                                      ),
                                      onSucess: () {
                                        Navigator.of(context).pop();
                                      },
                                      onFail: (e) {
                                        scaffoldKey.currentState
                                            .showSnackBar(SnackBar(
                                          content: Text('Falha ao entrar: $e'),
                                          backgroundColor: Colors.red,
                                        ));
                                      });
                                }
                              },
                        child: userManager.loading
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              )
                            : Text(
                                'Entrar',
                                style: TextStyle(fontSize: 16),
                              ),
                        color: Theme.of(context).primaryColor,
                        disabledColor:
                            Theme.of(context).primaryColor.withAlpha(100),
                        textColor: Colors.white,
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
