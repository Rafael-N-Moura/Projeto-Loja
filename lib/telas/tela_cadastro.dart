import 'package:flutter/material.dart';
import 'package:projeto_budega/helpers/validators.dart';
import 'package:projeto_budega/models/appuser.dart';
import 'package:projeto_budega/models/user_manager.dart';
import 'package:provider/provider.dart';

class TelaCadastro extends StatelessWidget {
  @override
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  AppUser user = AppUser();
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Criar conta"),
        centerTitle: true,
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
                      decoration: InputDecoration(hintText: 'Nome completo'),
                      enabled: !userManager.loading,
                      validator: (name) {
                        if (name.isEmpty)
                          return 'Campo obrigatório';
                        else if (name.trim().split(' ').length <= 1)
                          return 'Preencha seu Nome completo';
                        return null;
                      },
                      onSaved: (name) => user.name = name,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'E-mail'),
                      enabled: !userManager.loading,
                      keyboardType: TextInputType.emailAddress,
                      validator: (email) {
                        if (email.isEmpty)
                          return "Campo obrigatório";
                        else if (!emailValid(email)) return "E-mail inválido";

                        return null;
                      },
                      onSaved: (email) => user.email = email,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Senha'),
                      enabled: !userManager.loading,
                      obscureText: true,
                      validator: (pass) {
                        if (pass.isEmpty)
                          return 'Campo obrigatório';
                        else if (pass.length < 6) return 'Senha muito curta';
                        return null;
                      },
                      onSaved: (pass) => user.password = pass,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Repetir senha'),
                      enabled: !userManager.loading,
                      obscureText: true,
                      validator: (pass) {
                        if (pass.isEmpty)
                          return 'Campo obrigatório';
                        else if (pass.length < 6) return 'Senha muito curta';
                        return null;
                      },
                      onSaved: (pass) => user.confirmedPass = pass,
                    ),
                    SizedBox(height: 16),
                    RaisedButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onPressed: userManager.loading
                          ? null
                          : () {
                              if (formKey.currentState.validate()) {
                                formKey.currentState.save();
                                if (user.password != user.confirmedPass) {
                                  scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      'As senhas não são igauis',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    backgroundColor: Colors.red,
                                  ));
                                }
                                print(user.name);
                                userManager.signUp(
                                  user: user,
                                  onSucess: () {
                                    Navigator.of(context).pop();
                                  },
                                  onFail: (e) {
                                    scaffoldKey.currentState
                                        .showSnackBar(SnackBar(
                                      content: Text('Falha ao cadastrar: $e'),
                                      backgroundColor: Colors.red,
                                    ));
                                  },
                                );
                              }
                            },
                      color: Theme.of(context).primaryColor,
                      disabledColor:
                          Theme.of(context).primaryColor.withAlpha(100),
                      textColor: Colors.white,
                      child: userManager.loading
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            )
                          : Text(
                              'Criar conta',
                              style: TextStyle(fontSize: 15),
                            ),
                    ),
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
