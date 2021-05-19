import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery/blocs/product_details_bloc.dart';
import 'package:grocery/models/product.dart';
import 'package:grocery/models/select_menu_model.dart';
import 'package:grocery/models/theme_model.dart';
import 'package:grocery/models/unit.dart';
import 'package:grocery/services/auth.dart';
import 'package:grocery/services/database.dart';
import 'package:grocery/ui/product_details/select_menu.dart';
import 'package:grocery/widgets/buttons.dart';
import 'package:grocery/widgets/fade_in.dart';
import 'package:grocery/widgets/texts.dart';
import 'package:provider/provider.dart';
import 'package:grocery/ui/home/cart/checkout/checkout.dart';
// ignore: must_be_immutable
class ProductDetails extends StatefulWidget {
  static void create(BuildContext context, Product product) {
    final database = Provider.of<Database>(context, listen: false);

    final auth = Provider.of<AuthBase>(context, listen: false);


    ProductDetailsBloc bloc= ProductDetailsBloc(
      database: database,
      uid: auth.uid,
      unit: Unit(
        title: "Piece",
        price: product.pricePerPiece,
      ),
    );

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MultiProvider(providers: [
              Provider<ProductDetailsBloc>(
                create: (context) => bloc,
              ),



              ChangeNotifierProvider<SelectMenuModel>(
                create: (context) => SelectMenuModel(
                  pricePerKg: product.pricePerKg,
                  pricePerPiece: product.pricePerPiece,
                  quantity: 1,
                  productDetailsBloc:bloc,
                ),
              )

            ],

            child: Consumer<ProductDetailsBloc>(
                  builder: (context, bloc, _) {
                    return ProductDetails(product: product, bloc: bloc);
                  },
                )

            )));
  }

  final Product product;
  final ProductDetailsBloc bloc;

  ProductDetails({@required this.product, @required this.bloc});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> with TickerProviderStateMixin{
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    final themeModel = Provider.of<ThemeModel>(context);

    return Scaffold(
        body: ListView(
      controller: _scrollController,
      padding: EdgeInsets.only(bottom: 20),
      children: [

        ///Product title
        AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Texts.headline3(widget.product.title, themeModel.textColor),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: themeModel.textColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),

          actions: [

            StreamBuilder<List<String>>(
              stream: widget.bloc.getCartItems(widget.product.reference),
              initialData: [],
              builder: (context,snapshot){
                List<String> references = snapshot.data;
                bool addedToCart = references.contains(widget.product.reference);

                return (addedToCart) ? FadeIn(
                  child: IconButton(
                    icon: Icon(
                      Icons.shopping_cart_outlined,
                      color: themeModel.textColor,
                    ),
                    onPressed: () {
                      Checkout.create(context);
                    },
                  ),
                ): SizedBox();

              },
            ),






          ],
        ),


        ///Product image
        Padding(
          padding: EdgeInsets.all(20),
          child: Hero(tag: widget.product.reference, child: FadeInImage(
            width: width,
            fit: BoxFit.cover,
            image: NetworkImage(widget.product.image),
            placeholder: AssetImage(""),
          )),
        ),


        ///Product reference
        FadeIn(

          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: [
                Texts.headline3("Reference: ", themeModel.accentColor),
                Texts.headline3(widget.product.reference, themeModel.textColor)
              ],
            ),
          ),
        ),


        ///Check if product is in cart
        AnimatedSize(duration: Duration(milliseconds: 300), vsync: this,



          child: StreamBuilder<List<String>>(
            stream: widget.bloc.getCartItems(widget.product.reference),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<String> references = snapshot.data;
                bool addedToCart = references.contains(widget.product.reference);
                return Column(
                  children: [
                    ///If not added, show select menu
                    (!addedToCart)
                        ? FadeIn(
                      child: SelectMenu.create(),
                    )
                        : SizedBox(),


                    ///If added show "Add to cart" else show "Added"

                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: FadeIn(

                        child: Buttons.button(
                            color: themeModel.accentColor,
                            widget: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  addedToCart
                                      ? Icons.done
                                      : Icons.add_shopping_cart,
                                  color: Colors.white,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Texts.headline3(
                                      !addedToCart ? "Add to Cart" : "Added",
                                      Colors.white),
                                )
                              ],
                            ),
                            function: () {
                              (!addedToCart)
                                  ? widget.bloc.addToCart(widget.product.reference).then((value) {
                                _scrollController.animateTo(
                                  0.0,
                                  curve: Curves.easeOut,
                                  duration: const Duration(milliseconds: 300),
                                );
                              })
                                  : widget.bloc
                                  .removeFromCart(widget.product.reference)
                                  .then((value) {
                                _scrollController.animateTo(
                                  0.0,
                                  curve: Curves.easeOut,
                                  duration: const Duration(milliseconds: 300),
                                );
                              });
                            }),
                      ),
                    ),
                  ],
                );
              } else {
                return SizedBox();
              }
            },
          ),
        ),


        FadeIn(
          duration: Duration(milliseconds: 400),

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Product description
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 30),
                child: Texts.headline3("Description", themeModel.accentColor),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Texts.text(widget.product.description, themeModel.textColor),
              ),

              ///Product storage description
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 30),
                child: Texts.headline3("Storage", themeModel.accentColor),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Texts.text(widget.product.storage, themeModel.textColor),
              ),

              ///Product origin description
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 30),
                child: Texts.headline3("Origin", themeModel.accentColor),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Texts.text(widget.product.origin, themeModel.textColor),
              ),
            ],
          ),
        ),

      ],
    ));
  }
}
