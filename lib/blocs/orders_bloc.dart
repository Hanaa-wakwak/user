import 'package:flutter/cupertino.dart';
import 'package:grocery/models/orders_item.dart';
import 'package:grocery/services/database.dart';

class OrdersBloc {
  final Database database;
  final String uid;

  OrdersBloc({@required this.database, @required this.uid});

  ///Get list of orders
  Stream<List<OrdersItem>> getOrders() {
    return database
        .getDataFromCollection("users/$uid/orders")
        .map((snapshots) => snapshots.docs.map((snapshot) {
              return OrdersItem.fromMap(snapshot.data(), snapshot.id);
            }).toList());
  }
}
