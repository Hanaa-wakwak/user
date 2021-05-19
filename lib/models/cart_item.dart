import 'package:flutter/cupertino.dart';
import 'package:grocery/models/product.dart';

class CartItem{
  final String reference;
  final int quantity;
  final String unit;
  Product product;



  factory CartItem.fromMap(Map<String,dynamic> data, String reference){
    return CartItem(
      reference: reference,
      unit: data['unit'],
      quantity: data['quantity']
    );
  }


  CartItem({
    @required this.reference,
    @required this.quantity,
    @required this.unit,
    this.product
  });

}