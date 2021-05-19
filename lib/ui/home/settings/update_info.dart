import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery/models/theme_model.dart';
import 'package:grocery/models/update_info_model.dart';
import 'package:grocery/services/auth.dart';
import 'package:grocery/ui/home/settings/change_password.dart';
import 'package:grocery/widgets/buttons.dart';
import 'package:grocery/widgets/fade_in.dart';
import 'package:grocery/widgets/text_fields.dart';
import 'package:grocery/widgets/texts.dart';
import 'package:provider/provider.dart';

class UpdateInfo extends StatefulWidget {
  final UpdateInfoModel model;

  const UpdateInfo({@required this.model});

  static Future<bool> create(BuildContext context) async {
    final auth = Provider.of<AuthBase>(context, listen: false);

    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: ChangeNotifierProvider<UpdateInfoModel>(
                create: (context) => UpdateInfoModel(auth: auth),
                child: Consumer<UpdateInfoModel>(
                  builder: (context, model, _) {
                    return UpdateInfo(
                      model: model,
                    );
                  },
                ),
              ),
            ));
  }

  @override
  _UpdateInfoState createState() => _UpdateInfoState();
}

class _UpdateInfoState extends State<UpdateInfo> with TickerProviderStateMixin{
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  FocusNode fullNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    fullNameController = TextEditingController(text: widget.model.fullName);
    emailController = TextEditingController(text: widget.model.email);
  }

  @override
  void dispose() {
    super.dispose();
    fullNameController.dispose();
    emailController.dispose();

    fullNameFocus.dispose();
    emailFocus.dispose();

  }


  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 20),
      decoration: BoxDecoration(
          color: themeModel.backgroundColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          boxShadow: [
            BoxShadow(
                blurRadius: 30,
                offset: Offset(0, 5),
                color: themeModel.shadowColor)
          ]),
      child: Wrap(
        children: [

          ///Full name field
          TextFields.emailTextField(
              textEditingController: fullNameController,
              focusNode: fullNameFocus,
              textInputAction: TextInputAction.next,
              textInputType: TextInputType.text,
              labelText: 'Full name',
              iconData: Icons.person_outline,
              onSubmitted: (value) {},
              error: !widget.model.validName,
              isLoading: widget.model.isLoading,
              themeModel: themeModel),

          AnimatedSize(
            duration: Duration(milliseconds: 300),
            vsync: this,
            child: (!widget.model.validName) ? FadeIn(

              child: Texts.helperText("Please enter a valid name", Colors.red),
            ):SizedBox(),

          ),


          ///Email field
          TextFields.emailTextField(
              textEditingController: emailController,
              focusNode: emailFocus,
              textInputAction: TextInputAction.next,
              textInputType: TextInputType.emailAddress,
              labelText: 'Email',
              iconData: Icons.email_outlined,
              onSubmitted: (value) {
                widget.model.submit(
                    context, fullNameController.text, emailController.text);
              },
              error: !widget.model.validEmail,
              isLoading: widget.model.isLoading,
              themeModel: themeModel),

          AnimatedSize(
            duration: Duration(milliseconds: 300),
            vsync: this,
            child: (!widget.model.validEmail) ? FadeIn(

              child: Texts.helperText("Please enter a valid email", Colors.red),
            ):SizedBox(),

          ),
          ///Go to change password
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: widget.model.isLoading
                  ? () {}
                  : () {
                      Navigator.pop(context);

                      ChangePassword.create(context);
                    },
              child: Padding(
                padding: EdgeInsets.only(top: 5),
                child:
                    Texts.subheads('Change password?', themeModel.accentColor),
              ),
            ),
          ),

          /// Submit button <--> Loading indicator
          widget.model.isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  width: double.infinity,
                  child: Buttons.button(
                      widget: Texts.headline3('Update', Colors.white),
                      function: () {
                        widget.model.submit(context, fullNameController.text,
                            emailController.text);
                      },
                      color: themeModel.accentColor),
                ),
        ],
      ),
    );
  }
}
