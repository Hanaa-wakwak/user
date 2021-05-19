import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery/helpers/project_configuration.dart';
import 'package:grocery/models/sign_in_model.dart';
import 'package:grocery/models/theme_model.dart';
import 'package:grocery/services/auth.dart';
import 'package:grocery/widgets/buttons.dart';
import 'package:grocery/widgets/fade_in.dart';
import 'package:grocery/widgets/text_fields.dart';
import 'package:grocery/widgets/texts.dart';
import 'package:provider/provider.dart';
import 'package:grocery/services/database.dart';

class SignIn extends StatefulWidget {
  final SignInModel model;

  SignIn({@required this.model});

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final database = Provider.of<Database>(context, listen: false);
    return ChangeNotifierProvider<SignInModel>(
      create: (BuildContext context) =>
          SignInModel(auth: auth, database: database),
      child: Consumer<SignInModel>(
        builder: (context, model, _) {
          return SignIn(
            model: model,
          );
        },
      ),
    );
  }

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> with TickerProviderStateMixin<SignIn> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpassword= TextEditingController();

  FocusNode fullNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  void dispose() {
    super.dispose();
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    fullNameFocus.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);

    return Center(
        child: NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowGlow();
        return true;
      },
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(20),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: FadeInImage(
              image: AssetImage(ProjectConfiguration.logo),
              placeholder: AssetImage(""),
              width: 100,
              height: 100,
            ),
          ),

          ///Full name field
          AnimatedSize(
            vsync: this,
            duration: Duration(milliseconds: 300),
            child: widget.model.isSignedIn
                ? SizedBox()
                : TextFields.emailTextField(
                    themeModel: themeModel,
                    isLoading: widget.model.isLoading,
                    textEditingController: fullNameController,
                    focusNode: fullNameFocus,
                    textInputAction: TextInputAction.next,
                    textInputType: TextInputType.text,
                    labelText: "Full Name",
                    iconData: Icons.person_outline,
                    onSubmitted: () {
                      _fieldFocusChange(context, fullNameFocus, emailFocus);
                    },
                    error: !widget.model.validName),
          ),

          AnimatedSize(
            duration: Duration(milliseconds: 300),
            vsync: this,
            child: (!widget.model.validName && !widget.model.isSignedIn)
                ? FadeIn(
                    child: Texts.helperText(
                        "Please enter a valid name", Colors.red),
                  )
                : SizedBox(),
          ),

          ///Email field
          TextFields.emailTextField(
              themeModel: themeModel,
              textEditingController: emailController,
              isLoading: widget.model.isLoading,
              focusNode: emailFocus,
              textInputAction: TextInputAction.next,
              textInputType: TextInputType.emailAddress,
              labelText: "Email",
              iconData: Icons.email,
              onSubmitted: () {
                _fieldFocusChange(context, emailFocus, passwordFocus);
              },
              error: !widget.model.validEmail),
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            vsync: this,
            child: (!widget.model.validEmail)
                ? FadeIn(
                    child: Texts.helperText(
                        "Please enter a valid email", Colors.red),
                  )
                : SizedBox(),
          ),

          ///Password field
          TextFields.emailTextField(
              themeModel: themeModel,
              textEditingController: passwordController,
              isLoading: widget.model.isLoading,
              focusNode: passwordFocus,
              textInputAction: TextInputAction.done,
              textInputType: TextInputType.text,
              obscureText: true,
              labelText: "Password",
              iconData: Icons.lock_outline,
              onSubmitted: () {
                widget.model.isSignedIn
                    ? widget.model.signInWithEmail(
                        context, emailController.text, passwordController.text)
                    : widget.model.createAccount(context, emailController.text,
                        passwordController.text, fullNameController.text);
              },
              error: !widget.model.validPassword),
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            vsync: this,
            child: (!widget.model.validPassword)
                ? FadeIn(
                    child: Texts.helperText(
                        'Please enter a valid password : don\'t forget numbers, special characters(@, # ...), capital letters',
                        Colors.red),
                  )
                : SizedBox(),
          ),
          ///confirm pass
          AnimatedSize(
            vsync: this,
            duration: Duration(milliseconds: 300),
            child: widget.model.isSignedIn
                ? SizedBox()
                : TextFields.emailTextField(
                themeModel: themeModel,
                isLoading: widget.model.isLoading,
                textEditingController: confirmpassword,
                obscureText: true,
                textInputAction: TextInputAction.next,
                textInputType: TextInputType.text,
                labelText: "Confirm password",
                iconData: Icons.person_outline,
                onSubmitted: (String value) {
                  if (value.isEmpty) {
                    return 'Please re-enter password';
                  }
                  print(passwordController.text);

                  print(confirmpassword.text);

                  if (passwordController.text != confirmpassword.text) {
                    return "Password does not match";
                  }
                },
                error: !widget.model.validName),
          ),

          AnimatedSize(
            duration: Duration(milliseconds: 300),
            vsync: this,
            child: (!widget.model.validName && !widget.model.isSignedIn)
                ? FadeIn(
              child: Texts.helperText(
                  "Please enter same password", Colors.red),
            )
                : SizedBox(),
          ),
          SizedBox(
            height: 15,
          ),

          ///Sign in button / Loading
          AnimatedSize(
            vsync: this,
            duration: Duration(milliseconds: 300),
            child: widget.model.isLoading
                ? Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Buttons.button(
                    color: themeModel.accentColor,
                    widget: Texts.headline3(
                        widget.model.isSignedIn
                            ? "SIGN IN"
                            : "CREATE AN ACCOUNT",
                        Colors.white),
                    function: widget.model.isSignedIn
                        ? () {
                            widget.model.signInWithEmail(context,
                                emailController.text, passwordController.text);
                          }
                        : () {
                            widget.model.createAccount(
                                context,
                                emailController.text,
                                passwordController.text,
                                fullNameController.text);
                          },
                  ),
          ),

          ///Social Media buttons
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Row(
              children: <Widget>[
                Spacer(),
                Buttons.socialButton(
                    path: "images/sign_in/facebook.svg",
                    color: Color(0xFF3b5998),
                    function: !widget.model.isLoading
                        ? () {
                            widget.model.signInWithFacebook(context);
                          }
                        : null),
                Spacer(),
                Buttons.socialButton(
                    path: "images/sign_in/google.svg",
                    color: Colors.white,
                    function: !widget.model.isLoading
                        ? () {
                            widget.model.signInWithGoogle(context);
                          }
                        : null),
                Spacer(),
              ],
            ),
          ),

          ///Switch  Sign In <--> Create Account
          Align(
            alignment: Alignment.center,
            child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: GestureDetector(
                  onTap: !widget.model.isLoading
                      ? () {
                          //Clear textFields data if switching to create account or signIn
                          widget.model.changeSignStatus();

                          fullNameController.clear();
                          emailController.clear();
                          passwordController.clear();
                          fullNameFocus.unfocus();
                          emailFocus.unfocus();
                          passwordFocus.unfocus();
                        }
                      : null,
                  child: Texts.headline3(
                      widget.model.isSignedIn ? "Create Account" : "Sign In",
                      themeModel.textColor),
                )),
          ),
        ],
      ),
    ));
  }
}
