import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:koruko_app/core/path/string.router.dart';
import 'package:loader_overlay/loader_overlay.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Stream to listen to authentication changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Get current user
  User? get currentUser => _firebaseAuth.currentUser;

  // Sign up with email and password
  Future<User?> signUp({
    required String email,
    required String password,
    required BuildContext context,
    required String role,
    required String? hospitalId,
  }) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'email': user.email,
          'role': role.toString(),
          'hospitalId': hospitalId.toString() ?? '',
        });
      }
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      context.loaderOverlay.hide();
      // Handle specific Firebase exceptions here
      late String message;
      if (e.message == 'The email address is badly formatted.') {
        message = 'Sai đinh dạng email.';
      } else if (password.length < 6) {
        message = 'Mật khẩu phải có ít nhất 6 ký tự';
      } else if (e.message ==
          'The email address is already in use by another account.') {
        message = 'Địa chỉ email đã được sử dụng bởi một tài khoản khác.';
      }

      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text(
            'Lỗi đăng ký',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
          ),
          content: Text(
            message,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    }
  }

  // Sign in with email and password
  Future<User?> signIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists == true) {
          String role = userDoc.get('role');
          print('object $role');
          if (role == 'admin') {
            context.push(RouterPath.admin);
          } else if (role == 'cashier') {
            context.push(RouterPath.cashier);
          } else if (role == 'user') {
            context.push(RouterPath.home);
          }
        } else {
          context.push(RouterPath.home);
        }
      }
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase exceptions here
      // ignore: use_build_context_synchronously
      context.loaderOverlay.hide();
      late String message;
      if (e.message == 'The email address is badly formatted.') {
        message = 'Địa chỉ email bị định dạng sai.';
      } else {
        message = 'Sai email hoặc mật khẩu.';
      }
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text(
            'Lỗi đăng nhập',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
          ),
          content: Text(
            message,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
