import 'package:flutter/material.dart';
import 'package:grocery/blocs/product_details_bloc.dart';
import 'package:grocery/models/unit.dart';

class SelectMenuModel with ChangeNotifier {
  final ProductDetailsBloc productDetailsBloc;

  int quantity;

  final num pricePerKg;
  final num pricePerPiece;
  bool isOpen = false;

  int selectedUnit = 0;

  SelectMenuModel({
    @required this.pricePerKg,
    @required this.pricePerPiece,
    @required this.quantity,
    @required this.productDetailsBloc,
  });

  ///set selected unit
  void selectUnit(int index) {
    selectedUnit = index;
    productDetailsBloc.unit = units[selectedUnit];
    notifyListeners();
  }

  List<Unit> get units => _units();

  List<Unit> _units() {
    List<Unit> units = [
      Unit(
        title: "Piece",
        price: pricePerPiece,
      )
    ];
    if (pricePerKg != null) {
      units.addAll([
        Unit(
          title: "KG",
          price: pricePerKg,
        ),
        Unit(
          title: "Gram",
          price: (pricePerKg * 0.001 == (pricePerKg * 0.001).toInt())
              ? (pricePerKg * 0.001).toInt()
              : pricePerKg * 0.001,
        )
      ]);
    }

    return units;
  }

  ///increase quantity
  void add() {
    quantity++;
    productDetailsBloc.quantity = quantity;
    notifyListeners();
  }

  ///Decrease quantity
  void minus() {
    if (quantity != 1) {
      quantity--;
      productDetailsBloc.quantity = quantity;
      notifyListeners();
    }
  }

  ///Expand <--> Collapse widget
  void updateWidgetStatus() {
    isOpen = !isOpen;
    notifyListeners();
  }
}
