import 'package:flutter/material.dart';
import 'package:grocery/models/edit_cart_model.dart';
import 'package:grocery/models/theme_model.dart';
import 'package:grocery/models/unit.dart';
import 'package:grocery/widgets/texts.dart';
import 'package:provider/provider.dart';
import 'package:decimal/decimal.dart';

class EditCarItem extends StatelessWidget {

  final EditCartModel model;

  const EditCarItem({@required this.model}) ;


  static Widget create({
  @required num pricePerKg,
    @required num pricePerPiece,
    @required int quantity,
    @required Future Function(String,int) updateQuantity,
    @required Future Function(String,String)  updateUnit,
    @required String reference,
    @required String initialUnitTitle,
}){
    return ChangeNotifierProvider<EditCartModel>(
      create: (context) => EditCartModel
        (pricePerKg: pricePerKg,
          pricePerPiece: pricePerPiece,
          quantity: quantity,
          updateQuantity: updateQuantity,
          unitTitle:initialUnitTitle,
          updateUnit: updateUnit,
      reference: reference),

      child: Consumer<EditCartModel>(
        builder: (context,model,_){
          return EditCarItem(
            model: model,
          );
        },
      ),
    );
  }



  @override
  Widget build(BuildContext context) {

    double width=MediaQuery.of(context).size.width;
    final themeModel=Provider.of<ThemeModel>(context);


    List<Unit> units=model.units;
    int selectedUnit=units.indexOf(units.where((unit) => unit.title==model.unitTitle).toList()[0]);

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          color: themeModel.secondBackgroundColor),
      padding: EdgeInsets.all(20),
      child: Wrap(
        children: [
          Align(
            alignment: Alignment.center,
            child: Texts.headline2(
                "Edit",
                themeModel.textColor),
          ),

          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Container(
                  width: width/3-20,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      ///Increase quantity button
                      IconButton(
                        icon: Icon(Icons.add,
                          color: themeModel.secondTextColor,),

                        onPressed: ()async{

                          model.add();

                        },
                      ),


                      Texts.headline3(model.quantity.toString(),  themeModel.textColor),


                      ///Decrease quantity button
                      IconButton(
                        icon: Icon(Icons.remove,
                          color: themeModel.secondTextColor,),

                        onPressed: ()async{
                          model.minus();
                        },
                      ),



                    ],
                  ),
                ),




                Container(
                  width: width/3,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(units.length,
                            (index){


                          return Padding(
                            padding: EdgeInsets.only(
                              top: (index==0) ? 0: 10,
                            ),
                            child: GestureDetector(
                              onTap: (){
                                model.selectUnit(index);
                              },
                              child: Texts.headline3(units[index].title, (selectedUnit==index) ? themeModel.accentColor: themeModel.secondTextColor),



                            ),
                          );






                        }),
                  ),
                ),


                Container(
                  width: width/3-20,
                  alignment: Alignment.center,
                  child:Texts.text("${ Decimal.parse(model.quantity.toString()) * Decimal.parse(units[selectedUnit].price.toString()) }\$",  themeModel.priceColor),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
