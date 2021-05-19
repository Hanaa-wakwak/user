import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:grocery/models/add_address_model.dart';
import 'package:grocery/models/address.dart';
import 'package:grocery/models/theme_model.dart';
import 'package:grocery/services/auth.dart';
import 'package:grocery/services/database.dart';
import 'package:grocery/widgets/buttons.dart';
import 'package:grocery/widgets/fade_in.dart';
import 'package:grocery/widgets/text_fields.dart';
import 'package:grocery/widgets/texts.dart';
import 'package:provider/provider.dart';


import 'package:country_state_city_picker/country_state_city_picker.dart';


class AddAddress extends StatefulWidget {
  final AddAddressModel model;
  final Address address;

  AddAddress({@required this.model,this.address});

  static void create(BuildContext context,{Address address}){
    final auth=Provider.of<AuthBase>(context,listen: false);
    final database=Provider.of<Database>(context,listen: false);

    Navigator.push(context, CupertinoPageRoute(
      builder: (context)=> ChangeNotifierProvider<AddAddressModel>(
        create: (context)=>AddAddressModel(
          uid:auth.uid,
          database:database,
        ),
        child: Consumer<AddAddressModel>(
          builder: (context,model,_){
            return AddAddress(
                model:model,
              address:address,
            );
          },
        ),
      ),
    ));



  }


  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> with TickerProviderStateMixin {


  String countryValue;
  String stateValue;
  String cityValue;

  TextEditingController nameController=TextEditingController();
  TextEditingController addressController=TextEditingController();
  TextEditingController stateController=TextEditingController();
  TextEditingController phoneController=TextEditingController();
  TextEditingController zipCodeController=TextEditingController();


  FocusNode nameFocus=FocusNode();
  FocusNode addressFocus=FocusNode();
  FocusNode stateFocus=FocusNode();
  FocusNode phoneFocus=FocusNode();
  FocusNode zipCodeFocus=FocusNode();





  @override
  void initState() {
    super.initState();
    if(widget.address!=null){

       nameController=TextEditingController(text: widget.address.name );
       addressController=TextEditingController(text: widget.address.address );
       stateController=TextEditingController(text: widget.address.state);
       widget.model.country=Country.ALL.singleWhere((element) => element.name==widget.address.country);
       phoneController=TextEditingController(text: widget.address.phone.replaceFirst("+"+widget.model.country.dialingCode, ""));
       zipCodeController=TextEditingController(text: widget.address.zipCode);
    }


  }


 @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    addressController.dispose();
    stateController.dispose();
    phoneController.dispose();
    zipCodeController.dispose();

    nameFocus.dispose();
    addressFocus.dispose();
    stateFocus.dispose();
    phoneFocus.dispose();
    zipCodeFocus.dispose();
  }

  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }


  @override
  Widget build(BuildContext context) {
    final themeModel=Provider.of<ThemeModel>(context);


    return Scaffold(
      appBar: AppBar(
        title: Texts.headline3((widget.address!=null) ?  "Edit address" :"Add address" , themeModel.textColor),
        centerTitle: true,
        backgroundColor: themeModel.secondBackgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: themeModel.textColor,
          ),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),

      body: ListView(
        padding: EdgeInsets.all(20),
        children: [

          ///Full name field
          TextFields.addressTextField(themeModel: themeModel,
              controller: nameController,
              focusNode: nameFocus,
              textInputType: TextInputType.text,
              textInputAction: TextInputAction.next,
              labelText: "Full name",
              error: !widget.model.validName,
              enabled: !widget.model.isLoading,
              onSubmitted: (value){
            _fieldFocusChange(context, nameFocus, addressFocus);

              }),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: AnimatedSize(
              duration: Duration(milliseconds: 300),
              vsync: this,
              child: (!widget.model.validName) ? FadeIn(

                child: Texts.helperText("Please enter a valid name", Colors.red),
              ):SizedBox(),

            ),
          ) ,

          ///Address field
          TextFields.addressTextField(themeModel: themeModel,
              controller: addressController,
              focusNode: addressFocus,
              error: !widget.model.validAddress,
              enabled: !widget.model.isLoading,
              textInputType: TextInputType.text,
              textInputAction: TextInputAction.next,
              labelText: "Address",
              onSubmitted: (value){
                _fieldFocusChange(context, addressFocus, stateFocus);

              }),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: AnimatedSize(
              duration: Duration(milliseconds: 300),
              vsync: this,
              child: (!widget.model.validAddress) ? FadeIn(

                child: Texts.helperText("Please enter a valid address", Colors.red),
              ):SizedBox(),

            ),
          ) ,

          ///State-Province field
          TextFields.addressTextField(themeModel: themeModel,
              controller: stateController,
              focusNode: stateFocus,
              error: !widget.model.validState,
              enabled: !widget.model.isLoading,
              textInputType: TextInputType.text,
              textInputAction: TextInputAction.next,
              labelText: "Enter your address in details",
              onSubmitted: (value){
                _fieldFocusChange(context, stateFocus, phoneFocus);
              }),

          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: AnimatedSize(
              duration: Duration(milliseconds: 300),
              vsync: this,
              child: (!widget.model.validState) ? FadeIn(

                child: Texts.helperText("Please enter your address in details", Colors.red),
              ):SizedBox(),

            ),
          ) ,
          ///Country field
       Container(   margin: EdgeInsets.only(
              bottom: 10
          ),
          decoration: BoxDecoration(
            color: themeModel.secondBackgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(15)),

          ),
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child:SelectState(
            onCountryChanged: (value) {
              setState(() {
                countryValue=value;
              });
              SizedBox(height: 20,);
            },

            onStateChanged:(value) {
              setState(() {
                stateValue = value;
              });
            },
            onCityChanged:(value) {
              setState(() {
                cityValue = value;
              });
            },

          ),
       ),

          ///Phone field
          Container(
            decoration: BoxDecoration(
              color: themeModel.secondBackgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(15)),
                border: Border.all(color: (!widget.model.validPhone)? Colors.red: themeModel.secondBackgroundColor, width: 2)
            ),
            padding: EdgeInsets.all(10),


            child: Row(

              children: [
                Padding(
                  padding: EdgeInsets.only(left:20),
                  child: Texts.text("+20", themeModel.textColor),
                ),

                Expanded(

                  child: TextField(
                    enabled: !widget.model.isLoading,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    controller: phoneController,
                    focusNode: phoneFocus,

                    onSubmitted:(value){


                      _fieldFocusChange(context, phoneFocus, zipCodeFocus);



                    },



                    decoration: InputDecoration(
                        border: InputBorder.none,

                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,

                        hintText: "Phone",
                        contentPadding: EdgeInsets.only(
                            left: 20,
                           // right: 20
                        )
                    ),

                  ),
                ),


              ],

            ),

          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: AnimatedSize(
              duration: Duration(milliseconds: 300),
              vsync: this,
              child: (!widget.model.validPhone) ? FadeIn(

                child: Texts.helperText("Please enter a valid phone", Colors.red),
              ):SizedBox(),

            ),
          ) ,
          ///Zip code field
          TextFields.addressTextField(themeModel: themeModel,
              controller: zipCodeController,
              focusNode: zipCodeFocus,
              error: !widget.model.validZip,
              enabled: !widget.model.isLoading,
              textInputType: TextInputType.number,
              textInputAction: TextInputAction.next,
              labelText: "Zip code",
              onSubmitted: (value){
                ///Submit function
                widget.model.addAddress(context, name: nameController.text,
                  address: addressController.text,
                  state: stateController.text,
                  zipCode: zipCodeController.text,
                  phone: phoneController.text,
                  editedId: (widget.address!=null) ? widget.address.id : null,
                );
              }),

          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: AnimatedSize(
              duration: Duration(milliseconds: 300),
              vsync: this,
              child: (!widget.model.validZip) ? FadeIn(

                child: Texts.helperText("Please enter a valid zip code", Colors.red),
              ):SizedBox(),

            ),
          ) ,


          (widget.model.isLoading) ? Center(
            child: CircularProgressIndicator(),
          ) : Buttons.button(widget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Icon(
                Icons.save_outlined,
                color: Colors.white,
              ),

              Padding(
                padding: EdgeInsets.only(
                    left: 10
                ),
                child: Texts.headline3((widget.address!=null) ? 'Update' :'Save', Colors.white),
              )

            ],
          ),
              function: (){
                ///Submit function

                widget.model.addAddress(context, name: nameController.text,
                  address: addressController.text,
                  state: stateController.text,
                  zipCode: zipCodeController.text,
                  phone: phoneController.text,
                  editedId: (widget.address!=null) ? widget.address.id : null,
                );

              },
              color: themeModel.accentColor),





        ],
      ),

    );
  }
}
