import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:projeto_budega/models/address.dart';

class AppUser {
  AppUser({this.email, this.password, this.name, this.id});
  AppUser.fromDocument(DocumentSnapshot document) {
    id = document.id;
    name = document.data()['name'] as String;
    email = document.data()['email'] as String;
    if (document.data().containsKey('address')) {
      address =
          Address.fromMap(document.data()['address'] as Map<String, dynamic>);
    }
  }
  String id;
  String name;
  String email;
  String password;
  String confirmedPass;
  bool admin = false;
  Address address;
  DocumentReference get firestoreRef =>
      FirebaseFirestore.instance.doc('users/$id');

  CollectionReference get cartReference => firestoreRef.collection('cart');

  CollectionReference get tokensReference =>
      firestoreRef.collection('tokens');


  Future<void> saveData() async {
    await FirebaseFirestore.instance.collection('users').doc(id).set(toMap());
  }

  Future<void> saveToken() async {
    final token = await FirebaseMessaging().getToken();
    await tokensReference.doc(token).set({
      'token': token,
      'updatedAt': FieldValue.serverTimestamp(),
      'platform': Platform.operatingSystem,
    });
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      if (address != null) 'address': address.toMap(),
    };
  }

  void setAddress(Address address) {
    this.address = address;
    saveData();
  }

}
