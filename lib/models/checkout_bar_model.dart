import 'package:flutter/cupertino.dart';

class CheckoutBarModel with ChangeNotifier{
  int currentPage=0;


  void updatePageIndex(int index){
    currentPage=index;
    notifyListeners();
  }

}