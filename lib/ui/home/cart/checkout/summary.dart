import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery/blocs/cart_bloc.dart';
import 'package:grocery/blocs/summary_bloc.dart';
import 'package:grocery/models/cart_item.dart';
import 'package:grocery/models/checkout_model.dart';
import 'package:grocery/models/product.dart';
import 'package:grocery/models/theme_model.dart';
import 'package:grocery/services/auth.dart';
import 'package:grocery/services/database.dart';
import 'package:grocery/widgets/cards.dart';
import 'package:grocery/widgets/fade_in.dart';
import 'package:grocery/widgets/texts.dart';
import 'package:provider/provider.dart';
import 'package:decimal/decimal.dart';


class Summary extends StatefulWidget {
  final SummaryBloc bloc;

  const Summary({@required this.bloc});

  static create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final database = Provider.of<Database>(context, listen: false);

    final cartBloc = CartBloc(database: database, uid: auth.uid);

    return Provider<SummaryBloc>(
      create: (context) => SummaryBloc(
        cartBloc: cartBloc,
        uid: auth.uid,
        database: database,
      ),
      child: Consumer<SummaryBloc>(
        builder: (context, bloc, _) {
          return Summary(bloc: bloc);
        },
      ),
    );
  }

  @override
  _SummaryState createState() => _SummaryState();
}

class _SummaryState extends State<Summary> with TickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    final checkoutModel = Provider.of<CheckoutModel>(context, listen: false);
    final themeModel = Provider.of<ThemeModel>(context);
    double width = MediaQuery.of(context).size.width;

    ///If cart is empty, pop to home
    return StreamBuilder<List<CartItem>>(
      stream: widget.bloc.cartBloc.getCartItems(),
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
                stream: widget.bloc.cartBloc.getProducts(cartItems),

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
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        Navigator.pop(context);
                      });
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

                            ]
                        ),
                      );
                    }else{


                      checkoutModel.cartItems=cartItems;

                      num order=checkoutModel.getTotal();
                      return ListView(
                        padding: EdgeInsets.all(20),
                        children: [
                          ///List of cart items
                          Column(
                            children: List.generate(cartItems.length, (index) {
                              return FadeIn(
                                child: Cards.cartCard(context,
                                    cartItem: cartItems[index],
                                    updateQuantity: widget.bloc.cartBloc.updateQuantity,
                                    updateUnit: widget.bloc.cartBloc.updateUnit, delete: () async {
                                      await widget.bloc.cartBloc
                                          .removeFromCart(cartItems[index].reference);
                                    }),
                              );
                            }),
                          ),


                          ///Total price of orders
                          FadeIn(
                            duration: Duration(milliseconds: 400),
                            child: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Texts.text('Order:', themeModel.textColor),
                                  Spacer(),
                                  Texts.headline3(order.toString() + '\$', themeModel.priceColor)
                                ],
                              ),
                            ),
                          ),

                          ///Delivery price
                          FadeIn(
                            duration: Duration(milliseconds: 400),
                            child: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Texts.text('Delivery:', themeModel.textColor),
                                  Spacer(),
                                  Texts.headline3(
                                      checkoutModel.shippingMethod.price.toString() + '\$',
                                      themeModel.priceColor)
                                ],
                              ),
                            ),
                          ),

                          ///Total price: order + delivery
                          FadeIn(
                            duration: Duration(milliseconds: 400),
                            child: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Texts.text('Total:', themeModel.textColor),
                                  Spacer(),
                                  Texts.headline3(
                                      (Decimal.parse(order.toString()) + Decimal.parse(checkoutModel.shippingMethod.price.toString())).toString() +
                                          '\$',
                                      themeModel.priceColor)
                                ],
                              ),
                            ),
                          ),

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


    /*
      StreamBuilder<List<CartItem>>(
      stream: widget.bloc.cartBloc.getCartItems(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<CartItem> cartItems = snapshot.data;

          if (cartItems.length == 0) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.pop(context);
            });

            return FadeIn(
              child: Center(
                child: SvgPicture.asset(
                  'images/state_images/empty_cart.svg',
                  width: width * 0.5,
                  fit: BoxFit.cover,
                ),
              ),
            );
          } else {
            checkoutModel.cartItems=snapshot.data;

            num order=checkoutModel.getTotal();
            return ListView(
              padding: EdgeInsets.all(20),
              children: [
                ///List of cart items
                Column(
                  children: List.generate(cartItems.length, (index) {
                    return FadeIn(
                      child: Cards.cartCard(context,
                          cartItem: cartItems[index],
                          updateQuantity: widget.bloc.cartBloc.updateQuantity,
                          updateUnit: widget.bloc.cartBloc.updateUnit, delete: () async {
                            await widget.bloc.cartBloc
                                .removeFromCart(cartItems[index].reference);
                          }),
                    );
                  }),
                ),


                ///Total price of orders
                FadeIn(
                  duration: Duration(milliseconds: 400),
                  child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Texts.text('Order:', themeModel.textColor),
                        Spacer(),
                        Texts.headline3(order.toString() + '\$', themeModel.priceColor)
                      ],
                    ),
                  ),
                ),

                ///Delivery price
                FadeIn(
                  duration: Duration(milliseconds: 400),
                  child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Texts.text('Delivery:', themeModel.textColor),
                        Spacer(),
                        Texts.headline3(
                            checkoutModel.shippingMethod.price.toString() + '\$',
                            themeModel.priceColor)
                      ],
                    ),
                  ),
                ),

                ///Total price: order + delivery
                FadeIn(
                  duration: Duration(milliseconds: 400),
                  child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Texts.text('Total:', themeModel.textColor),
                        Spacer(),
                        Texts.headline3(
                            (Decimal.parse(order.toString()) + Decimal.parse(checkoutModel.shippingMethod.price.toString())).toString() +
                                '\$',
                            themeModel.priceColor)
                      ],
                    ),
                  ),
                ),

              ],
            );
          }
        } else if (snapshot.hasError) {
          return Center(
            child: Texts.headline1(snapshot.error, Colors.blue),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
       */
  }
}
