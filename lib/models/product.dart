import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class Product extends ChangeNotifier {
  Product.fromDocument(DocumentSnapshot document) {
    id = document.id;
    name = document['name'] as String;
    description = document['description'] as String;
    stock = document['stock'] as int;
    price = document['price'] as num;
    images = List<String>.from(document.data()['images'] as List<dynamic>);
    deleted = (document.data()['deleted'] ?? false) as bool;
  }

  Product({
    this.id,
    this.name,
    this.description,
    this.images,
    this.price,
    this.stock,
    this.deleted = false,
  }) {
    images = images ?? [];
    price = price ?? 0;
    stock = stock ?? 0;
  }

  Product clone() {
    return Product(
      id: id,
      name: name,
      description: description,
      price: price,
      stock: stock,
      images: List.from(images),
    );
  }

  String id;
  String name;
  String description;
  num price;
  int stock;
  List<String> images;
  bool deleted;

  List<dynamic> newImages;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  DocumentReference get firestoreRef => firestore.doc('products/$id');
  firebase_storage.Reference get storageRef =>
      storage.ref().child('products').child(id);

  final List<String> updateImages = [];

  void delete() {
    firestoreRef.update({'deleted': true});
  }

  Future<void> save() async {
    loading = true;
    final Map<String, dynamic> data = {
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'deleted': deleted
    };

    if (id == null) {
      final doc = await firestore.collection('products').add(data);
      id = doc.id;
    } else {
      await firestoreRef.update(data);
    }

    final List<String> updateImages = [];

    for (final newImage in newImages) {
      if (images.contains(newImage)) {
        updateImages.add(newImage as String);
      } else {
        final firebase_storage.UploadTask task =
            storageRef.child(Uuid().v1()).putFile(newImage as File);
        final firebase_storage.TaskSnapshot snapshot =
            await task.whenComplete(() => null);
        final String url = await snapshot.ref.getDownloadURL();
        updateImages.add(url);
      }
    }

    for (final image in images) {
      if (!newImages.contains(image) && image.contains('firebase')) {
        try {
          final ref = storage.refFromURL(image);
          await ref.delete();
        } catch (e) {
          debugPrint('Falha ao deletar $image');
        }
      }
    }

    await firestoreRef.update({'images': updateImages});
    images = updateImages;

    loading = false;
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, description: $description, images: $images, newImages: $newImages}';
  }

  bool get hasStock {
    return stock > 0 && !deleted;
    notifyListeners();
  }
}
