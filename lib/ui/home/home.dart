import 'package:flutter/material.dart';
import 'package:grocery/models/bottom_navigation_bar_model.dart';
import 'package:grocery/models/home_model.dart';
import 'package:grocery/services/auth.dart';
import 'package:grocery/services/database.dart';
import 'package:grocery/ui/home/bottom_navigation_bar_home.dart';
import 'package:grocery/ui/home/home_page.dart';
import 'package:grocery/ui/home/search.dart';
import 'package:grocery/ui/home/settings/settings.dart';
import 'package:provider/provider.dart';

import 'cart/cart.dart';

// ignore: must_be_immutable
class Home extends StatefulWidget {
  final HomeModel model;

  Home({@required this.model});

  static Widget create(BuildContext context) {

    final auth=Provider.of<AuthBase>(context);
    final database=Provider.of<Database>(context);

    return MultiProvider(
      providers: [
        Provider<HomeModel>(
          create: (context) =>
              HomeModel(auth: auth,database: database),
        ),
        ChangeNotifierProvider<BottomNavigationBarModel>(
          create: (context) => BottomNavigationBarModel(),
        ),
      ],
      child: Consumer<HomeModel>(
        builder: (context, model, _) {
          return Home(
            model: model,
          );
        },
      ),
    );
  }

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int pageIndex=0;


  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      key: Key("home"),
      extendBody: true,
      body: PageView(
        controller: widget.model.pageController,
        children: [

          ///Home screens
          HomePage.create(),
          Search.create(),
          Cart.create(context),
          Settings.create(context),
        ],
        onPageChanged: (value) {
          pageIndex=value;
          final bottomModel =
          Provider.of<BottomNavigationBarModel>(context, listen: false);

          bottomModel.goToPage(value);
        },
      ),
      bottomNavigationBar: Consumer<BottomNavigationBarModel>(
        builder: (context, model, _) {
          return BottomNavigationBarHome(
            model: model,
          );
        },
      ),
    ), onWillPop: ()async{
      ///When clicking on return button
      ///If home is in homePage pop else go to homePage
      if(pageIndex==0){
        return true;
      }else{
        widget.model.goToPage(0);
        return false;
      }



    });
  }
}
