/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  bool _isLoading;
  bool get isLoading => _isLoading;

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  Future<Map<String, dynamic>> signInWithSocialMedia(String social) async {
    final Map<String, dynamic> result = {'success': false, 'error': null};
    User user;
    _isLoading = true;
    notifyListeners();
    try {
      UserCredential userCredential;
      if (social == "Fb") {
        userCredential = await facebookConfigurations();
      } else {
        userCredential = await googleConfigurations();
      }
      user = userCredential.user;
      if (user != null) {
        bool exist = await checkUserExistence(user.uid);
        if (!exist) {
          assert(user.providerData[0].email != null);
          assert(user.providerData[0].displayName != null);
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'name': user.providerData[0].displayName,
            'email': user.providerData[0].email
          }).then((value) {
            storeAuthUser(user.uid, true);
            result['success'] = true;
          }).catchError((error) {
            result['sucess'] = error;
          });
        } else {
          storeAuthUser(user.uid, true);
          result['success'] = true;
        }
      } else {
        result['error'] = user;
      }
    } catch (error) {
      result['error'] = error;
    }
    _isLoading = false;
    notifyListeners();
    return result;
  }

  Future<UserCredential> facebookConfigurations() async {
    UserCredential userCredential;
    final FacebookLogin facebookLogin = FacebookLogin();
    FacebookLoginResult result =
        await facebookLogin.logIn(['email', 'public_profile']);
    if (result.status == FacebookLoginStatus.loggedIn) {
      FacebookAccessToken myToken = result.accessToken;
      FacebookAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(myToken.token);
      userCredential = await _auth.signInWithCredential(facebookAuthCredential);
    }
    return userCredential;
  }

  Future<UserCredential> googleConfigurations() async {
    UserCredential userCredential;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    GoogleAuthCredential googleAuthCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    userCredential = await _auth.signInWithCredential(googleAuthCredential);
    return userCredential;
  }

  Future<bool> checkUserExistence(String uId) async {
    bool exist = false;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((value) {
      if (value.exists) {
        exist = true;
      }
    });
    return exist;
  }

  Future<void> autoAuthenticated() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    bool isAuthenticated;
    preferences.getBool('userExistence') != null
        ? isAuthenticated = preferences.getBool('userExistence')
        : isAuthenticated = false;
    if (isAuthenticated) {
      String uId = preferences.getString('userId');
      final userData = await fetchUserData(uId);
      if (userData['success']) {
        _isAuthenticated = true;
      } else {
        _isAuthenticated = false;
      }
    } else {
      return;
    }
  }

  void storeAuthUser(String uId, [isAuth = false]) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    if (isAuth) {
      preferences.setBool('userExistence', true);
      preferences.setString('userId', uId);
    } else {
      preferences.remove('userId');
      preferences.remove('userExistence');
    }
  }
}
*/
