import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery/models/payment_model.dart';
import 'package:grocery/models/theme_model.dart';
import 'package:grocery/widgets/buttons.dart';
import 'package:grocery/widgets/fade_in.dart';
import 'package:grocery/widgets/texts.dart';
import 'package:provider/provider.dart';
import 'package:grocery/services/auth.dart';
import 'package:grocery/services/database.dart';
import 'package:grocery/models/checkout_model.dart';
import 'package:decimal/decimal.dart';
class Payment extends StatefulWidget {
  final PaymentModel model;

  const Payment({@required this.model});

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    final database = Provider.of<Database>(context);
    return ChangeNotifierProvider<PaymentModel>(
      create: (context) => PaymentModel(auth: auth, database: database),
      child: Consumer<PaymentModel>(
        builder: (context, model, _) {
          return Payment(model: model);
        },
      ),
    );
  }

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> with TickerProviderStateMixin {
  TextEditingController nameController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cvvController = TextEditingController();

  FocusNode nameFocus = FocusNode();
  FocusNode cardNumberFocus = FocusNode();
  FocusNode cvvFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    final checkoutModel = Provider.of<CheckoutModel>(context, listen: false);

    num order = checkoutModel.getTotal();
    return ListView(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20,top: 20),
      children: [
        FadeIn(
          duration: Duration(milliseconds: 400),
          child:  Container(

            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                color:   themeModel.backgroundColor,
                border: Border.all(width: 2,
                    color: (widget.model.paymentViaDelivery)? themeModel.accentColor:themeModel.secondBackgroundColor),

                borderRadius:
                BorderRadius.all(Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 2,
                    offset: Offset(0,5),
                    color: themeModel.shadowColor,
                  )
                ]
            ),

            child: ListTile(
              trailing: Icon(
                  FontAwesomeIcons.dollarSign,
                color: themeModel.textColor,
              ),
              tileColor: themeModel.backgroundColor,
              contentPadding: EdgeInsets.all(0),
              onTap: () {
                if (!widget.model.paymentViaDelivery) {
                  widget.model
                      .changePaymentMethod(!widget.model.paymentViaDelivery);
                }
              },
              title: Texts.text("Cash in delivery", themeModel.textColor),
              leading: CircularCheckBox(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: widget.model.paymentViaDelivery,
                inactiveColor: themeModel.textColor,
                onChanged: (value) {
                  if (!widget.model.paymentViaDelivery) {
                    widget.model.changePaymentMethod(true);
                  }
                },
              ),
            ),
          ),
        ),
        FadeIn(
          duration: Duration(milliseconds: 400),
          child: Container(
            padding: EdgeInsets.all(10),

            decoration: BoxDecoration(
                color:  themeModel.backgroundColor,

                border: Border.all(width: 2,
                    color:(!widget.model.paymentViaDelivery)? themeModel.accentColor: themeModel.secondBackgroundColor),

                borderRadius:
                BorderRadius.all(Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 2,
                      offset: Offset(0,5),
                      color: themeModel.shadowColor,
                  )
                ]
            ),


            child: ListTile(

              trailing: Icon(
                Icons.credit_card_sharp,
                color: themeModel.textColor,
              ),
              tileColor: themeModel.backgroundColor,
              contentPadding: EdgeInsets.all(0),
              onTap: () {
                widget.model
                    .changePaymentMethod(!widget.model.paymentViaDelivery);
              },
              title: Texts.text("Payment via credit card", themeModel.textColor),
              leading: CircularCheckBox(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: !widget.model.paymentViaDelivery,
                inactiveColor: themeModel.textColor,
                onChanged: (value) {
                  if (widget.model.paymentViaDelivery) {
                    widget.model.changePaymentMethod(false);
                  }
                },
              ),
            ),

          ),
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

        (widget.model.isLoading)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : FadeIn(
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
                          child: Texts.headline3("Confirm Order", Colors.white),
                        )
                      ],
                    ),
                    function: () async {
                      widget.model.submit(context,
                          address: checkoutModel.address,
                          shippingMethod: checkoutModel.shippingMethod,
                          cartItems: checkoutModel.cartItems, order: order);

                    }),
              )
      ],
    );
  }
}
