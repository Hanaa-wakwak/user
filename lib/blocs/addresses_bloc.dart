import 'package:flutter/cupertino.dart';
import 'package:grocery/models/address.dart';
import 'package:grocery/services/database.dart';
import 'package:rxdart/rxdart.dart';

class AddressesBloc {
  final String uid;
  final Database database;

  int addressesLength = 0;

  AddressesBloc({@required this.uid, @required this.database});

  ///Update selected address
  Future<void> setSelectedAddress(int value) async {
    await database
        .setData({'selected': value}, 'users/$uid/settings/addresses');
  }

  ///Delete address
  Future<void> deleteAddress(String id) async {
    await database.removeData('users/$uid/addresses/$id');
  }

  ///Get list of addresses
  Stream<List<Address>> _getAddresses() {
    final snapshots = database.getDataFromCollection('users/$uid/addresses');

    return snapshots.map((snapshots) => snapshots.docs
        .map((snapshot) => Address.fromMap(snapshot.data(), snapshot.id))
        .toList());
  }

  ///Get selected address
  Stream<int> _getSelectedAddress() {
    final snapshot =
        database.getDataFromDocument("users/$uid/settings/addresses");

    return snapshot.map((document) =>
        (document.data() == null) ? 0 : document.data()['selected']);
  }


  ///Get address and selected address and combine them using RxDart
  Stream<List<Address>> getAddresses() {
    return Rx.combineLatest2(_getAddresses(), _getSelectedAddress(),
        (List<Address> addresses, int selectedAddress) {
      if (addresses.length != 0) {
        addresses.forEach((element) {
          element.selected = false;
        });

        selectedAddress = selectedAddress ?? 0;
        if (selectedAddress >= addresses.length) {
          selectedAddress = 0;
        }

        addresses[selectedAddress].selected = true;
      }

      return addresses;
    });
  }
}
