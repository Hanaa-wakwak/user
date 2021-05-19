import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

///All Buttons used in the App
class Buttons {
  static Widget socialButton({
    @required String path,
    @required Color color,
    @required Function function,
  }) {
    return RawMaterialButton(
      onPressed: function,
      elevation: 1.0,
      fillColor: color,
      child: SvgPicture.asset(
        path,
        height: 20,
      ),
      padding: EdgeInsets.all(20.0),
      shape: CircleBorder(),
    );
  }

  static Widget button(
      {@required Widget widget,
      @required Function function,
      @required Color color,
      bool border = false,
      EdgeInsets padding = const EdgeInsets.only(top: 20)}) {
    return Padding(
      padding: padding,
      child: TextButton(
        onPressed: function,
        child: Padding(
          padding: EdgeInsets.all(7),
          child: widget,
        ),
        style: TextButton.styleFrom(
          backgroundColor: (border == true) ? Colors.transparent : color,
          shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: (border == true)
                ? BorderSide(color: color, width: 2)
                : BorderSide.none,
          )
        ),

      )

     /*
      FlatButton(
        onPressed: function,
        color: (border == true) ? Colors.transparent : color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: (border == true)
              ? BorderSide(color: color, width: 2)
              : BorderSide.none,
        ),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: widget,
        ),
      ),

    */
    );
  }
}
