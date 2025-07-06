import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routes.dart';

class AdminLoginController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  var isLoading = false.obs;

  Future<void> loginAdmin() async {
    isLoading.value = true;
    try {
      final email = usernameController.text.trim();
      final password = passwordController.text.trim();

      // Sign in with Firebase Auth
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('DEBUG: Firebase UID: \\${credential.user!.uid}');

      // Check Firestore for user role
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .get();

      print('DEBUG: Firestore userDoc data: \\${userDoc.data()}');

      if (userDoc.exists && userDoc.data()?['role'] == 'admin') {
        Get.offAllNamed(Routes.homeView);
      } else {
        Get.snackbar('Unauthorized', 'You are not an admin.');
        await FirebaseAuth.instance.signOut();
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Login Failed', e.message ?? 'Unknown error');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
} 