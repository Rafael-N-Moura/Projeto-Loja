import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:projeto_budega/helpers/firebase_erros.dart';
import 'package:projeto_budega/models/appuser.dart';

class UserManager extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  AppUser user;
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool loading = false;

  //construtor
  UserManager() {
    _loadCurrentUser();
  }

  //MÉTODOS PRINCIPAIS
  //logar
  Future<void> signIn(
      {AppUser user, Function onFail, Function onSucess}) async {
    setLoading(true);
    try {
      final UserCredential result = await auth.signInWithEmailAndPassword(
          email: user.email, password: user.password);
      await _loadCurrentUser(firebaseUser: result.user);

      onSucess();
    } on FirebaseAuthException catch (e) {
      print(e.code);
      onFail(getErrorString(e.code));
    }
    setLoading(false);
  }

  //cadastrar
  Future<void> signUp(
      {AppUser user, Function onFail, Function onSucess}) async {
    setLoading(true);
    try {
      final UserCredential result = await auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);

      //this.user = result.user;
      user.id = result.user.uid;
      this.user = user;
      await user.saveData();

      onSucess();
    } on FirebaseAuthException catch (e) {
      print(e.code);
      onFail(getErrorString(e.code));
    }
    setLoading(false);
  }

  //sair
  void signOut() {
    auth.signOut();
    user = null;
    notifyListeners();
  }

  //OUTROS MÉTODOS
  bool get isLoggedIn => user != null;
  // bool isLoggedIn() {
  //   if (user != null) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }
  //ele n tá sendo preenchido pq no eu só preciso do email e do nome nesse caso ta vindo null tudo kkkk

  Future<void> _loadCurrentUser({User firebaseUser}) async {
    final User currentUser = firebaseUser ?? auth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot docUser =
          await firestore.collection('users').doc(currentUser.uid).get();
      user = AppUser.fromDocument(docUser);

      final docAdmin = await firestore.collection('admins').doc(user.id).get();
      if (docAdmin.exists) {
        user.admin = true;
      }

      notifyListeners();
    }
  }

  bool _loadingFace = false;
  bool get loadingFace => _loadingFace;
  set loadingFace(bool value) {
    _loadingFace = value;
    notifyListeners();
  }

  Future<void> facebookLogin({Function onFail, Function onSuccess}) async {
    loadingFace = true;

    final result = await FacebookLogin().logIn(['email', 'public_profile']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final credential =
            FacebookAuthProvider.credential(result.accessToken.token);

        final authResult = await auth.signInWithCredential(credential);

        if (authResult.user != null) {
          final firebaseUser = authResult.user;

          user = AppUser(
              id: firebaseUser.uid,
              name: firebaseUser.displayName,
              email: firebaseUser.email);

          await user.saveData();

          onSuccess();
        }
        break;
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        onFail(result.errorMessage);
        break;
    }

    loadingFace = false;
  }

  bool get adminEnabled => user != null && user.admin;
}
