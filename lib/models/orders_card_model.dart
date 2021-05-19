import 'package:flutter/material.dart';

class OrdersCardModel with ChangeNotifier{
  bool isExpended=false;



  ///Expand <--> Collapse widget
  void updateWidget(){
    isExpended=!isExpended;
    notifyListeners();
  }


}