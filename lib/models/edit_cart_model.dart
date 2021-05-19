import 'package:flutter/cupertino.dart';
import 'package:grocery/models/unit.dart';

class EditCartModel with ChangeNotifier {
  int quantity;

  final num pricePerKg;
  final num pricePerPiece;
  String unitTitle;

  final Future Function(String, int) updateQuantity;
  final Future Function(String, String) updateUnit;
  final String reference;

  EditCartModel(
      {@required this.pricePerKg,
      @required this.pricePerPiece,
      @required this.quantity,
      @required this.updateQuantity,
      @required this.updateUnit,
      @required this.reference,
      @required this.unitTitle});


  void selectUnit(int index) async {
    updateUnit(reference, units[index].title).then((value) {
      unitTitle = units[index].title;
      notifyListeners();
    });
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

  void add() async {
    await updateQuantity(reference, quantity + 1).then((value) {
      quantity++;
      notifyListeners();
    });
  }

  void minus() async {
    if (quantity != 1) {
      await updateQuantity(reference, quantity - 1).then((value) {
        quantity--;
        notifyListeners();
      });
    }
  }
}
