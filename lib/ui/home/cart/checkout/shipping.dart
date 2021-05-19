import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery/blocs/shipping_bloc.dart';
import 'package:grocery/models/checkout_model.dart';
import 'package:grocery/models/shipping_method.dart';
import 'package:grocery/models/theme_model.dart';
import 'package:grocery/services/auth.dart';
import 'package:grocery/services/database.dart';
import 'package:grocery/widgets/fade_in.dart';
import 'package:grocery/widgets/texts.dart';
import 'package:provider/provider.dart';


class Shipping extends StatelessWidget {
  final ShippingBloc bloc;

  const Shipping({@required this.bloc});


  static Widget create(BuildContext context){
    final auth=Provider.of<AuthBase>(context,listen: false);
    final database=Provider.of<Database>(context,listen: false);
    return Provider<ShippingBloc>(
      create: (context)=>ShippingBloc(
          uid:auth.uid,
          database:database
      ),
      child: Consumer<ShippingBloc>(
        builder: (context,bloc,_){
          return Shipping(
            bloc: bloc,
          );
        },
      ),
    );

  }


  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    final themeModel=Provider.of<ThemeModel>(context);

    return StreamBuilder<List<ShippingMethod>>(
      stream: bloc.getShippingMethods(),
      builder: (context,shippingSnapshot){
        if(shippingSnapshot.hasData){
          List<ShippingMethod> shippingMethods=shippingSnapshot.data;

          if(shippingMethods.isEmpty){
            return Center();

          }else{


            final checkoutModel=Provider.of<CheckoutModel>(context,listen: false);
            checkoutModel.shippingMethod=shippingMethods.where((element) => element.selected==true).single;


            return GridView.count(
              crossAxisCount: width ~/ 180 ,
              shrinkWrap: true,
              //   physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 20
              ),
              children: List.generate(shippingMethods.length,(index){
                return FadeIn(

                  child: GestureDetector(
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


                          Padding(
                            padding: EdgeInsets.only(
                                top: 10
                            ),
                            child: Texts.headline3(shippingMethods[index].title, themeModel.textColor),
                          ),

                          Padding(
                            padding: EdgeInsets.only(
                                top: 10
                            ),
                            child: GestureDetector(
                              child: Texts.descriptionText(shippingMethods[index].duration + " (${shippingMethods[index].price}\$)",themeModel.secondTextColor),
                              onTap: (){

                              },
                            ),
                          ),


                          CircularCheckBox(
                            key: Key(shippingMethods[index].title),
                            value: shippingMethods[index].selected,
                            materialTapTargetSize: MaterialTapTargetSize.padded,

                            onChanged: (value){
                              if(!shippingMethods[index].selected){
                                bloc.setSelectedShipping(index);
                              }
                            },
                          )
                        ],
                      ),



                    ),
                    onTap: (){
                      if(!shippingMethods[index].selected){
                        bloc.setSelectedShipping(index);
                      }
                    },
                  ),
                );





              }),
            );

          }





        }else if(shippingSnapshot.hasError){
          return FadeIn(
            child: Padding(padding: EdgeInsets.only(top: 20),
              child: Center(
                child: SvgPicture.asset(
                  'images/state_images/error.svg',
                  width: width * 0.5,
                  fit: BoxFit.cover,
                ),
              ),
            ),

          );
        } else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }



      },
    );
  }
}
