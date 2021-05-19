import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery/blocs/addresses_bloc.dart';
import 'package:grocery/models/checkout_bar_model.dart';
import 'package:grocery/models/checkout_model.dart';
import 'package:grocery/models/theme_model.dart';
import 'package:grocery/services/auth.dart';
import 'package:grocery/services/database.dart';
import 'package:grocery/ui/addresses/addresses.dart';
import 'package:grocery/ui/home/cart/checkout/checkout_bar.dart';
import 'package:grocery/ui/home/cart/checkout/shipping.dart';
import 'package:grocery/ui/home/cart/checkout/summary.dart';
import 'package:grocery/ui/home/cart/checkout/payment.dart';

import 'package:grocery/widgets/texts.dart';
import 'package:provider/provider.dart';

class Checkout extends StatelessWidget {
  final CheckoutModel model;

  const Checkout({@required this.model});


  static Future<bool> create(BuildContext context) async{

    final auth=Provider.of<AuthBase>(context,listen: false);
    final database=Provider.of<Database>(context,listen: false);

    return await Navigator.push(context, CupertinoPageRoute(
        builder: (context)=>MultiProvider(
          providers: [


            ChangeNotifierProvider<CheckoutModel>(
              create: (context)=>CheckoutModel(
                pageController:PageController(),
              ),
            ),

            ChangeNotifierProvider<CheckoutBarModel>(
              create: (context)=>CheckoutBarModel(),
            ),



            Provider<AddressesBloc>(
               create: (context) =>AddressesBloc(
               uid: auth.uid,
               database: database
               ),),


          ],
          child: Consumer<CheckoutModel>(
            builder: (context,model,_){
              return Checkout(
                model:model,
              );
            },
          ),
        )
    ));
  }





  @override
  Widget build(BuildContext context) {
    final themeModel=Provider.of<ThemeModel>(context);
    final checkoutBarModel=Provider.of<CheckoutBarModel>(context,listen: false);


    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        title: Texts.headline3("Checkout", themeModel.textColor),
        backgroundColor: themeModel.secondBackgroundColor,
        centerTitle: true,

        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: themeModel.textColor,
          ),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: Theme(
            data: ThemeData(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
            ),

            child: CheckoutBar.create(),
          ),
        ),

      ),
      floatingActionButton: (model.pageIndex==3)? SizedBox(): FloatingActionButton(
        child: Icon(Icons.arrow_forward,
          color: Colors.white,),
        onPressed: (){

          model.goToNextPage(context,model.pageIndex+1);

        },

      ) ,

      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: model.pageController,
        onPageChanged: (page){

          checkoutBarModel.updatePageIndex(page);
        },
        children: [
          Addresses.create(context),
          Shipping.create(context),

          Summary.create(context),
          Payment.create(context)
        ],
      ),

    );
  }


}



