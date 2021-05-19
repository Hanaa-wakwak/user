import 'package:flutter/cupertino.dart';

class ShippingMethod {
  final String title;
  final num price;
  final String duration;
  bool selected;

  ShippingMethod(
      {@required this.title, @required this.price, this.duration,this.selected=false});

  factory ShippingMethod.fromMap(Map<String, dynamic> data) {
    return ShippingMethod(
      title: data['title'],
      price: data['price'],
      duration: data['duration'],
    );
  }
}
