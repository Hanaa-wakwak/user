import 'package:flutter/cupertino.dart';
import 'package:grocery/models/shipping_method.dart';

import 'orders_product_item.dart';

class OrdersItem{
  final String id;
  final List<OrdersProductItem> products;
  final ShippingMethod shippingMethod;
  final num orderPrice;
  final String status;
  final String date;
  final String paymentMethod;

  factory OrdersItem.fromMap(Map data,String id){
    return OrdersItem(
        id: id,
        paymentMethod: data["payment_method"] ?? "Cash in delivery",
        products: OrdersProductItem.fromMap(data['products']),
        shippingMethod: ShippingMethod(
          title: data['shipping_method']['title'],
          price: data['shipping_method']['price'],
        ),
        orderPrice: data['order'],
      status: data['status'] ?? "Processing",
      date: data['date']
    );
  }


  OrdersItem({@required this.id,@required this.products,@required this.shippingMethod,@required this.orderPrice,@required this.paymentMethod,@required this.status,@required this.date});






}