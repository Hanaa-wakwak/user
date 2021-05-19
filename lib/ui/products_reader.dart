import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery/blocs/products_reader_bloc.dart';
import 'package:grocery/models/product.dart';
import 'package:grocery/models/theme_model.dart';
import 'package:grocery/services/database.dart';
import 'package:grocery/ui/product_details/product_details.dart';
import 'package:grocery/widgets/cards.dart';
import 'package:grocery/widgets/fade_in.dart';
import 'package:grocery/widgets/texts.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ProductReader extends StatelessWidget {
  final ProductsReaderBloc bloc;

  ProductReader({@required this.bloc});

  static create(BuildContext context, String category) {
    final database = Provider.of<Database>(context, listen: false);

    Navigator.push(context, CupertinoPageRoute(builder: (context) {
      return Provider<ProductsReaderBloc>(
        create: (context) =>
            ProductsReaderBloc(database: database, category: category),
        child: Consumer<ProductsReaderBloc>(
          builder: (context, bloc, _) {
            return ProductReader(bloc: bloc);
          },
        ),
      );
    }));
  }

  ScrollController _scrollController = ScrollController();

  int streamLength = 0;
  int productsLength = 0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final themeModel = Provider.of<ThemeModel>(context);

    ///Add products if we are at edge
    _scrollController.addListener(() {
        if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent -50) {
          if (streamLength != -1) {
            bloc.productsLengthController.add(streamLength + 2 * width ~/ 180);
          }
        }

    });

    return Scaffold(
      appBar: AppBar(
        title: Texts.headline3(
            bloc.category.replaceFirst(bloc.category[0],
                bloc.category[0].toUpperCase()),
            themeModel.textColor),
        centerTitle: true,
        backgroundColor: themeModel.secondBackgroundColor,
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
      body: StreamBuilder<int>(
        initialData: (width ~/ 180) * (height ~/ 180),
        stream: bloc.productsLengthStream,
        builder: (context, snapshot) {
          streamLength = snapshot.data;

          return StreamBuilder<List<Product>>(
            stream: bloc.getCategoryProducts(streamLength),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Product> products = snapshot.data;

                productsLength = products.length;

                if (streamLength > products.length) {
                  streamLength = -1;
                }

                if (snapshot.data.length == 0) {
                  ///If no product
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
                                'Nothing found!', themeModel.accentColor,
                                alignment: TextAlign.center),
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  ///If there are products
                  return GridView.count(
                    controller: _scrollController,

                    crossAxisCount: width ~/ 180,
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.only(
                      top: 10,
                      left: 16,
                      right: 16,
                    ),
                    children: List.generate(snapshot.data.length, (index) {
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
                }
              } else if (snapshot.hasError) {

                ///If there is an error
                return Center(
                  child: FadeIn(

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
          );
        },
      ),
    );
  }
}
