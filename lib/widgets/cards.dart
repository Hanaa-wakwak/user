import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery/models/cart_item.dart';
import 'package:grocery/models/category.dart';
import 'package:grocery/models/product.dart';
import 'package:grocery/models/theme_model.dart';
import 'package:grocery/ui/home/cart/edit_cart_item.dart';
import 'package:grocery/ui/product_details/product_details.dart';
import 'package:grocery/ui/products_reader.dart';
import 'package:grocery/widgets/texts.dart';
import 'package:provider/provider.dart';
import 'package:decimal/decimal.dart';

import 'buttons.dart';

/// All Cards used in the App
class Cards{


  static Widget gridCard(
  {@required ThemeModel themeModel,
  @required Product product,
    @required double width,
    @required Function onTap
  }
      ){


    return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(6),
        decoration: BoxDecoration(
            color: themeModel.secondBackgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                blurRadius: 2,
                offset: Offset(0,5),
                color: themeModel.shadowColor
              )
            ]
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [


            Hero(tag: product.reference, child: FadeInImage(
              height: (width *0.5 )  / (width ~/ 180),
              image: NetworkImage(product.image),
              placeholder: AssetImage(""),
            )),

            Padding(
              padding: EdgeInsets.only(
                  top: 10
              ),
              child: Texts.text(product.title, themeModel.textColor,textOverflow: TextOverflow.ellipsis,maxLines: 1),
            ),

            Padding(
              padding: EdgeInsets.only(
                  top: 10
              ),
              child: GestureDetector(
                child: Texts.text("${(product.pricePerKg ==null) ?product.pricePerPiece :product.pricePerKg}\$",themeModel.priceColor),
                onTap: (){

                },
              ),
            ),
          ],
        ),



      ),
      onTap: onTap,
    );



  }



  static Widget categoryCard(
      BuildContext context,
  {@required Category category,}

      ){
    final themeModel=Provider.of<ThemeModel>(context,listen: false);

    return GestureDetector(
      onTap: (){
        ProductReader.create(context, category.title);
      },


      child: Container(
        decoration: BoxDecoration(
          color: themeModel.shadowColor,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        margin: EdgeInsets.only(
            right: 20
        ),
        width: 180,
        height: 180,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FadeInImage(
              width: 100,
              height: 100,
              placeholder: AssetImage(""),
              image: NetworkImage(category.image),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 10,
                  bottom: 10
              ),
              child: Texts.text(category.title.replaceFirst(category.title[0], category.title[0].toUpperCase()), themeModel.textColor),
            )
          ],
        ),



      ),
    );
  }



  static Widget cartCard(
      BuildContext context,

  {
    @required CartItem cartItem,
    @required Future Function() delete,
    @required Future Function(String,int) updateQuantity,
    @required Future Function(String,String) updateUnit,

  }
      ){

    final themeModel=Provider.of<ThemeModel>(context);
    final width=MediaQuery.of(context).size.width;



    return Container(
      decoration: BoxDecoration(
        color:  themeModel.secondBackgroundColor,
        borderRadius:
        BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
                blurRadius: 2,
                offset: Offset(0,5),
                color: themeModel.shadowColor
            )
          ]
      ),
      //  padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: (){
          ProductDetails.create(context, cartItem.product);
        },
        child: Container(
          color: Colors.transparent,

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [


          GestureDetector(
            onTap: (){
              ProductDetails.create(context, cartItem.product);
            },
            child: Container(
              padding: EdgeInsets.only(
                top:20,
                bottom: 20,
                  left: 20
              ),
              color: Colors.transparent,
              child: Hero(
                tag: cartItem.product.reference,
                child: FadeInImage(
                  width: width * 0.2,
                  fit: BoxFit.cover,
                  placeholder: AssetImage(""),
                  image: NetworkImage(
                      cartItem.product.image),
                ),
              ),
            ),
          ),

          Expanded(child: GestureDetector(
            onTap: (){
              ProductDetails.create(context, cartItem.product);
            },
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.only(
                top:20,
                bottom: 20,
                right: 10
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Texts.headline3(
                          cartItem.product.title,
                          themeModel.textColor),
                    ),
                  ),


                  Padding(
                    padding: EdgeInsets.only(
                        top: 10,
                        left: 10
                    ),
                    child:Align(
                      alignment: Alignment.centerLeft,
                      child: Texts.text(
                          cartItem
                              .quantity
                              .toString() +
                              " " +
                              cartItem.unit,
                          themeModel.secondTextColor),

                    ),

                  ),



                  Padding(
                    padding: EdgeInsets.only(
                      top: 10,

                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Texts.text(
                            (Decimal.parse(((cartItem.unit=='Piece') ? cartItem.product.pricePerPiece : (cartItem.unit=='KG') ? cartItem.product.pricePerKg: cartItem.product.pricePerKg * 0.001).toString()) *
                                Decimal.parse(cartItem
                                    .quantity.toString()))
                                .toString() +
                                "\$",
                            themeModel.priceColor),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),

         Column(
           mainAxisAlignment: MainAxisAlignment.start,

           children: [

             Padding(padding: EdgeInsets.only(
               right: 10,
             ),

             child: GestureDetector(
                 child: Icon(Icons.edit,

                   color: themeModel.secondTextColor,
                 ),
                 onTap: (){

                   showModalBottomSheet(
                       context: context,
                       builder: (context) {
                         return EditCarItem.create(pricePerKg: cartItem.product.pricePerKg,
                             pricePerPiece: cartItem.product.pricePerPiece,
                             quantity: cartItem.quantity,
                             initialUnitTitle:cartItem.unit,
                             updateQuantity: updateQuantity,
                             reference: cartItem.reference,
                             updateUnit: updateUnit);
                       });

                 }),
             ),

             Padding(
               padding: EdgeInsets.only(
                 right: 10,
                 top: 20
               ),
               child: GestureDetector(child: Icon(Icons.delete,
                 color: themeModel.secondTextColor,
               ),


                   onTap: (){

                     showModalBottomSheet(
                         context: context,
                         backgroundColor: Colors.transparent,
                         builder: (context) {
                           return Container(
                             decoration: BoxDecoration(
                                 borderRadius: BorderRadius.only(
                                   topLeft: Radius.circular(15),
                                   topRight: Radius.circular(15),
                                 ),
                                 color: themeModel.theme.backgroundColor),
                             padding: EdgeInsets.all(20),
                             child: Wrap(
                               children: [
                                 Align(
                                   alignment: Alignment.center,
                                   child: Texts.headline2(
                                       "Are you Sure?",
                                       themeModel.textColor),
                                 ),
                                 Align(
                                   alignment: Alignment.center,
                                   child: Padding(
                                     padding: EdgeInsets.all(20),
                                     child: Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment
                                           .center,
                                       children: [
                                         Buttons.button(
                                           widget: Texts.headline3(
                                               "Cancel",
                                               themeModel.secondTextColor),
                                           function: () {
                                             Navigator.pop(
                                                 context);
                                           },
                                           color: themeModel.secondTextColor,
                                           border: true,
                                         ),
                                         Padding(
                                           padding:
                                           EdgeInsets.only(
                                               left: 20),
                                           child: Buttons.button(
                                               widget: Texts
                                                   .headline3(
                                                   "Delete",
                                                   Colors
                                                       .white),
                                               function: () async {
                                                 await delete();
                                                 Navigator.pop(context);
                                               },
                                               color:
                                               Colors.red),
                                         ),
                                       ],
                                     ),
                                   ),
                                 )
                               ],
                             ),
                           );
                         });

                   }),
             ),
           ],
         )

        ],
      ),
    ),


      ),
    );

  }




  static Widget settingsCard(
  {@required ThemeModel themeModel,
    @required String title,
    @required IconData iconData,
    @required Function function,

  }
      ){
    return Container(
      decoration: BoxDecoration(
          color: themeModel.secondBackgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(15))
      ),
      margin: EdgeInsets.only(
          bottom: 10,
        left: 20,
        right: 20,
      ),
      //   padding: EdgeInsets.all(20),
      child:ListTile(

        shape: RoundedRectangleBorder(

          borderRadius: BorderRadius.all(Radius.circular(15)),),
        onTap:function,
        leading: Icon(
          iconData,
          color: themeModel.accentColor,
        ),
        title: Texts.text(title, themeModel.textColor),
        trailing: Icon(
          Icons.navigate_next,
          color: themeModel.textColor,
        ),
      ),



    );
  }


}