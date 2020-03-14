import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create user object base on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user) {

    return user != null ? User(uid: user.uid) : null;
  }

  // auth change user stream.
  // Returns user if user logs or null if user logs out.
  Stream<User> get user {
     return _auth.onAuthStateChanged.
     map(
       (FirebaseUser user) => _userFromFirebaseUser(user)
       );
      //  map(_userFromFirebaseUser);
  }

  // sign in anonnymous
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    }
    catch(e) {

      print(e.toString());
      return null;

    }
  }

  // sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
  // register with eamil & password
  Future registerWithEmailAndPassword(String email, String password) async
  {
    try {

      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user= result.user;

      // create a new document for the user with the uid
      await DatabaseService(uid: user.uid).updateUserData("0", "New crew member", 100);

      return _userFromFirebaseUser(user);

    } catch(e){
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async{
    try {

      return await _auth.signOut();

    } catch(e) {

      print(e.toString());
      return null;
    }
  }
}