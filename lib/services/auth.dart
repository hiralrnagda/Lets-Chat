import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/modal/user.dart' as s;
import 'package:geolocator/geolocator.dart';

class AuthMethods {
  FirebaseAuth authc = FirebaseAuth.instance;

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

  Future getUserLocation()async{
    try{
      LocationPermission permission = await Geolocator.checkPermission();
    }
    catch(e){
      LocationPermission permission = await Geolocator.requestPermission();
    }
    

  }
}
