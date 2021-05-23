import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/modal/user.dart' as s;
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods {
  FirebaseAuth authc = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  s.User _userFromFirebaseUser(var user) {
    return user != null ? s.User(userId: user.uid) : null;
  }

  Future signInWithEmailAndPasswod(String email, String password) async {
    try {
      var result = await authc.signInWithEmailAndPassword(
          email: email, password: password);
      var firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      var result = await authc.createUserWithEmailAndPassword(
          email: email, password: password);

      var firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e.toString());
    }
  }

  Future resetPass(String email) async {
    try {
      return await authc.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    try {
      return await authc.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future signInWithGoogle() async {
    try {
      GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);

      final UserCredential userCredential =
          await authc.signInWithCredential(authCredential);
      User user = userCredential.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOutWithGoogle() async {
    return googleSignIn.signOut();
  }
}
