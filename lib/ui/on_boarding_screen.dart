import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery/models/theme_model.dart';
import 'package:grocery/ui/landing.dart';
import 'package:grocery/widgets/buttons.dart';
import 'package:grocery/widgets/fade_in.dart';
import 'package:grocery/widgets/texts.dart';
import 'package:provider/provider.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen>
    with TickerProviderStateMixin<OnBoardingScreen> {
  PageController pageViewController = PageController();

  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final themeModel = Provider.of<ThemeModel>(context);

    List<Widget> screens = [
      ///First page
      Container(
        padding: EdgeInsets.all(20),
        color: themeModel.backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: themeModel.secondBackgroundColor,
                    borderRadius:
                        BorderRadius.all(Radius.circular(height * 0.2))),
                child: SvgPicture.asset(
                  "images/on_boarding/1.svg",
                  height: height * 0.4,
                )),
            Padding(
              padding: EdgeInsets.all(20),
              child: Texts.headline3(
                  'Quickly search and add\nhealthy foods to your cart!',
                  themeModel.secondTextColor,
                  alignment: TextAlign.center),
            )
          ],
        ),
      ),

      ///Second Page
      Container(
        padding: EdgeInsets.all(20),
        color: themeModel.backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: themeModel.secondBackgroundColor,
                  borderRadius:
                      BorderRadius.all(Radius.circular(height * 0.2))),
              child: SvgPicture.asset(
                "images/on_boarding/2.svg",
                height: height * 0.4,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Texts.headline3('Super fast delivery\n within two hours!',
                  themeModel.secondTextColor,
                  alignment: TextAlign.center),
            )
          ],
        ),
      ),

      ///Third page
      Container(
        padding: EdgeInsets.all(20),
        color: themeModel.backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: themeModel.secondBackgroundColor,
                    borderRadius:
                        BorderRadius.all(Radius.circular(height * 0.2))),
                child: SvgPicture.asset(
                  "images/on_boarding/3.svg",
                  height: height * 0.4,
                )),
            Padding(
              padding: EdgeInsets.all(20),
              child: Texts.headline3(
                  'Easy payment in delivery!', themeModel.secondTextColor,
                  alignment: TextAlign.center),
            )
          ],
        ),
      ),
    ];

    return Scaffold(
      body: Container(
        color: themeModel.secondBackgroundColor,
        child: Column(
          children: [
            SizedBox(
              height: height * 0.80,
              child: PageView(
                controller: pageViewController,
                children: screens,
                onPageChanged: (index) {
                  setState(() {
                    pageIndex = index;
                  });
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: themeModel.backgroundColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    height: 10,
                    margin: EdgeInsets.only(right: 10, left: 10),
                    width: (pageIndex == 0) ? 20 : 10,
                    decoration: BoxDecoration(
                      color: (pageIndex == 0)
                          ? themeModel.accentColor
                          : themeModel.secondTextColor,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    height: 10,
                    margin: EdgeInsets.only(right: 10),
                    width: (pageIndex == 1) ? 20 : 10,
                    decoration: BoxDecoration(
                      color: (pageIndex == 1)
                          ? themeModel.accentColor
                          : themeModel.secondTextColor,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    height: 10,
                    margin: EdgeInsets.only(right: 10),
                    width: (pageIndex == 2) ? 20 : 10,
                    decoration: BoxDecoration(
                      color: (pageIndex == 2)
                          ? themeModel.accentColor
                          : themeModel.secondTextColor,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: AnimatedSize(
                  vsync: this,
                  duration: Duration(milliseconds: 300),
                  child: (pageIndex == 2)
                      ? Container(
                          width: double.infinity,
                          child: Buttons.button(
                              padding: EdgeInsets.all(10),
                              widget:
                                  Texts.headline3('Get Started', Colors.white),
                              function: () {
                                Landing.create(context);
                              },
                              color: themeModel.accentColor),
                        )
                      : GestureDetector(
                          onTap: () {
                            Landing.create(context);
                          },
                          child: Container(
                            color: Colors.transparent,
                            padding: EdgeInsets.all(10),
                            child: FadeIn(
                              duration: Duration(milliseconds: 300),
                              child:
                                  Texts.headline3('Skip', themeModel.textColor),
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
