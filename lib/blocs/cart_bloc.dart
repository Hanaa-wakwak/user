import 'package:flutter/cupertino.dart';
import 'package:grocery/models/cart_item.dart';
import 'package:grocery/models/product.dart';
import 'package:grocery/services/database.dart';

class CartBloc {
  final Database database;
  final String uid;

  CartBloc({@required this.database, @required this.uid});

  ///Remove all cart items
  Future<void> removeCart() async {
    await database.removeCollection("users/$uid/cart");
  }

  ///Get products
  Stream<List<Product>> getProducts(List<CartItem> cartItems) {

    List<String> ids=cartItems.map((e) => e.reference).toList();

    return database.getDataWithArrayCondition('products',ids).map((snapshots) =>
        snapshots.docs
            .map((snapshot) => Product.fromMap(snapshot.data(), snapshot.id))
            .toList());
  }

  ///Get cart items
  Stream<List<CartItem>> getCartItems() {
    return database
        .getDataFromCollection("users/$uid/cart")
        .map((snapshots) => snapshots.docs.map((snapshot) {
              return CartItem.fromMap(snapshot.data(), snapshot.id);
            }).toList());
  }

  ///Get products and cart item and check if cart item is in products using RxDart

  ///Remove cart item
  Future<void> removeFromCart(String reference) =>
      database.removeData("users/$uid/cart/$reference");

  ///Update cart item quantity
  Future updateQuantity(String reference, int quantity) async {
    database.updateData({'quantity': quantity}, "users/$uid/cart/$reference");
  }

  ///Update cart item unit
  Future updateUnit(String reference, String unit) async {
    database.updateData({'unit': unit}, "users/$uid/cart/$reference");
  }

  ///Get total price
  num getTotal(List<CartItem> cartItems) {
    num sum = 0;
    cartItems.forEach((cartItem) {
      sum += ((cartItem.unit == 'Piece')
              ? cartItem.product.pricePerPiece
              : (cartItem.unit == 'KG')
                  ? cartItem.product.pricePerKg
                  : cartItem.product.pricePerKg * 0.001) *
          cartItem.quantity;
    });

    return sum;
  }
}
