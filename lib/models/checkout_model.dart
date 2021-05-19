import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery/models/address.dart';
import 'package:grocery/models/shipping_method.dart';
import 'package:grocery/models/cart_item.dart';
import 'package:decimal/decimal.dart';
class CheckoutModel with ChangeNotifier {
  final PageController pageController;
  int pageIndex = 0;

  void goToPage(int index) {
    pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
    pageIndex = index;
    notifyListeners();
  }

  void goToNextPage(BuildContext context, int index) {
    if (index == 1) {
      if (address != null) {
        pageController.animateToPage(
          index,
          duration: Duration(milliseconds: 500),
          curve: Curves.ease,
        );
        pageIndex = index;
        notifyListeners();
      }else{
        Fluttertoast.showToast(
            msg: "Please add an address",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
        //    backgroundColor: ,
        //    textColor: Colors.white,
            fontSize: 16.0
        );


      }
    } else if (index == 2) {
      if (shippingMethod != null) {
        pageController.animateToPage(
          index,
          duration: Duration(milliseconds: 500),
          curve: Curves.ease,
        );
        pageIndex = index;
        notifyListeners();
      }else{

        Fluttertoast.showToast(

            msg: "No shipping methods found, check this page later",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,

            fontSize: 16.0
        );

      }
    }else if(index==3){
      if(cartItems !=null){
        if(cartItems!=[]){
          pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 500),
            curve: Curves.ease,
          );
          pageIndex = index;
          notifyListeners();

        }else{
          Fluttertoast.showToast(

              msg: "No items found",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,

              fontSize: 16.0
          );
        }

      }else{
        Fluttertoast.showToast(

            msg: "No items found",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,

            fontSize: 16.0
        );

      }
    }
  }

  ShippingMethod shippingMethod;
  Address address;
  List<CartItem> cartItems;

  CheckoutModel({@required this.pageController});


  num getTotal() {
    num sum = 0;

    cartItems.forEach((cartItem) {

      sum += num.parse((Decimal.parse(((cartItem.unit == 'Piece')
          ? cartItem.product.pricePerPiece
          : (cartItem.unit == 'KG')
          ? cartItem.product.pricePerKg
          : cartItem.product.pricePerKg * 0.001).toString()) *
          Decimal.parse(cartItem.quantity.toString())).toString());
    });

    return sum;
  }
}
