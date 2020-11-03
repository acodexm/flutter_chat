import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat/core/models/enums/auth_status.dart';
import 'package:flutter_chat/core/models/user/user_auth_request.dart';
import 'package:flutter_chat/core/models/user/user_response.dart';
import 'package:flutter_chat/core/services/analytics/analytics_service.dart';
import 'package:flutter_chat/core/services/firebase/users_service.dart';
import 'package:flutter_chat/locator.dart';
import 'package:flutter_chat/utils/logger.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthService {
  AuthStatus get status;

  Future<bool> isUserLoggedIn();

  UserResponse get currentUser;

  Future<bool> signInWithGoogle();

  Future<bool> registerWithEmailAndPassword(String email, String password);

  Future<bool> signInWithEmailAndPassword(String email, String password);

  Future<bool> sendPasswordResetEmail(String email);

  Future<bool> signOut();

  Future<void> tryAutoLogin();
}

class AuthServiceImpl implements AuthService {
  final _analyticsService = locator<AnalyticsService>();
  final _usersService = locator<UserService>();
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  StreamSubscription<User> _userAuthStream;
  StreamSubscription<DocumentSnapshot> _userStream;
  AuthStatus _status = AuthStatus.Uninitialized;
  UserResponse _currentUser;

  AuthServiceImpl() {
    _userAuthStream = _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  @override
  AuthStatus get status => _status;

  @override
  UserResponse get currentUser => _currentUser;

  @override
  Future<bool> signInWithGoogle() async {
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication;
      await _signInWithCredentials(googleAuth.accessToken, googleAuth.idToken);
      _status = AuthStatus.Authenticated;
      _analyticsService.logSignUp('google');
      return true;
    } catch (e) {
      _status = AuthStatus.Unauthenticated;
      Log.e('AuthService: Error Google signIn', e: e);
      return false;
    }
  }

  @override
  Future<bool> registerWithEmailAndPassword(String email, String password) async {
    try {
      _status = AuthStatus.Registering;
      User user = (await _auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;
      await _updateUserData(user);
      _analyticsService.logSignUp('email');
      return true;
    } catch (e) {
      Log.e("Error on the new user registration = ", e: e);
      _status = AuthStatus.Unauthenticated;
      return false;
    }
  }

  @override
  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      _status = AuthStatus.Authenticating;
      User user = (await _auth.signInWithEmailAndPassword(
          email: email, password: password)).user;
      await _updateUserData(user);
      _analyticsService.logLogin('email');
      return true;
    } catch (e) {
      Log.e("Error on the sign in = ", e: e);
      _status = AuthStatus.Unauthenticated;
      return false;
    }
  }

  @override
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      _analyticsService.logResetPassword(userId: _currentUser.uid);
      return true;
    } catch (e) {
      Log.e("Error on the reset password = ", e: e);
      return false;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      _userStream.pause(_resumeUserSignal());
      _userAuthStream.pause(_resumeAuthSignal());
      await _auth.signOut();
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.disconnect();
      }
      _status = AuthStatus.Unauthenticated;
      _currentUser = null;
      return true;
    } catch (e) {
      Log.e("Error on sing out ", e: e);
      return false;
    }
  }

  @override
  Future<void> tryAutoLogin() async {
    var user = _auth.currentUser;
    if (user != null) {
      if (_currentUser == null) {
        await _populateCurrentUser(
            await _usersService.usersRef.doc(user.uid).get());
      }
      _status = AuthStatus.Authenticated;
    } else if (await _googleSignIn.isSignedIn()) {
      GoogleSignInAuthentication googleAuth = await _googleSignIn.currentUser
          .authentication;
      await _signInWithCredentials(googleAuth.accessToken, googleAuth.idToken);
    }
  }

  @override
  Future<bool> isUserLoggedIn() async {
    return _currentUser != null;
  }

  Future _signInWithCredentials(String accessToken, String idToken) async {
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: accessToken,
      idToken: idToken,
    );
    User user = (await _auth.signInWithCredential(credential)).user;
    await _updateUserData(user);
    _analyticsService.logLogin('google');
    Log.d("signInWithCredentials  ${user.toString()}");
  }

  Future<void> _updateUserData(User user) async {
    if (_userAuthStream.isPaused) {
      await _resumeAuthSignal();
      _userAuthStream.resume();
    }
    DocumentReference ref = _usersService.usersRef.doc(user.uid);
    return ref.set(
        UserAuthRequest(
          displayName: user.displayName,
          photoURL: user.photoURL,
          email: user.email,
          exists: (await ref.get()).exists,
        ).toMap(), SetOptions(merge: true));
  }

  Future<void> _onAuthStateChanged(User firebaseUser) async {
    if (firebaseUser == null) {
      if (_userStream != null && !_userStream.isPaused) _userStream.pause(
          _resumeUserSignal());
      _status = AuthStatus.Unauthenticated;
      _currentUser = null;
    } else {
      if (_userStream == null) {
        _userStream =
            _usersService.usersRef.doc(firebaseUser.uid).snapshots().listen(
                _populateCurrentUser);
      }
      if (_userStream.isPaused) {
        await _resumeUserSignal();
        _userStream.resume();
      }
      _status = AuthStatus.Authenticated;
    }
  }

  Future<void> _populateCurrentUser(DocumentSnapshot user) async {
    if (user != null && user.exists && !user.metadata.hasPendingWrites) {
      _currentUser = UserResponse.fromMap(user);
      await _analyticsService.setUserProperties(
        userId: _currentUser.uid,
        userRole: _currentUser.role,
      );
    }
  }

  Future<void> _resumeAuthSignal() async => true;

  Future<void> _resumeUserSignal() async => true;
}
