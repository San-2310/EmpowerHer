import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/auth_services.dart';

class EmpowerHerUserProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  EmpowerHerUser? _user;
  User? _firebaseUser;
  bool _isDataLoaded = false;

  EmpowerHerUser? get currentUser => _user;
  bool get isAuthenticated => _firebaseUser != null;
  bool get isDataLoaded => _isDataLoaded;

  EmpowerHerUserProvider() {
    _auth.authStateChanges().listen((user) {
      _firebaseUser = user;
      if (_firebaseUser != null) {
        fetchUserData();
      } else {
        _user = null;
        _isDataLoaded = true;
        notifyListeners();
      }
    });
  }

  Future<void> fetchUserData() async {
    _isDataLoaded = false;
    notifyListeners();

    try {
      if (_firebaseUser != null) {
        DocumentSnapshot userDoc = await _firestore
            .collection(
                'users') // 🔁 or 'empower_her_users' depending on Firestore structure
            .doc(_firebaseUser!.uid)
            .get();

        if (userDoc.exists) {
          _user =
              EmpowerHerUser.fromJson(userDoc.data() as Map<String, dynamic>);
        } else {
          _user = null;
        }
      }
    } catch (e) {
      print("⚠️ Error fetching user data: $e");
      _user = null;
    } finally {
      _isDataLoaded = true;
      notifyListeners();
    }
  }

  Future<void> refreshUser([EmpowerHerUser? updatedUser]) async {
    _isDataLoaded = false;
    notifyListeners();

    try {
      _user = updatedUser ?? await _authService.fetchCurrentUserProfile();
    } catch (e) {
      print("⚠️ Error refreshing user data: $e");
      _user = null;
    } finally {
      _isDataLoaded = true;
      notifyListeners();
    }
  }

  Future<void> refreshFromAuth() async {
    _isDataLoaded = false;
    notifyListeners();

    try {
      _user = await _authService.fetchCurrentUserProfile();
    } catch (e) {
      print("⚠️ Error refreshing from auth: $e");
      _user = null;
    } finally {
      _isDataLoaded = true;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    _firebaseUser = null;
    _isDataLoaded = true;
    notifyListeners();
  }
}
