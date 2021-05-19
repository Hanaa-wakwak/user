import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery/blocs/cart_bloc.dart';
import 'package:grocery/services/database.dart';

class SummaryBloc {
  final CartBloc cartBloc;
  final String uid;
  final Database database;
  bool isAccepted = false;

  ///Loading stream
  // ignore: close_sinks
  StreamController<bool> loadingController = StreamController<bool>.broadcast();
  Stream<bool> get loadingStream =>
      loadingController.stream.asBroadcastStream();


  ///Checkbox clicked stream
  // ignore: close_sinks
  StreamController<bool> conditionController = StreamController<bool>.broadcast();

  Stream<bool> get conditionStream =>
      conditionController.stream.asBroadcastStream();





  SummaryBloc(
      {@required this.cartBloc, @required this.uid, @required this.database});



}
