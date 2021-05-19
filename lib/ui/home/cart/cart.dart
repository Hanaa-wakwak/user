import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery/blocs/cart_bloc.dart';
import 'package:grocery/models/cart_item.dart';
import 'package:grocery/models/home_model.dart';
import 'package:grocery/models/product.dart';
import 'package:grocery/models/theme_model.dart';
import 'package:grocery/services/auth.dart';
import 'package:grocery/services/database.dart';
import 'package:grocery/ui/home/cart/checkout/checkout.dart';
import 'package:grocery/widgets/buttons.dart';
import 'package:grocery/widgets/cards.dart';
import 'package:grocery/widgets/dialogs.dart';
import 'package:grocery/widgets/fade_in.dart';
import 'package:grocery/widgets/texts.dart';
import 'package:provider/provider.dart';

class Cart extends StatefulWidget {
  final CartBloc bloc;

  const Cart({@required this.bloc});

  static Widget create(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);

    return Provider<CartBloc>(
      create: (context) => CartBloc(
        database: database,
        uid: auth.uid,
      ),
      child: Consumer<CartBloc>(
        builder: (context, bloc, _) {
          return Cart(bloc: bloc,
          );
        },
      ),
    );
  }

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    double width = MediaQuery.of(context).size.width;

    return StreamBuilder<List<CartItem>>(
      stream: widget.bloc.getCartItems(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<CartItem> cartItems=snapshot.data;
          if (cartItems.length == 0) {
            return FadeIn(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'images/state_images/empty_cart.svg',
                      width: width*0.5,
                      fit: BoxFit.cover,
                    ),

                    Padding(
                      padding: EdgeInsets.only(
                          top: 30
                      ),
                      child: Texts.headline3('Nothing found here\nGo and enjoy shopping!', themeModel.accentColor,
                          alignment: TextAlign.center),
                    )
                  ]
              ),
            );
          } else {


            return StreamBuilder<List<Product>>(
                stream: widget.bloc.getProducts(cartItems),

                builder: (context,snapshot){

                  if(snapshot.hasData){

                    List<Product> products=snapshot.data;
                    cartItems=cartItems.where((cartItem){

                      if(products.where((product){
                        if(cartItem.reference==product.reference){
                          cartItem.product=product;
                          return true;
                        }else{
                          return false;
                        }

                      }).length==0){
                        return false;
                      }else{
                        return true;
                      }

                    }).toList();


                    if(cartItems.length == 0) {
                      return FadeIn(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'images/state_images/empty_cart.svg',
                                width: width*0.5,
                                fit: BoxFit.cover,
                              ),

                              Padding(
                                padding: EdgeInsets.only(
                                    top: 30
                                ),
                                child: Texts.headline3('Nothing found here\nGo and enjoy shopping!', themeModel.accentColor,
                                    alignment: TextAlign.center),
                              )
                            ]
                        ),
                      );
                    }else{


                      return ListView(

                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 40, bottom: 80),
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Align(
                              alignment: Alignment.center,
                              child: Texts.headline3("Cart", themeModel.textColor),
                            ),
                          ),
                          ///List of cart items
                          AnimatedSize(
                            vsync: this,
                            duration: Duration(milliseconds: 300),
                            child: Column(
                              children: List.generate(cartItems.length, (index) {
                                return FadeIn(
                                  child: Cards.cartCard(context,

                                      cartItem: cartItems[index],
                                      updateQuantity: widget.bloc.updateQuantity,
                                      updateUnit:  widget.bloc.updateUnit,
                                      delete: ()async{
                                        await widget.bloc
                                            .removeFromCart(
                                            cartItems[index]
                                                .reference);
                                      }),
                                );
                              }),
                            ),
                          ),

                          ///Checkout button
                          FadeIn(
                            duration: Duration(milliseconds: 400),
                            child: Buttons.button(
                                color: themeModel.accentColor,
                                widget: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child:
                                      Texts.headline3("Checkout", Colors.white),
                                    )
                                  ],
                                ),
                                function: () async{
                                  final checkoutResult= await  Checkout.create(context);
                                  if(checkoutResult ?? false){

                                    final homeModel =
                                    Provider.of<HomeModel>(context, listen: false);

                                    homeModel.goToPage(0);

                                    showDialog(context: context,

                                      builder: (context)=>Dialogs.success(context, message: "Congratulations!\nYour order is placed!"),
                                    ).then((value){


                                      widget.bloc.removeCart();



                                    });
                                  }

                                }),
                          )
                        ],
                      );
                    }

                  }else if (snapshot.hasError) {

                    return FadeIn(
                      child: Center(
                        child: SvgPicture.asset(
                          'images/state_images/error.svg',
                          width: width*0.5,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                });


          }
        } else if (snapshot.hasError) {

          return FadeIn(
            child: Center(
              child: SvgPicture.asset(
                'images/state_images/error.svg',
                width: width*0.5,
                fit: BoxFit.cover,
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
