import 'package:bhrammanbeta/database/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  FirebaseAuth _auth  = FirebaseAuth.instance;
  DatabaseService databaseService = DatabaseService();
  GoogleSignIn _googleSignIn = GoogleSignIn();

  static String sharedPrefLoggedInUserKey = 'ISLOGGEDIN';
  static String sharedPrefUserName = "userName";
  static String sharedPrefUserId = "userId";
  static String sharedPrefProfilePhotoUrl = "profilePhoto";
  static String sharedPrefCurrentCity = "currentCity";
  static String sharedPrefCurrentState = "currentState";
  static String sharedPrefOnBoardingScreenSeen = "onBoardingScreen";
  static String sharedPrefAccountTypeBusiness = "business";

  Future registerWithEmailAndPassword({String email,String password,String name, String phone})async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      FirebaseUser user  = result.user;
      await databaseService.createUserInDatabase(email: email,userId:user.uid,name: name,profilePic: 'null',phone: phone);
      await saveUserNameSharedPref(name);
      await saveUserIdSharedPref(user.uid);
      return user.uid;

    }
    catch(e) {
      print(e.toString());
      return null;
    }
  }

  Future<FirebaseUser> googleSignIn() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    AuthCredential credential = GoogleAuthProvider.getCredential(idToken:googleAuth.idToken,
        accessToken: googleAuth.accessToken);

    AuthResult result = await _auth.signInWithCredential(credential);
    FirebaseUser user  = result.user;
    await databaseService.createUserInDatabase(email: user.email,userId:user.uid,name: user.displayName,profilePic: user.photoUrl,phone: user.phoneNumber);
    return user;
  }
  
  
  static Future<void> saveUserLoggedInSharedPref(bool isUserLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPrefLoggedInUserKey, isUserLoggedIn);
  }

  static Future<void> saveUserNameSharedPref(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPrefUserName, userName);

  }

  static Future<void> saveUserIdSharedPref(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPrefUserId, userId);

  }

  static Future<void> saveProfilePhotoSharedPref(String profilePhoto)  async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
     prefs.setString(sharedPrefProfilePhotoUrl, profilePhoto);
  }

  static Future<String> getProfilePhotoSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(sharedPrefProfilePhotoUrl);
  }


  static Future<String> getUserNameSharePref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return  prefs.getString(sharedPrefUserName);

  }

  static Future<String> getUserIdSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return  prefs.getString(sharedPrefUserId);

  }

  static Future<void> saveCurrentLocationSharedPref({String currentCity, String currentState}) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(sharedPrefCurrentCity, currentCity);
      await prefs.setString(sharedPrefCurrentState, currentState);
  }

   static Future<String> getCurrentCitySharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.get(sharedPrefCurrentCity);
  }

  static Future<String> getCurrentStateSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.get(sharedPrefCurrentState);
  }


  static Future setOnBoardingSeenToSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(sharedPrefOnBoardingScreenSeen, true);
  }

  static Future<bool> getOnBoardingScreenSeenSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(sharedPrefOnBoardingScreenSeen);
  }




  static Future<bool> getUserLoggedInSharePref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return  prefs.getBool(sharedPrefLoggedInUserKey);
  }

  Future signInUserWithEmailAndPassword(String email, String password) async{
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      FirebaseUser user  = result.user;
      return user.uid;
    }
    catch(e) {
      print(e.toString());
      return null;
    }
  }

  static setBusinessAccount(bool value) async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
     prefs.setBool(sharedPrefAccountTypeBusiness, value);
  }

  static Future<bool> getBusinessAccount() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
   return  prefs.getBool(sharedPrefAccountTypeBusiness);
  }


}




