import 'package:flutter/cupertino.dart';
import 'package:flutter_country_picker/country.dart';
import 'package:grocery/services/database.dart';

class AddAddressModel with ChangeNotifier {
  final Database database;
  final String uid;

  Country country = Country.US;

  bool validName = true;
  bool validAddress = true;
  bool validState = true;
  bool validPhone = true;
  bool validZip = true;

  bool isLoading = false;

  bool _verifyInputs(
      String name, String address, String state, String phone, String zipCode) {
    bool result = true;

    if (name.replaceAll(" ", "").length < 4) {
      validName = false;
      result = false;
    } else {
      validName = true;
    }

    if (address.replaceAll(" ", "").length < 4) {
      validAddress = false;
      result = false;
    } else {
      validAddress = true;
    }

    if (state.replaceAll(" ", "").length < 4) {
      validState = false;
      result = false;
    } else {
      validState = true;
    }

    if (phone.replaceAll(" ", "").length < 7) {
      validPhone = false;
      result = false;
    } else {
      validPhone = true;
    }

    if (zipCode.replaceAll(" ", "").length < 4) {
      validZip = false;
      result = false;
    } else {
      validZip = true;
    }

    if (!result) {
      notifyListeners();
    }

    return result;
  }

  void changeCountry(Country newCountry) {
    country = newCountry;
    notifyListeners();
  }

  Future<void> addAddress(
    BuildContext context, {
    @required String name,
    @required String address,
    @required String state,
    @required String zipCode,
    @required String phone,
    String editedId,
  }) async {
    if (_verifyInputs(name, address, state, phone, zipCode)) {
      isLoading = true;
      notifyListeners();

      String id;
      if (editedId == null) {
        DateTime date = DateTime.now();

        id = date.year.toString() +
            date.month.toString() +
            date.day.toString() +
            date.hour.toString() +
            date.minute.toString() +
            date.second.toString() +
            date.millisecond.toString() +
            date.microsecond.toString();
      } else {
        id = editedId;
      }

      (editedId == null)
          ? await database.setData({
              'name': name,
              'address': address,
              'state': state,
              'country': country.name,
              'zip_code': zipCode,
              'phone': "+" + country.dialingCode + phone
            }, 'users/$uid/addresses/$id')
          : await database.updateData({
              'name': name,
              'address': address,
              'state': state,
              'country': country.name,
              'zip_code': zipCode,
              'phone': "+" + country.dialingCode + phone
            }, 'users/$uid/addresses/$id');

      isLoading = false;
      notifyListeners();
      Navigator.pop(context);
    }
  }

  AddAddressModel({@required this.database, @required this.uid})
      : assert(uid != null && database != null);
}
