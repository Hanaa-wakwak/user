import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

///Database service
abstract class Database {
  Stream<QuerySnapshot> getDataFromCollection(String path);

  Stream<QuerySnapshot> getLimitedDataFromCollection(String path, int length);

  Stream<DocumentSnapshot> getDataFromDocument(String path);

  Future<DocumentSnapshot> getFutureDataFromDocument(String path);

  Future<void> setData(Map<String, dynamic> data, String path);

  Future<void> removeData(String path);

  Future<void> removeCollection(String path);

  Future<void> updateData(Map<String, dynamic> data, String path);

  Future<bool> checkDocExist(path, String userId);

  Stream<QuerySnapshot> getDataWithArrayCondition(
      String collection, List<String> array);

  Stream<QuerySnapshot> getDataWithValueCondition(
      String collection, String key, String value);

  Stream<QuerySnapshot> getLimitedDataWithValueCondition(
      String collection, String key, String value, int length);

  Stream<QuerySnapshot> getSearchedDataFromCollection(
      String collection, String searchedData);
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  final _service = FirebaseFirestore.instance;

  Future<DocumentSnapshot> getFutureDataFromDocument(String path) {
    return _service.doc(path).get();
  }

  Stream<QuerySnapshot> getDataFromCollection(String path) {
    final snapshots = _service.collection(path).snapshots();

    return snapshots;
  }

  Stream<QuerySnapshot> getLimitedDataFromCollection(String path, int length) {
    final snapshots = _service.collection(path).limit(length).snapshots();

    return snapshots;
  }

  Stream<DocumentSnapshot> getDataFromDocument(String path) {
    final snapshots = _service.doc(path).snapshots();

    return snapshots;
  }

  Stream<QuerySnapshot> getDataWithArrayCondition(
      String collection, List<String> array) {
    final snapshots = _service
        .collection(collection)
        .where(FieldPath.documentId, whereIn: array)
        .snapshots();

    return snapshots;
  }

  Stream<QuerySnapshot> getLimitedDataWithValueCondition(
      String collection, String key, String value, int length) {
    final snapshots = _service
        .collection(collection)
        .where(key, isEqualTo: value)
        .limit(length)
        .snapshots();

    return snapshots;
  }

  Stream<QuerySnapshot> getDataWithValueCondition(
      String collection, String key, String value) {
    final snapshots = _service
        .collection(collection)
        .where(key, isEqualTo: value)
        .snapshots();

    return snapshots;
  }

  Stream<QuerySnapshot> getSearchedDataFromCollection(
      String collection, String searchedData) {
    final snapshots = _service
        .collection(collection)
        .where('title', isGreaterThanOrEqualTo: searchedData)
        .where('title', isLessThan: searchedData + 'z')
        .snapshots();

    return snapshots;
  }

  Future<void> setData(Map<String, dynamic> data, String path) async {
    final snapshots = _service.doc(path);
    await snapshots.set(data);
  }

  Future<void> updateData(Map<String, dynamic> data, String path) async {
    final snapshots = _service.doc(path);
    await snapshots.update(data);
  }

  Future<void> removeData(String path) async {
    final snapshots = _service.doc(path);
    await snapshots.delete();
  }

  Future<void> removeCollection(String path) async {
    await _service.collection(path).get().then((snapshot) async {
      await Future.forEach(snapshot.docs, (doc) async {
        await doc.reference.delete();
      });
    });
  }

  @override
  Future<bool> checkDocExist(path, String userId) async {
    bool exists = false;
    try {
      await _service.doc("$path/$userId").get().then((doc) {
        if (doc.exists)
          exists = true;
        else
          exists = false;
      });
      return exists;
    } catch (e) {
      return false;
    }
  }

}
