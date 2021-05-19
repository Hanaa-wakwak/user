import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery/helpers/validators.dart';
import 'package:grocery/services/auth.dart';
import 'package:grocery/widgets/dialogs.dart';
import 'package:grocery/services/database.dart';

import 'user_profile_model.dart';
import 'user_profile_model.dart';

class SignInModel with ChangeNotifier {
  final AuthBase auth;

  final Database database;
  bool isSignedIn = true;
  bool isLoading = false;
  bool validName = true;
  bool validEmail = true;
  bool validPassword = true;

  SignInModel({@required this.auth, @required this.database});

  void changeSignStatus() {
    isSignedIn = !isSignedIn;
    refreshTextFields();
    notifyListeners();
  }

  void refreshTextFields() {
    if (validName == false) {
      validName = true;
    }

    if (validEmail == false) {
      validEmail = true;
    }

    if (validPassword == false) {
      validPassword = true;
    }
  }

  Future<void> signInWithEmail(
      BuildContext context, String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      if (_verifyInputs(context, email, password)) {
        await auth.signInWithEmailAndPassword(email, password);
        //auth.addUserToDb(UserProfile);
      }
    } catch (e) {
      FirebaseAuthException exception = e;

      showDialog(
          context: context,
          builder: (context) =>
              Dialogs.error(context, message: exception.message));

      //   SnackBars.error(context: context, content: exception);

    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createAccount(
      BuildContext context, String email, String password, String name) async {
    try {
      isLoading = true;
      notifyListeners();

      if (_verifyInputs(context, email, password, name)) {
        final authResult = await auth
            .createUserWithEmailAndPassword(email, password)
            .then((value) {
          auth.addUserToDB(
              auth.uid,
              UserProfile(
                name: auth.displayName,
                email: auth.email,
                photo: auth.profileImage,
                active: 'active',
              ));
          print("data set! ${auth.uid} ${auth.displayName} ");
        });

        if (authResult != null) {
          authResult.user.updateProfile(
            displayName: name,
          );
        }
      }
    } catch (e) {
      FirebaseAuthException exception = e;
      showDialog(
          context: context,
          builder: (context) =>
              Dialogs.error(context, message: exception.message));

      //  SnackBars.error(context: context, content: exception);

    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async => await _signIn(
      context,
      auth.signInWithGoogle().then((value) {
        auth.addUserToDB(
            auth.uid,
            UserProfile(
              name: auth.displayName,
              email: auth.email,
              photo: auth.profileImage,
              active: 'active',
            ));
      }));

  Future<void> signInWithFacebook(BuildContext context) async => await _signIn(
      context,
      auth.signInWithFacebook().then((value) {
        auth.addUserToDB(
            auth.uid,
            UserProfile(
              name: auth.displayName,
              email: auth.email,
              photo: auth.profileImage,
              active: 'active',
            ));
      }));

  Future<void> _signIn(BuildContext context, Future<void> function) async {
    try {
      isLoading = true;
      notifyListeners();
      await function;
    } catch (e) {
      if (e is FirebaseAuthException) {
        FirebaseAuthException exception = e;

        showDialog(
            context: context,
            builder: (context) =>
                Dialogs.error(context, message: exception.message));
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  ///Verify fields input
  bool _verifyInputs(BuildContext context, String email, String password,
      [String name]) {
    bool result = true;

    if (name != null) {
      if (!Validators.name(name)) {
        validName = false;
        result = false;
      } else {
        validName = true;
      }
    }

    if (!Validators.email(email)) {
      validEmail = false;
      result = false;
    } else {
      validEmail = true;
    }

    if (!Validators.password(password)) {
      validPassword = false;
      result = false;
    } else {
      validPassword = true;
    }

    if (!result) {
      notifyListeners();
    }

    return result;
  }
}
