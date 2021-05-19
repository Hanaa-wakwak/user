import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery/models/checkout_bar_model.dart';
import 'package:grocery/models/checkout_model.dart';
import 'package:grocery/models/theme_model.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CheckoutBar extends StatelessWidget {
  final CheckoutBarModel model;

  static Widget create(){
    return Consumer<CheckoutBarModel>(
      builder: (context,model,_){
        return CheckoutBar(
          model: model,
        );
      },
    );
  }

  CheckoutBar({@required this.model}) ;

  List<IconData> icons=[
    Icons.location_on,
    Icons.directions_car,
    Icons.view_headline,
    Icons.credit_card
  ];

  @override
  Widget build(BuildContext context) {
    final themeModel=Provider.of<ThemeModel>(context);


    List<Widget> items=List.generate(icons.length, (index){
      return GestureDetector(
        onTap: (){

          ///Conditions to go to next or previous page
          final checkoutModel=Provider.of<CheckoutModel>(context,listen: false);

          if(index<model.currentPage){
            checkoutModel.goToPage(index);
          }else{
            if(index==model.currentPage+1){
              if (index == 1) {

                if (checkoutModel.address != null) {
                  checkoutModel.goToPage(index);
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
              } else if(index==2) {

                if(checkoutModel.shippingMethod!=null){
                  checkoutModel.goToPage(index);
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
                if(checkoutModel.cartItems !=null){
                  if(checkoutModel.cartItems!=[]){
                    checkoutModel.goToPage(index);


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


          }

        },

        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20
          ),
          margin: EdgeInsets.only(
              bottom: 10,
              top: 10
          ),


          decoration: BoxDecoration(
              color:(model.currentPage==index)? themeModel.accentColor : Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(30))
          ),

          child: Icon(
            icons[index],
            size: 25,
            color:(model.currentPage==index)? Colors.white : themeModel.textColor,
          ),
        ),
      );
    });

    return Row(
      children: [
        Spacer(),
        items[0],
        Spacer(),
        items[1],
        Spacer(),
        items[2],
        Spacer(),
        items[3],
        Spacer(),
      ],
    );
  }
}
