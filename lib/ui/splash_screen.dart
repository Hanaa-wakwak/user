import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery/helpers/project_configuration.dart';
import 'package:grocery/transitions/FadeRoute.dart';
import 'package:grocery/ui/landing.dart';
import 'package:grocery/ui/on_boarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  ///Check if first launch to redirect to onBoarding screen
  Future<bool> checkFirstLaunch(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 1500));

    ///Precache images for better performance
    await Future.forEach(ProjectConfiguration.pngImages, (image) async {
      await precacheImage(AssetImage(image), context);
    });

    await Future.forEach(ProjectConfiguration.svgImages, (image) async {
      await precachePicture(
          ExactAssetPicture(SvgPicture.svgStringDecoder, image), context);
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey("firstLaunch")) {
      return false;
    } else {
      await prefs.setBool("firstLaunch", true);
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder<bool>(
          future: checkFirstLaunch(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              ///Redirect to onBoarding screen if first launch; else to Landing page
              if (snapshot.hasData) {
                if (snapshot.data) {
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushReplacement(
                        context, FadeRoute(page: OnBoardingScreen()));
                  });
                } else {
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    Landing.create(context);
                  });
                }
              }
            }

            return Center(
              child: FadeInImage(
                image: AssetImage(ProjectConfiguration.logo),
                placeholder: AssetImage(""),
                width: 100,
                height: 100,
              ),
            );
          },
        ),
      ),
    );
  }
}
