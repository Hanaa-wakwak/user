import 'package:flutter/material.dart';
import 'package:grocery/models/orders_card_model.dart';
import 'package:grocery/models/orders_item.dart';
import 'package:grocery/models/orders_product_item.dart';
import 'package:grocery/models/theme_model.dart';
import 'package:grocery/widgets/fade_in.dart';
import 'package:grocery/widgets/texts.dart';
import 'package:provider/provider.dart';

class OrdersCard extends StatefulWidget {
  final OrdersCardModel model;
  final OrdersItem order;

  const OrdersCard({@required this.model, @required this.order});

  static Widget create({@required OrdersItem order}) {
    return ChangeNotifierProvider<OrdersCardModel>(
      create: (context) => OrdersCardModel(),
      child: Consumer<OrdersCardModel>(
        builder: (context, model, _) {
          return OrdersCard(
            model: model,
            order: order,
          );
        },
      ),
    );
  }

  @override
  _OrdersCardState createState() => _OrdersCardState();
}

class _OrdersCardState extends State<OrdersCard>
    with TickerProviderStateMixin<OrdersCard> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    final themeModel = Provider.of<ThemeModel>(context, listen: false);

    List<OrdersProductItem> products = widget.order.products;

    return AnimatedSize(
      duration: Duration(milliseconds: 400),
      vsync: this,
      curve: Curves.ease,
      child: GestureDetector(
        onTap: () {
          ///Shrink or expand widget
          widget.model.updateWidget();
        },
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 20),
          padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          decoration: BoxDecoration(
              color: themeModel.secondBackgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                    blurRadius: 30,
                    offset: Offset(0, 5),
                    color: themeModel.shadowColor)
              ]),
          child: Column(
            children: [
              Row(
                children: [
                  ///Order number
                  Texts.headline3(
                      "Order #" + widget.order.id, themeModel.textColor),
                  Spacer(),
                  IconButton(
                      icon: Icon(
                        (widget.model.isExpended)
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: themeModel.textColor,
                      ),
                      onPressed: () {
                        widget.model.updateWidget();
                      }),
                ],
              ),
              (widget.model.isExpended)?  FadeIn(

                child: Column(
                  children: [

                    Row(
                      children: [
                        ///Order date
                        Texts.headline3("Date: ", themeModel.textColor),
                        Spacer(),
                        Texts.headline3(
                            "${widget.order.date}", themeModel.secondTextColor),
                      ],
                    )
                    ,
                    ///List or orders
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Column(
                        children: List.generate(products.length, (position) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: width / 3,
                                child: Texts.headline3(products[position].title,
                                    themeModel.textColor),
                              ),
                              Container(
                                width: width / 3 - 40,
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: Texts.headline3(
                                    products[position].quantity,
                                    themeModel.secondTextColor),
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                width: width / 3 - 40,
                                child: Texts.headline3(
                                    products[position].price.toString() + "\$",
                                    themeModel.priceColor),
                              ),
                            ],
                          );
                        }),
                      ),
                    )
                    ,

                    ///Order status and total price
                    Padding(padding: EdgeInsets.only(top: 10),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (widget.order.status ==
                                  'Delivered')
                                  ? Colors.green
                                  : (widget.order.status == 'Declined')
                                  ? Colors.red
                                  : Colors.orange),
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.only(right: 10),
                          child: Icon(
                            (widget.order.status == 'Delivered')
                                ? Icons.done
                                : (widget.order.status == 'Declined')
                                ? Icons.clear
                                : Icons.pending_outlined,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                        Texts.headline3(
                            widget.order.status,
                            (widget.order.status == 'Delivered')
                                ? Colors.green
                                : (widget.order.status == 'Declined')
                                ? Colors.red
                                : Colors.orange),
                      ],
                    ),
                    ),


                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,

                        child: Wrap(
                          children: [
                            Container(
                              child: Texts.headline3("Payment method: ",
                                  themeModel.secondTextColor),
                            ),
                            Texts.headline3(
                                widget.order.paymentMethod
                                ,
                                themeModel.priceColor),
                          ],
                        ),
                      ),
                    ),



                    Padding(
                      padding: EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          child: Texts.headline3("Delivery:",
                              themeModel.secondTextColor),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(left: 10),
                          child: Texts.headline3(
                              widget.order.shippingMethod.price
                                  .toString() +
                                  "\$",
                              themeModel.priceColor),
                        ),
                      ],
                    ),
                    ),








                    Padding(padding: EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          child: Texts.headline3("Total:",
                              themeModel.secondTextColor),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(left: 10),
                          child: Texts.headline3(
                              (widget.order.orderPrice +
                                  widget
                                      .order
                                      .shippingMethod
                                      .price)
                                  .toString() +
                                  "\$",
                              themeModel.priceColor),
                        ),
                      ],
                    ),
                    )
                  ],
                ),
              ) : SizedBox(),

            ],
          ),
        ),
      ),
    );
  }
}
