import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery/blocs/addresses_bloc.dart';
import 'package:grocery/models/address.dart';
import 'package:grocery/models/checkout_model.dart';
import 'package:grocery/models/theme_model.dart';
import 'package:grocery/services/auth.dart';
import 'package:grocery/services/database.dart';
import 'package:grocery/ui/addresses/add_address.dart';
import 'package:grocery/widgets/buttons.dart';
import 'package:grocery/widgets/fade_in.dart';
import 'package:grocery/widgets/texts.dart';
import 'package:provider/provider.dart';

class Addresses extends StatelessWidget {
  final AddressesBloc bloc;

  const Addresses({@required this.bloc});

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    final database = Provider.of<Database>(context);

    return Provider<AddressesBloc>(
      create: (context) => AddressesBloc(uid: auth.uid, database: database),
      child: Consumer<AddressesBloc>(
        builder: (context, bloc, _) {
          return Addresses(bloc: bloc);
        },
      ),
    );
  }

  static createWithScaffold(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final database = Provider.of<Database>(context, listen: false);

    Navigator.push(context, CupertinoPageRoute(builder: (context) {
      return Provider<AddressesBloc>(
        create: (context) => AddressesBloc(uid: auth.uid, database: database),
        child: Consumer<AddressesBloc>(
          builder: (context, bloc, _) {
            final themeModel = Provider.of<ThemeModel>(context, listen: false);

            return Scaffold(
              appBar: AppBar(
                title: Texts.headline3("My addresses", themeModel.textColor),
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
              body: Addresses(bloc: bloc),
            );
          },
        ),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    double width=MediaQuery.of(context).size.width;
    return ListView(
      padding: EdgeInsets.all(20),
      children: [
        ///Add address button
        GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              color: themeModel.secondBackgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  color: themeModel.accentColor,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Texts.headline3('Add address', themeModel.accentColor),
                )
              ],
            ),
          ),
          onTap: () {
            AddAddress.create(context);
          },
        ),



        StreamBuilder<List<Address>>(
          stream: bloc.getAddresses(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {


              ///If there are addresses
              List<Address> addresses = snapshot.data;
              bloc.addressesLength = addresses.length;

              //If Checkout Model in tree
              try {
                final checkoutModel =
                    Provider.of<CheckoutModel>(context, listen: false);

                if (addresses.length == 0) {
                  checkoutModel.address = null;
                } else {
                  checkoutModel.address = addresses
                      .where((element) => element.selected == true)
                      .single;
                }
              } catch (e) {
                print("CheckoutModel not in tree");
              }

              return Column(
                children: List.generate(addresses.length, (position) {
                  return FadeIn(

                    child: Dismissible(
                      key: Key('dismiss${addresses[position].id}'),
                      child: GestureDetector(
                        onTap: () {
                          AddAddress.create(context,
                              address: addresses[position]);
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: themeModel.secondBackgroundColor,
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 2,
                                    offset: Offset(0, 5),
                                    color: themeModel.shadowColor)
                              ]),
                          padding: EdgeInsets.all(20),
                          margin: EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Texts.headline3(
                                  addresses[position].name, themeModel.textColor),
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Texts.text(addresses[position].address,
                                    themeModel.secondTextColor),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Texts.text(
                                    "${addresses[position].state}, ${addresses[position].country}, ${addresses[position].zipCode} ",
                                    themeModel.secondTextColor),
                              ),
                              Row(
                                children: [
                                  Texts.text(addresses[position].phone,
                                      themeModel.secondTextColor),
                                  Spacer(),
                                  Checkbox(
                                    key: Key(addresses[position].id),
                                    value: addresses[position].selected,
                                    onChanged: (value) {
                                      if (!addresses[position].selected) {
                                        bloc.setSelectedAddress(position);
                                      }
                                    },
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      background: Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 2,
                                  offset: Offset(0, 5),
                                  color: themeModel.shadowColor)
                            ]),
                        padding: EdgeInsets.all(20),
                        // alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Texts.text('Delete', Colors.white),
                            )
                          ],
                        ),
                      ),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (direction) async {

                        ///Show delete dialog when swiping
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                    color: themeModel.theme.backgroundColor),
                                padding: EdgeInsets.all(20),
                                child: Wrap(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Texts.headline2("Are you Sure?",
                                          themeModel.secondTextColor),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: EdgeInsets.all(20),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Buttons.button(
                                              widget: Texts.headline3("Cancel",
                                                  themeModel.secondTextColor),
                                              function: () {
                                                Navigator.pop(context);
                                              },
                                              color: themeModel.secondTextColor,
                                              border: true,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 20),
                                              child: Buttons.button(
                                                  widget: Texts.headline3(
                                                      "Delete", Colors.white),
                                                  function: () async {
                                                    await bloc.deleteAddress(
                                                        addresses[position].id);
                                                    Navigator.pop(context);
                                                  },
                                                  color: Colors.red),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            });

                        return false;
                      },
                    ),
                  );
                }),
              );
            } else if (snapshot.hasError) {
              ///If there is an error
              return FadeIn(
                child: Padding(padding: EdgeInsets.only(top: 20),
                  child: Center(
                    child: SvgPicture.asset(
                      'images/state_images/error.svg',
                      width: width * 0.5,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

              );
            } else {
              ///If loading
              return Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 20
                  ),
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        )
      ],
    );
  }
}
