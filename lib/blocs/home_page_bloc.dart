import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery/models/category.dart';
import 'package:grocery/models/product.dart';
import 'package:grocery/services/database.dart';

import 'package:rxdart/rxdart.dart';
class HomePageBloc {
  final Database database;

  HomePageBloc({@required this.database});

  // ignore: close_sinks
  StreamController<int> productsLengthController = BehaviorSubject();

  Stream<int> get productsLengthStream =>
      productsLengthController.stream;


  ///Get products
  Stream<List<Product>> getProducts(int length) {
    return database
        .getLimitedDataFromCollection("products",length)
        .map((snapshots) => snapshots.docs.map((snapshot) {
          var data = snapshot.data();
           data['reference'] = snapshot.id;
          return Product.fromMap(data);
            }).toList());
  }



  Stream<List<Category>> getCategories() {
    return database.getDataFromCollection('categories').map((snapshots) => snapshots.docs.map(
            (snapshot) {

              return Category.fromMap(snapshot.data(),snapshot.id);


    }).toList());
  }

  Category getFeaturedCategory() {
    return Category(title: 'Sales', image: 'images/offer.jpg');
  }
}
