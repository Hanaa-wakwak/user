import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery/blocs/search_bloc.dart';
import 'package:grocery/models/product.dart';
import 'package:grocery/models/category.dart';
import 'package:grocery/models/theme_model.dart';
import 'package:grocery/services/database.dart';
import 'package:grocery/ui/product_details/product_details.dart';
import 'package:grocery/widgets/cards.dart';
import 'package:grocery/widgets/fade_in.dart';
import 'package:grocery/widgets/text_fields.dart';
import 'package:grocery/widgets/texts.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  final SearchBloc bloc;

  Search({@required this.bloc});

  static Widget create() {
    return Consumer<Database>(
      builder: (context, database, _) {
        return Provider<SearchBloc>(
          create: (context) => SearchBloc(database: database),
          child: Consumer<SearchBloc>(
            builder: (context, bloc, _) {
              return Search(
                bloc: bloc,
              );
            },
          ),
        );
      },
    );
  }

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    double width = MediaQuery.of(context).size.width;

    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: Align(
            alignment: Alignment.center,
            child: Texts.headline3("Search", themeModel.textColor),
          ),
        ),

        ///Search field
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: TextFields.searchTextField(
              textEditingController: searchController,
              themeModel: themeModel,
              onSubmitted: (value) {},
              onChanged: (value) {
                if (searchController.text.length == 1) {
                  if (searchController.text[0] !=
                      searchController.text[0].toUpperCase()) {
                    searchController.text = searchController.text.replaceFirst(
                        searchController.text[0],
                        searchController.text[0].toUpperCase());
                    searchController.selection = TextSelection.fromPosition(
                        TextPosition(offset: searchController.text.length));
                  }
                }

                setState(() {});
              }),
        ),

        /// if there is data in textField
        (searchController.text.isNotEmpty)
            ? StreamBuilder<List<Category>>(
          stream: widget.bloc.getSearchedCategories(searchController.text.trim()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Category> iCategories = snapshot.data;

              if (iCategories.length == 0)
              {
                // print("+" + searchController.text + "+");
                ///If nothing found
                return Padding(
                  padding: EdgeInsets.only(top: 50),
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
                        ]),
                  ),
                );
              } else
              {
                print(iCategories.length);
                ///If there are categories
                return GridView.count(
                  crossAxisCount: width ~/ 180,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(
                      left: 16, right: 16, top: 20, bottom: 80),
                  children: List.generate(snapshot.data.length, (index) {
                    return FadeIn(
                      child: Cards.categoryCard(context, category: iCategories[index]),
                    );
                  }),
                );
              }
            } else if (snapshot.hasError) {
              ///If there is an error
              return FadeIn(
                child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: SvgPicture.asset(
                        'images/state_images/error.svg',
                        width: width * 0.5,
                        fit: BoxFit.cover,
                      ),
                    )),
              );
            } else {
              ///If Loading
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        )
            : SizedBox(),
      ],
    );
  }
}