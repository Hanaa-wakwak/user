import 'package:flutter/cupertino.dart';
import 'package:grocery/models/shipping_method.dart';
import 'package:grocery/services/database.dart';
import 'package:rxdart/rxdart.dart';

class ShippingBloc {
  final Database database;
  final String uid;

  ShippingBloc({@required this.database, @required this.uid});

  ///Get shipping methods
  Stream<List<ShippingMethod>> _getShippingMethods() {
    final snapshot = database.getDataFromCollection("shipping");

    return snapshot.map((event) =>
        event.docs.map((e) => ShippingMethod.fromMap(e.data())).toList());
  }

  ///Get shipping methods with selected shipping and combine them using RxDart
  Stream<List<ShippingMethod>> getShippingMethods() {
    return Rx.combineLatest2(_getShippingMethods(), _getSelectedShipping(),
        (List<ShippingMethod> shippingMethods, int selectedShipping) {
      if (shippingMethods.length != 0) {
        shippingMethods.forEach((element) {
          element.selected = false;
        });

        selectedShipping = selectedShipping ?? 0;
        if (selectedShipping >= shippingMethods.length) {
          selectedShipping = 0;
        }
        shippingMethods[selectedShipping].selected = true;
      }

      return shippingMethods;
    });
  }

  ///Get selected shipping index
  Stream<int> _getSelectedShipping() {
    final snapshot =
        database.getDataFromDocument("users/$uid/settings/shipping");

    return snapshot.map((document) =>
        (document.data() == null) ? 0 : document.data()['selected']);
  }

  ///Update selected shipping index
  Future<void> setSelectedShipping(int value) async {
    await database.setData({'selected': value}, 'users/$uid/settings/shipping');
  }
}
