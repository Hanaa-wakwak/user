import 'package:flutter/material.dart';
import 'package:grocery/models/bottom_navigation_bar_model.dart';
import 'package:grocery/models/home_model.dart';
import 'package:provider/provider.dart';

class BottomNavigationBarHome extends StatelessWidget {
  final BottomNavigationBarModel model;

  const BottomNavigationBarHome({@required this.model});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(

      onTap: (index){
        model.goToPage(index);

        final homeModel=Provider.of<HomeModel>(context,listen: false);
        homeModel.goToPage(index);

      },
      type: BottomNavigationBarType.fixed,

      showUnselectedLabels: false,
      showSelectedLabels: false,

      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.home,
              color: (model.indexPage == 0) ? Color(0xFF7BED8D):Color(0xFFA6BCD0),
            ),
          label: "Home",

        ),


        BottomNavigationBarItem(
            icon: Icon(Icons.search,
              color: (model.indexPage == 1) ? Color(0xFF7BED8D):Color(0xFFA6BCD0),
            ),
          label: "Search",
        ),

        BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart,
              color: (model.indexPage == 2) ? Color(0xFF7BED8D):Color(0xFFA6BCD0),
            ),
            label: "Cart",
        ),


        BottomNavigationBarItem(
            icon: Icon(Icons.settings,
              color: (model.indexPage == 3) ? Color(0xFF7BED8D):Color(0xFFA6BCD0),
            ),
            label: "Settings"

        ),



      ],
    );
  }
}
