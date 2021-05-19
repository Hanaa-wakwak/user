import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:grocery/models/product.dart';
import 'package:grocery/services/database.dart';
import 'package:rxdart/rxdart.dart';

class ProductsReaderBloc {
  final Database database;
  final String category;

  ProductsReaderBloc({@required this.database, @required this.category});


  // ignore: close_sinks
  StreamController<int> productsLengthController = BehaviorSubject();

  Stream<int> get productsLengthStream =>
      productsLengthController.stream;

  Stream<List<Product>> getCategoryProducts(int length) {
    return database
        .getLimitedDataWithValueCondition('products', 'category', category,length)
        .map((snapshots) => snapshots.docs
            .map((snapshot) => Product.fromMap(snapshot.data(), snapshot.id))
            .toList());
  }
}
