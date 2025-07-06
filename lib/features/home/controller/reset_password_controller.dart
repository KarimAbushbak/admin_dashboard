import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPasswordController extends GetxController {
  final newPasswordController = TextEditingController();
  final reEnterPasswordController = TextEditingController();
  var isLoading = false.obs;

  Future<void> resetPassword(BuildContext context) async {
    final newPassword = newPasswordController.text.trim();
    final rePassword = reEnterPasswordController.text.trim();

    if (newPassword.isEmpty || rePassword.isEmpty) {
      showSnackBar(context, 'يرجى إدخال كلمة المرور الجديدة مرتين');
      return;
    }
    if (newPassword != rePassword) {
      showSnackBar(context, 'كلمتا المرور غير متطابقتين');
      return;
    }
    isLoading.value = true;
    try {
      await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
      showSnackBar(context, 'تم تغيير كلمة المرور بنجاح', success: true);
      Get.back();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message ?? 'حدث خطأ أثناء تغيير كلمة المرور');
    } catch (e) {
      showSnackBar(context, 'حدث خطأ غير متوقع');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendResetEmail(BuildContext context, String email) async {
    if (email.isEmpty) {
      showSnackBar(context, 'يرجى إدخال البريد الإلكتروني');
      return;
    }
    isLoading.value = true;
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showSnackBar(context, 'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني', success: true);
      Get.back();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message ?? 'حدث خطأ أثناء إرسال البريد الإلكتروني');
    } catch (e) {
      showSnackBar(context, 'حدث خطأ غير متوقع');
    } finally {
      isLoading.value = false;
    }
  }

  void showSnackBar(BuildContext context, String message, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, textDirection: TextDirection.rtl),
        backgroundColor: success ? Colors.green : Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
} 