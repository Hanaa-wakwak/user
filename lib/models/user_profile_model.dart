import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  String id, name, photo, email;
  String active;

  UserProfile({this.id, this.name, this.photo, this.email, this.active});


  UserProfile.fromMap(Map snapshot, String id)
      : id = id ?? "",
        name = snapshot["name"] ?? '',
        photo = snapshot["photo"] ?? '',
        email = snapshot["email"] ?? '',
        active = snapshot["active"] ?? 'unknown';

  Map<String, dynamic> toJson() => {
    "name": name,
    "photo": photo,
    "email": email,
    "active": active,
  };

// factory UserProfile.fromDocument(DocumentSnapshot doc) {
//   return UserProfile.fromJson(doc.data());
// }
}
