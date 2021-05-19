import 'package:flutter/material.dart';
import 'package:grocery/models/theme_model.dart';

///All textFields used in the App
class TextFields{
  static Widget emailTextField({
  @required TextEditingController textEditingController,
    @required FocusNode focusNode,
  @required TextInputAction textInputAction,
    @required TextInputType textInputType,
    @required String labelText,
    @required IconData iconData,
    @required Function onSubmitted,
    @required bool error,
    @required bool isLoading,
    @required ThemeModel themeModel,
    bool obscureText= false,
}){
    return Container(
      margin: EdgeInsets.only(
          top: 10,

      ),
      padding: EdgeInsets.only(
          left: 10,
          right: 10
      ),
      decoration: BoxDecoration(
        color: themeModel.secondBackgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        border: Border.all(width: 2,color: error ? Colors.red: Colors.transparent),
         /* boxShadow: [
            BoxShadow(
                blurRadius: 30,
                offset: Offset(0,5),
                color: themeModel.shadowColor
            )
          ]*/
      ),
      child: TextField(
        enabled: !isLoading,
        obscureText: obscureText,
        controller: textEditingController,
        focusNode: focusNode,
        textInputAction: textInputAction,
        keyboardType: textInputType,

        onSubmitted: (value){
          onSubmitted();
        },

        decoration: InputDecoration(
          border: InputBorder.none,

          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,

          contentPadding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10
          ),
          labelText: labelText,
          icon: Icon(iconData),





        ),
      ),

    );
  }


  static Widget searchTextField({
    @required TextEditingController textEditingController,
    @required Function(String value) onSubmitted,
    @required Function(String value) onChanged,
    @required ThemeModel themeModel,
  }){
    return Container(
      margin: EdgeInsets.only(
        top: 10,

      ),
      padding: EdgeInsets.only(
          left: 10,
          right: 10
      ),
      decoration: BoxDecoration(
          color: themeModel.secondBackgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
                blurRadius: 5,
                offset: Offset(0,5),
                color: themeModel.shadowColor
            )
          ]
      ),
      child: TextField(
        controller: textEditingController,

        onSubmitted:onSubmitted,
        onChanged: onChanged,

        decoration: InputDecoration(
          border: InputBorder.none,

          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,

          contentPadding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10
          ),
          hintText: 'Search..'





        ),
      ),

    );
  }



  static Widget addressTextField({
    @required ThemeModel themeModel,
    @required TextEditingController controller,
    @required FocusNode focusNode,
    @required TextInputType textInputType,
    @required TextInputAction textInputAction,
    @required String labelText,
    @required Function(String) onSubmitted,
    @required bool error,
    @required enabled,
    bool obscureText=false,
}){

    return Container(
      margin: EdgeInsets.only(
        //  bottom: 10
      ),
      decoration: BoxDecoration(
        color: themeModel.secondBackgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        border: Border.all(color: (error)? Colors.red: themeModel.secondBackgroundColor, width: 2)

      ),
      padding: EdgeInsets.all(10),
      child: TextField(
        enabled: enabled,
        keyboardType: textInputType,
        textInputAction: textInputAction,
        controller: controller,
        focusNode: focusNode,

        obscureText: obscureText,
        onSubmitted:onSubmitted,
        onChanged: (value){
        },


        decoration: InputDecoration(
            border: InputBorder.none,

            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,

            labelText: labelText,
            contentPadding: EdgeInsets.only(
                left: 20,
                right: 20
            )
        ),

      ),

    );
  }






}