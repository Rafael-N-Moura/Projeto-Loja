import 'package:faker/faker.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:projeto_budega/models/appuser.dart';
import 'package:projeto_budega/models/user_manager.dart';

class AdminUsersManager extends ChangeNotifier {
  List<AppUser> users = [];

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  StreamSubscription _subscription;

  void updateUser(UserManager userManager) async {
    _subscription?.cancel();
    if (userManager.adminEnabled) {
      _listenToUsers();
    } else {
      users.clear();
      notifyListeners();
    }
  }

//Isso ai é pra colocar em ordem alfabetica
  void _listenToUsers() async {
    _subscription =
        firestore.collection('users').snapshots().listen((snapshot) {
      users = snapshot.docs.map((d) => AppUser.fromDocument(d)).toList();
      users
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      notifyListeners();
    });
  }

  List<String> get names => users.map((e) => e.name).toList();

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
