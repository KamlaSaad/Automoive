import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/models/custom_user.dart';

class DataService {
  // variables
  final String uid;

  // collection refrences
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('usernames');

  DataService({this.uid});
  //functions
  Future updateUserDate(String userName) async {
    return await userCollection.doc(uid).set({
      'name': userName,
    });
  }

  // user data object from asnap shot
  UserData _userDataFromDocSnapShot(DocumentSnapshot snapshot) {
    return UserData(uid: uid, userName: snapshot.data()['name']);
  }

  //get user document throw stream
  Stream<UserData> get userDate {
    return userCollection.doc(uid).snapshots().map(_userDataFromDocSnapShot);
  }
}

class EmailServise {
  // collection refrences
  final CollectionReference emailCollection =
      FirebaseFirestore.instance.collection('emails');
  // set document
  Future updateDate(String email) async {
    return emailCollection.doc(email).set({
      'exists': 1,
    });
  }

  Future findAnEmail(String email) async {
    try {
      dynamic doc = await FirebaseFirestore.instance
          .collection('emails')
          .doc(email)
          .get();
      if (doc.exists) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return e.code;
    }
  }
}
