import 'package:app/models/custom_user.dart';
import 'package:app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';

class AuthService {
  //Authentication Var
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // handelling exeptions
  String getMessageFromErrorCode(e) {
    switch (e.code) {
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        return "accountExist".tr();
        break;
      case "wrong-password":
        return "wrongPass".tr();
        break;
      case "user-not-found":
        return "noAcount".tr();
        break;
      case "user-disabled":
        return "disabled".tr();
        break;
      case "operation-not-allowed":
        return "notAllowed".tr();
        break;
      case "invalid-email":
        return "validMail".tr();
        break;
      default:
        return "failed".tr();
        break;
    }
  }

  //stream to get auther changes
  Stream<CustomUser> get user {
    return _auth
        .authStateChanges()
        .map((User user) => _cusUserFromFirebaseuser(user));
  }

  // create a user obj based on firebaseuser
  CustomUser _cusUserFromFirebaseuser(User user) {
    return user != null ? CustomUser(uid: user.uid) : null;
  }

  // register with email and password
  Future registerWithEmailAndPassword(
      String email, String password, String userName) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      await DataService(uid: user.uid).updateUserDate(userName);
      await EmailServise().updateDate(email.toLowerCase());
      if (!user.emailVerified) {
        await user.sendEmailVerification();
      }
      return _cusUserFromFirebaseuser(user);
    } catch (e) {
      String errorMassege = getMessageFromErrorCode(e);
      print(errorMassege);
      return errorMassege;
    }
  }

//Send Password Reset Email
  Future sendPasswordReserEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

//IS Email Verified or not
  Future isEmailVerified() async {
    User user = FirebaseAuth.instance.currentUser;
    if (user.emailVerified) {
      return 1;
    } else {
      await user.sendEmailVerification();
      return 0;
    }
  }

// Find if an email is exists
  Future findIfEmailIsExists(String email) async {
    return await EmailServise().findAnEmail(email.toLowerCase());
  }

  //sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _cusUserFromFirebaseuser(user);
    } catch (e) {
      String errorMassege = getMessageFromErrorCode(e);
      print(errorMassege);
      return errorMassege;
    }
  }

  // change current user password
  Future changeCurrentUserPassword(String newPass) async {
    try {
      User currenUser = _auth.currentUser;
      currenUser.updatePassword(newPass);
      print('success');
      return null;
    } catch (e) {
      String errorMassege = getMessageFromErrorCode(e);
      print(errorMassege);
      return errorMassege;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print('error : ' + e.toString());
      return null;
    }
  }
}
