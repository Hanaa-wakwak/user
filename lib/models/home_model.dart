import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:grocery/services/auth.dart';
import 'package:grocery/services/database.dart';

class HomeModel {
   PageController pageController=PageController(keepPage: false);
  final Database database;
  final AuthBase auth;

  HomeModel({@required this.database,@required this.auth});

  ///Go to page
  void goToPage(int index) {
    pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }




  // Future<void> checkNotificationToken()async{
  //
  //   DocumentSnapshot document=await database.getFutureDataFromDocument('users/${auth.uid}');
  //   String token=document.data()['token'];
  //
  //   print("Uid: ");
  //
  //   print(auth.uid);
  //   print("Token: ");
  //
  //   print(token);
  //   if(token==null){
  //     FirebaseMessaging _firebaseMessaging=FirebaseMessaging.instance;
  //
  //     token=await _firebaseMessaging.getToken();
  //
  //     await database.setData({
  //       "token": token,
  //     }, 'users/${auth.uid}');
  //
  //     print(token);
  //
  //
  //   }
  //
  // }
}
