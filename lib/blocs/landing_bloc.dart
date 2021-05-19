import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:grocery/services/auth.dart';
import 'package:grocery/services/database.dart';

class LandingBloc{
  final Auth auth;
  final Database database;

  LandingBloc({@required this.auth,@required this.database});
  Stream<User> get onAuthStateChanged => auth.onAuthStateChanged;

}