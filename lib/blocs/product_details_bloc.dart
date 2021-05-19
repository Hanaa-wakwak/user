import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:grocery/models/unit.dart';
import 'package:grocery/services/database.dart';

class ProductDetailsBloc {
  final Database database;
  final String uid;

  ProductDetailsBloc(
      {@required this.database, @required this.uid, @required this.unit});

  int quantity = 1;
  Unit unit;

  ///Add item to cart
  Future<void> addToCart(String reference) => database.setData({
        'quantity': quantity,
        "unit": unit.title,
      }, "users/$uid/cart/$reference");

  ///Remove item from cart
  Future<void> removeFromCart(String reference) =>
      database.removeData("users/$uid/cart/$reference");

  ///Get cart items id
  Stream<List<String>> getCartItems(String reference) {
    // ignore: close_sinks
    StreamController<List<String>> cartItemsController = StreamController.broadcast();

    database.getDataFromCollection("users/$uid/cart").listen((event) {
      List<String> ids = [];
      event.docs.forEach((e) => ids.add(e.id));
      cartItemsController.add(ids);
    });
    return cartItemsController.stream;
  }
}
