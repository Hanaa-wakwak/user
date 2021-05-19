import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery/blocs/orders_bloc.dart';
import 'package:grocery/models/orders_item.dart';
import 'package:grocery/models/theme_model.dart';
import 'package:grocery/services/auth.dart';
import 'package:grocery/services/database.dart';
import 'package:grocery/ui/orders/orders_card.dart';
import 'package:grocery/widgets/fade_in.dart';
import 'package:grocery/widgets/texts.dart';
import 'package:provider/provider.dart';

class Orders extends StatelessWidget {
  final OrdersBloc bloc;

  const Orders({@required this.bloc});

  static create(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    Navigator.push(context, CupertinoPageRoute(builder: (context) {
      return Provider<OrdersBloc>(
        create: (context) => OrdersBloc(database: database, uid: auth.uid),
        child: Consumer<OrdersBloc>(
          builder: (context, bloc, _) {
            return Orders(bloc: bloc);
          },
        ),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final themeModel = Provider.of<ThemeModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Texts.headline3("My orders", themeModel.textColor),
        backgroundColor: themeModel.secondBackgroundColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: themeModel.textColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder<List<OrdersItem>>(
        stream: bloc.getOrders(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.isEmpty) {

              ///If no orders
              return Center(
                child: FadeIn(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'images/state_images/nothing_found.svg',
                          width: width * 0.5,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: Texts.headline3(
                              'No order found!', themeModel.accentColor,
                              alignment: TextAlign.center),
                        )
                      ]),
                ),
              );
            } else {
              ///If there are orders
              List<OrdersItem> orders = snapshot.data;

              return ListView.builder(
                padding: EdgeInsets.only(bottom: 20),
                itemCount: orders.length,
                itemBuilder: (context,position){
                  return FadeIn(
                    child: OrdersCard.create(order: orders[position]),
                  );
                },
              );
            }
          } else if (snapshot.hasError) {
            ///If there is an error
            return FadeIn(
              child: Center(
                child: SvgPicture.asset(
                  'images/state_images/error.svg',
                  width: width * 0.5,
                  fit: BoxFit.cover,
                ),
              ),
            );
          } else {
            ///If loading
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
