import 'package:flutter/material.dart';
import 'package:grocery/models/settings_model.dart';
import 'package:grocery/models/theme_model.dart';
import 'package:grocery/services/auth.dart';
import 'package:grocery/services/database.dart';

import 'package:grocery/ui/addresses/addresses.dart';
import 'package:grocery/ui/home/settings/update_info.dart';
import 'package:grocery/ui/home/settings/upload_image.dart';
import 'package:grocery/ui/orders/orders.dart';
import 'package:grocery/widgets/cards.dart';
import 'package:grocery/widgets/dialogs.dart';
import 'package:grocery/widgets/texts.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  final SettingsModel model;

  const Settings({@required this.model});

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    final database = Provider.of<Database>(context);
    return ChangeNotifierProvider<SettingsModel>(
      create: (context) => SettingsModel(auth: auth, database: database),
      child: Consumer<SettingsModel>(builder: (context, model, _) {
        return Settings(
          model: model,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final themeModel = Provider.of<ThemeModel>(context);
    return ListView(
      children: [
        ///Profile information
        Container(
          margin: EdgeInsets.only(bottom: 20),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: themeModel.secondBackgroundColor,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                    blurRadius: 30,
                    offset: Offset(0, 5),
                    color: themeModel.shadowColor)
              ]),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  UploadImage.create(context).then((value) {
                    if (value ?? false) {
                      model.updateWidget();
                    }
                  });
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: FadeInImage(
                    placeholder: AssetImage(''),
                    image: (model.profileImage != null)
                        ? NetworkImage(model.profileImage)
                        : AssetImage('images/settings/profile.png'),
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  UpdateInfo.create(context).then((value) {
                    if (value != null) {
                      model.updateWidget();
                    }
                  });
                },
                child: Container(
                  width: width - 148,
                  color: Colors.transparent,
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 2),
                        child: Texts.headline3(
                            model.displayName, themeModel.textColor),
                      ),
                      Texts.text(model.email, themeModel.secondTextColor),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  UpdateInfo.create(context).then((value) {
                    if (value != null) {
                      model.updateWidget();
                    }
                  });
                },
                icon: Icon(
                  Icons.edit,
                  color: themeModel.textColor,
                ),
              ),
            ],
          ),
        ),

        ///Orders
        Cards.settingsCard(
            themeModel: themeModel,
            title: "My orders",
            iconData: Icons.view_headline,
            function: () {
              Orders.create(context);
            }),

        ///Addresses
        Cards.settingsCard(
            themeModel: themeModel,
            title: "My addresses",
            iconData: Icons.location_on,
            function: () {
              Addresses.createWithScaffold(context);
            }),

        ///Live chat: this features will be added soon
        Cards.settingsCard(
            themeModel: themeModel,
            title: "Live chat",
            iconData: Icons.chat,
            function: () {
              showDialog(
                  context: context,
                  builder: (context) => Dialogs.reminder(context,
                      message: 'This feature will be added soon'));
            }),

        /// Dark <--> Light mode switch button
        Container(
          decoration: BoxDecoration(
              color: themeModel.secondBackgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(15))),

          margin: EdgeInsets.only(
            bottom: 10,
            left: 20,
            right: 20,
          ),
          //   padding: EdgeInsets.all(20),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            onTap: () {
              themeModel.updateTheme();
            },
            leading: Icon(
              Icons.star_border,
              color: themeModel.accentColor,
            ),
            title: Texts.text('Dark mode', themeModel.textColor),
            trailing: Switch(
              activeColor: themeModel.accentColor,
              value: themeModel.theme.brightness == Brightness.dark,
              onChanged: (value) {
                themeModel.updateTheme();
              },
            ),
          ),
        ),

        ///Logout
        Container(
          decoration: BoxDecoration(
              color: themeModel.secondBackgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(15))),

          margin: EdgeInsets.only(bottom: 40, left: 20, right: 20, top: 20),
          //   padding: EdgeInsets.all(20),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            onTap: () {
              model.signOut();
            },
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.red,
            ),
            title: Texts.text('Logout', themeModel.textColor),
          ),
        ),
      ],
    );
  }
}
