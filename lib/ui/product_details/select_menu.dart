import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery/models/select_menu_model.dart';
import 'package:grocery/models/theme_model.dart';
import 'package:grocery/models/unit.dart';
import 'package:grocery/widgets/fade_in.dart';
import 'package:grocery/widgets/texts.dart';
import 'package:provider/provider.dart';

class SelectMenu extends StatefulWidget {
  final SelectMenuModel model;



  static Widget create(){

    return Consumer<SelectMenuModel>(
      builder: (context, model, _) {
        return SelectMenu(
          model: model,
        );
      },
    );


  }

  const SelectMenu({@required this.model});

  @override
  _SelectMenuState createState() => _SelectMenuState();
}

class _SelectMenuState extends State<SelectMenu>
    with TickerProviderStateMixin<SelectMenu> {
  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    double width = MediaQuery.of(context).size.width;

    List<Unit> units = widget.model.units;

    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
      padding: EdgeInsets.all(20),
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
              Container(
                width: width / 3 - 20,
                child:
                Texts.headline3("Quantity", themeModel.textColor),
              ),
              Container(
                width: width / 3 - 40,
                alignment: Alignment.center,
                child: Texts.headline3(
                    "${widget.model.quantity} ${units[widget.model.selectedUnit].title}",
                    themeModel.textColor),
              ),
              Container(
                width: width / 3 - 20,
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(
                    (widget.model.isOpen)
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: themeModel.textColor,
                  ),
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    widget.model.updateWidgetStatus();
                  },
                ),
              )
            ],
          ),
          (widget.model.isOpen)
              ? FadeIn(
            child: Padding(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: width / 3 - 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.add,
                            color: themeModel.textColor,
                          ),
                          ///Increase quantity
                          onPressed: () {
                            widget.model.add();
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 18, right: 18),
                          child: Texts.headline3(
                              widget.model.quantity.toString(),
                              themeModel.textColor),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.remove,
                            color: themeModel.textColor,
                          ),
                          ///Decrease quantity
                          onPressed: () {
                            widget.model.minus();
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: width / 3 - 40,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: List.generate(units.length, (index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            top: (index == 0) ? 0 : 10,
                          ),
                          child: GestureDetector(
                            ///Change Unit
                            onTap: () {
                              widget.model.selectUnit(index);
                            },
                            child: Texts.headline3(
                                units[index].title,
                                (widget.model.selectedUnit == index)
                                    ? themeModel.accentColor
                                    : themeModel.textColor),
                          ),
                        );
                      }),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    width: width / 3 - 20,
                    child: Texts.text(
                        "${( Decimal.parse(widget.model.quantity.toString())) * Decimal.parse(units[widget.model.selectedUnit].price.toString())}\$",
                        themeModel.priceColor),
                  )
                ],
              ),
            ),
          )
              : SizedBox(),
        ],
      ),
    );
  }
}
