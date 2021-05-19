import 'package:flutter/cupertino.dart';
import 'package:grocery/services/auth.dart';
import 'package:grocery/services/database.dart';

class SettingsModel with ChangeNotifier {
  final AuthBase auth;
  final Database database;

  SettingsModel({@required this.auth,@required this.database});

  String get profileImage => auth.profileImage ;

  String get displayName => auth.displayName ?? "";

  String get email => auth.email ?? "";

  String get uid => auth.uid;

  Future<void> signOut()async{
   // await database.setData({}, 'users/${auth.uid}');
    await auth.signOut();
  }

  void updateWidget() {
    notifyListeners();
  }
}
