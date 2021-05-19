import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery/blocs/home_page_bloc.dart';
import 'package:grocery/models/category.dart';
import 'package:grocery/models/home_model.dart';
import 'package:grocery/models/product.dart';
import 'package:grocery/models/theme_model.dart';
import 'package:grocery/services/database.dart';
import 'package:grocery/ui/product_details/product_details.dart';
import 'package:grocery/ui/products_reader.dart';
import 'package:grocery/widgets/cards.dart';
import 'package:grocery/widgets/fade_in.dart';
import 'package:grocery/widgets/texts.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  final HomePageBloc bloc;

  HomePage({@required this.bloc});

  static Widget create() {
    return Consumer<Database>(
      builder: (context, database, _) {
        return Provider<HomePageBloc>(
          create: (context) => HomePageBloc(
            database: database,
          ),
          child: Consumer<HomePageBloc>(
            builder: (context, bloc, _) {
              return HomePage(
                bloc: bloc,
              );
            },
          ),
        );
      },
    );
  }

  ScrollController _scrollController = ScrollController();

  int productsLength = 0;
  int streamLength = 0;

  Category featuredCategory;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    ///If screen at bottom edge load more products
    _scrollController.addListener(() {
        if (_scrollController.position.pixels >=_scrollController.position.maxScrollExtent-50) {
          if (streamLength != -1) {
            bloc.productsLengthController.add(streamLength + 2 * width ~/ 180);
          }

      }
    });

    final themeModel = Provider.of<ThemeModel>(context);

   // List<Category> categories = bloc.getCategories();
    featuredCategory = bloc.getFeaturedCategory();

    return ListView(
      controller: _scrollController,
      shrinkWrap: true,
      padding: EdgeInsets.only(bottom: 80),
      children: [
        Container(
          decoration: BoxDecoration(
              color: themeModel.secondBackgroundColor,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25)),
              boxShadow: [
                BoxShadow(
                  blurRadius: 30,
                  offset: Offset(0, 5),
                  color: themeModel.shadowColor,
                )
              ]),
          child: Column(
            children: [
              AppBar(
                elevation: 0,
                title: Texts.headline3("Store", themeModel.textColor),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      color: themeModel.textColor,
                    ),
                    onPressed: () {
                      ///If click to search button
                      final homeModel =
                          Provider.of<HomeModel>(context, listen: false);

                      homeModel.goToPage(1);
                    },
                  )
                ],
              ),
              ///Featured category
              GestureDetector(
                onTap: () {
                  ProductReader.create(context, featuredCategory.title);
                },
                child: Container(
                  color: Colors.transparent,
                  height: height * 0.6,
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: FadeInImage(
                          // height: height*0.35,
                          fit: BoxFit.cover,
                          image: AssetImage(featuredCategory.image),
                          placeholder: AssetImage(""),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Texts.headline2(
                            featuredCategory.title.replaceFirst(
                                featuredCategory.title[0],
                                featuredCategory.title[0].toUpperCase()),
                            themeModel.textColor),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Texts.text("Browse", themeModel.secondTextColor),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        ///List of shop
        Container(
          height: 180,
          margin: EdgeInsets.only(
            top: 20,
          ),
          width: double.infinity,
          alignment: Alignment.center,
          child:StreamBuilder<List<Category>>(


            stream: bloc.getCategories(),


            builder: (context,snapshot){

              if(snapshot.hasData){
                List<Category> categories=snapshot.data;

                return  ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(left: 20),
                  itemBuilder: (context, position) {
                    return FadeIn(
                      duration: Duration(milliseconds: 250),
                      child: Cards.categoryCard(
                        context,
                        category: categories[position],
                      ),
                    );
                  },
                  itemCount: categories.length,
                );
              }else if(snapshot.hasError){
                return SizedBox();


              }else{
                return Center(
                  child: CircularProgressIndicator(),
                );
              }





            },

          ),
        ),



      ],
    );
  }
}



///List of products
/*StreamBuilder<int>(
stream: bloc.productsLengthStream,
initialData: 7,
builder: (context, lengthSnapshot) {
streamLength = lengthSnapshot.data;

return StreamBuilder<List<Product>>(
stream: bloc.getProducts(streamLength).asBroadcastStream(),
builder: (context, snapshot) {
if (snapshot.hasData) {
///If there are products
List<Product> products = snapshot.data;

productsLength = products.length;

if (lengthSnapshot.data > products.length) {
streamLength = -1;
}

return GridView.count(
crossAxisCount: width ~/ 180,
shrinkWrap: true,
physics: NeverScrollableScrollPhysics(),
padding: EdgeInsets.only(left: 16, right: 16, top: 20),
children: List.generate(products.length, (index) {
return FadeIn(

child: Cards.gridCard(
themeModel: themeModel,
product: products[index],
width: width,
onTap: () {
ProductDetails.create(context, products[index]);
}),
);
}),
);
} else {
///If loading
return Center(
child: Padding(
padding: EdgeInsets.all(20),
child: CircularProgressIndicator(),
),
);
}
});
},
),*/
