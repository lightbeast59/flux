import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  // Web Client ID from Firebase Console -> Authentication -> Sign-in method -> Google -> Web SDK configuration
  static const String _webClientId = '720718676468-uteu4tmm24vljgts60jdgi53aqkjmch5.apps.googleusercontent.com';

  AuthRepository({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(
          clientId: kIsWeb ? _webClientId : null,
          scopes: <String>[],
        );

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Get current user
  User? get currentUser => _firebaseAuth.currentUser;

  // Sign up with email and password
  Future<UserModel?> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      if (user != null) {
        // Update display name
        await user.updateDisplayName(name);
        await user.reload();

        final userModel = await _saveUserToFirestore(
          _firebaseAuth.currentUser!,
          displayName: name,
        );
        return userModel;
      }

      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }

  // Sign in with email and password
  Future<UserModel?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      if (user != null) {
        final userModel = await _saveUserToFirestore(user);
        return userModel;
      }

      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  // Handle Firebase Auth exceptions with user-friendly messages
  Exception _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return Exception('This email is already registered. Please sign in instead.');
      case 'invalid-email':
        return Exception('Please enter a valid email address.');
      case 'weak-password':
        return Exception('Password is too weak. Please use at least 6 characters.');
      case 'user-not-found':
        return Exception('No account found with this email. Please sign up first.');
      case 'wrong-password':
        return Exception('Incorrect password. Please try again.');
      case 'invalid-credential':
        return Exception('Invalid email or password. Please check your credentials.');
      case 'user-disabled':
        return Exception('This account has been disabled.');
      case 'too-many-requests':
        return Exception('Too many attempts. Please try again later.');
      default:
        return Exception('Authentication failed: ${e.message}');
    }
  }

  // Sign in with Google
  Future<UserModel?> signInWithGoogle() async {
    try {
      UserCredential userCredential;

      if (kIsWeb) {
        // Use Firebase Auth popup directly for web (doesn't require People API)
        final googleProvider = GoogleAuthProvider();
        userCredential = await _firebaseAuth.signInWithPopup(googleProvider);
      } else {
        // Use GoogleSignIn plugin for mobile
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        if (googleUser == null) {
          return null;
        }

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        userCredential = await _firebaseAuth.signInWithCredential(credential);
      }

      final user = userCredential.user;

      if (user != null) {
        final userModel = await _saveUserToFirestore(user);
        return userModel;
      }

      return null;
    } catch (e) {
      throw Exception('Google sign-in failed: $e');
    }
  }

  // Save or update user in Firestore
  Future<UserModel> _saveUserToFirestore(User firebaseUser, {String? displayName}) async {
    final docRef = _firestore.collection('users').doc(firebaseUser.uid);
    final docSnapshot = await docRef.get();

    final now = DateTime.now();

    if (docSnapshot.exists) {
      final existingData = docSnapshot.data()!;
      final userModel = UserModel.fromFirestore(existingData, firebaseUser.uid);
      final updatedUser = userModel.copyWith(lastLoginAt: now);
      await docRef.update({'lastLoginAt': now.millisecondsSinceEpoch});
      return updatedUser;
    } else {
      final userModel = UserModel.fromFirebaseUser(
        firebaseUser,
        createdAt: now,
        lastLoginAt: now,
        overrideDisplayName: displayName,
      );
      await docRef.set(userModel.toFirestore());
      return userModel;
    }
  }

  // Get user data from Firestore
  Future<UserModel?> getUserData(String uid) async {
    try {
      final docSnapshot = await _firestore.collection('users').doc(uid).get();

      if (docSnapshot.exists) {
        return UserModel.fromFirestore(docSnapshot.data()!, uid);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user data: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }
}
