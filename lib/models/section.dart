import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:projeto_budega/models/section_item.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uuid/uuid.dart';

class Section extends ChangeNotifier {
  Section.fromDocument(DocumentSnapshot document) {
    id = document.id;
    name = document.data()['name'] as String;
    type = document.data()['type'] as String;
    items = (document.data()['items'] as List)
        .map((i) => SectionItem.fromMap(i as Map<String, dynamic>))
        .toList();
  }
  Section({this.id, this.name, this.type, this.items}) {
    items = items ?? [];
    originalItems = List.from(items);
  }

  Section clone() {
    return Section(
      id: id,
      name: name,
      type: type,
      items: items.map((e) => e.clone()).toList(),
    );
  }

  String id;
  String name;
  String type;
  List<SectionItem> items;
  List<SectionItem> originalItems;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  DocumentReference get firestoreRef => firestore.doc('home/$id');
  firebase_storage.Reference get storageRef => storage.ref().child('home/$id');
  String _error;
  String get error => _error;
  set error(String value) {
    _error = value;
    notifyListeners();
  }

  void addItem(SectionItem item) {
    items.add(item);
    notifyListeners();
  }

  void removeItem(SectionItem item) {
    items.remove(item);
    notifyListeners();
  }

  bool valid() {
    if (name == null || name.isEmpty) {
      error = 'Título inválido';
    } else if (items.isEmpty) {
      error = 'Insira ao menos uma imagem';
    } else {
      error = null;
    }
    return error == null;
  }

  Future<void> delete() async {
    await firestoreRef.delete();
    for (final item in items) {
      try {
        final ref = storage.refFromURL(item.image as String);
        await ref.delete();
        // ignore: empty_catches
      } catch (e) {}
    }
  }

  Future<void> save(int pos) async {
    final Map<String, dynamic> data = {
      'name': name,
      'type': type,
      'pos': pos,
    };

    if (id == null) {
      final doc = await firestore.collection('home').add(data);
      id = doc.id;
    } else {
      await firestoreRef.update(data);
    }

    for (final item in items) {
      if (item.image is File) {
        final firebase_storage.UploadTask task =
            storageRef.child(Uuid().v1()).putFile(item.image as File);
        final firebase_storage.TaskSnapshot snapshot =
            await task.whenComplete(() => null);
        final String url = await snapshot.ref.getDownloadURL();
        item.image = url;
      }
    }

    for (final original in originalItems) {
      if (!items.contains(original)) {
        try {
          final ref = storage.refFromURL(original.image as String);
          await ref.delete();
          // ignore: empty_catches
        } catch (e) {}
      }
    }

    final Map<String, dynamic> itemsData = {
      'items': items.map((e) => e.toMap()).toList()
    };

    await firestoreRef.update(itemsData);
  }

  @override
  String toString() {
    return 'Section{name: $name, type: $type, items: $items}';
  }
}
