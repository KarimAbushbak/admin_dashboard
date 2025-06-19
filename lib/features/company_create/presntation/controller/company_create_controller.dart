import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CompanyCreateController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController companyPaymentLinkController = TextEditingController();

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    ensureCompanyCounterExists(); // Ensure the counter doc exists
  }

  Future<void> ensureCompanyCounterExists() async {
    final counterRef = FirebaseFirestore.instance.collection('metadata').doc('company_counter');
    final snapshot = await counterRef.get();

    if (!snapshot.exists) {
      await counterRef.set({'lastId': 0});
      print("✅ company_counter initialized");
    }
  }

  Future<void> createCompany() async {
    if (_hasEmptyFields()) {
      Get.snackbar("⚠️ تنبيه", "جميع الحقول مطلوبة", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;

    try {
      // Ensure counter doc exists
      await ensureCompanyCounterExists();

      // 🔁 Auto-increment companyId using Firestore transaction
      final counterRef = FirebaseFirestore.instance.collection('metadata').doc('company_counter');
      int newCompanyId = await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(counterRef);
        int lastId = snapshot.data()?['lastId'] ?? 0;
        int nextId = lastId + 1;
        transaction.update(counterRef, {'lastId': nextId});
        return nextId;
      });

      // 🔑 Create a new doc reference to get the generated Firestore ID
      final docRef = FirebaseFirestore.instance.collection('companies').doc();

      // ✅ Save the company data including the document ID as 'id' field
      await docRef.set({
        'id': docRef.id, // ✅ Manual insertion of Firestore document ID
        'companyId': newCompanyId,
        'username': usernameController.text.trim(),
        'companyName': companyNameController.text.trim(),
        'phone': phoneController.text.trim(),
        'address': addressController.text.trim(),
        'password': passwordController.text.trim(),
        'companyPaymentLink': companyPaymentLinkController.text.trim(),
        'createdAt': Timestamp.now(),
      });

      Get.snackbar("✅ تم", "تم إنشاء الشركة برقم: $newCompanyId", snackPosition: SnackPosition.BOTTOM);
      _clearFields();
    } catch (e) {
      Get.snackbar("خطأ", e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  bool _hasEmptyFields() {
    return usernameController.text.isEmpty ||
        companyNameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        addressController.text.isEmpty ||
        passwordController.text.isEmpty ||
        companyPaymentLinkController.text.isEmpty;
  }

  void _clearFields() {
    usernameController.clear();
    companyNameController.clear();
    phoneController.clear();
    addressController.clear();
    passwordController.clear();
    companyPaymentLinkController.clear();
  }
}
