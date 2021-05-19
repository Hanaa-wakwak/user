import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery/models/theme_model.dart';
import 'package:grocery/widgets/buttons.dart';
import 'package:grocery/widgets/texts.dart';
import 'package:provider/provider.dart';

///All Dialogs used in the App
class Dialogs {
  static Widget reminder(BuildContext context, {@required String message}) {
    final themeModel = Provider.of<ThemeModel>(context, listen: false);

    double height = MediaQuery.of(context).size.height;
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: themeModel.backgroundColor),
        padding: EdgeInsets.all(20),
        child: Wrap(
          children: [
            Align(
              alignment: Alignment.center,
              child: SvgPicture.asset(
                "images/reminder.svg",
                height: height * 0.25,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: Texts.headline3(message, themeModel.textColor,
                    alignment: TextAlign.center),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Buttons.button(
                  widget: Texts.headline3('OK', Colors.white),
                  function: () {
                    Navigator.pop(context);
                  },
                  color: themeModel.accentColor),
            ),
          ],
        ),
      ),
    );
  }

  static Widget success(BuildContext context, {@required String message}) {
    final themeModel = Provider.of<ThemeModel>(context, listen: false);

    double height = MediaQuery.of(context).size.height;
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: themeModel.backgroundColor),
        padding: EdgeInsets.all(20),
        child: Wrap(
          children: [
            Align(
              alignment: Alignment.center,
              child: SvgPicture.asset(
                "images/success.svg",
                height: height * 0.25,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: Texts.headline3(message, themeModel.textColor,
                    alignment: TextAlign.center),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Buttons.button(
                  widget: Texts.headline3('OK', Colors.white),
                  function: () {
                    Navigator.pop(context);
                  },
                  color: themeModel.accentColor),
            ),
          ],
        ),
      ),
    );
  }

  static Widget error(BuildContext context, {@required String message}) {
    final themeModel = Provider.of<ThemeModel>(context, listen: false);

    double height = MediaQuery.of(context).size.height;
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: themeModel.backgroundColor),
        padding: EdgeInsets.all(20),
        child: Wrap(
          children: [
            Align(
              alignment: Alignment.center,
              child: SvgPicture.asset(
                "images/state_images/error.svg",
                height: height * 0.25,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Align(
                  alignment: Alignment.center,
                  child: Texts.headline3(message, themeModel.textColor)),
            ),
            Align(
              alignment: Alignment.center,
              child: Buttons.button(
                  widget: Texts.headline3('OK', Colors.white),
                  function: () {
                    Navigator.pop(context);
                  },
                  color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
