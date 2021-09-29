import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  late String id;
  late String username;
  late String email;
  late String photoUrl;
  late String displayName;
  late String bio;

  User(
      {required this.id,
      required this.username,
      required this.email,
      required this.photoUrl,
      required this.displayName,
      required this.bio});
  factory User.fromDocument(DocumentSnapshot doc){
    return User(id:doc['id'],
        username:doc['username'],
        email:doc['email'],
        photoUrl:doc['photoUrl'],
        displayName:doc['displayname']
        , bio:doc['bio']);
  }
}