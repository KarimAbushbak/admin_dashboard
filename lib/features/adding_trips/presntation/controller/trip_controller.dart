import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/storage/local/database/shared_preferences/app_settings_shared_preferences.dart';

class TripController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final formKey = GlobalKey<FormState>();
  final fromController = TextEditingController();
  final toController = TextEditingController();
  final dateController = TextEditingController();
  final timeLeaveController = TextEditingController();
  final timeArriveController = TextEditingController();
  final seatsController = TextEditingController();
  final priceController = TextEditingController();
  final notesController = TextEditingController();
  final isLoading = false.obs;
  RxString? selectedCompanyId;
  RxList<Map<String, dynamic>> companies = <Map<String, dynamic>>[].obs;

  AppSettingsSharedPreferences appSettingsSharedPreferences = AppSettingsSharedPreferences();
  RxInt seatCount = 0.obs;
  var isMale = true.obs;
  var pageSelectedIndex = 2.obs;
  var currentPageIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCompanies();
    seatsController.text = seatCount.value.toString();
  }

  Future<void> fetchCompanies() async {
    try {
      final snapshot = await _firestore.collection('companies').get();
      if (snapshot.docs.isNotEmpty) {
        companies.value = snapshot.docs
            .map((doc) => {'id': doc.id, 'name': doc['companyName'] ?? 'Unnamed Company'})
            .toList();
        if (companies.isNotEmpty) {
          selectedCompanyId = RxString(companies.first['id']);
        }
      }
    } catch (e) {
      Get.snackbar(
        '❌ Error',
        'Failed to fetch companies: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
      );
      print("Error fetching companies: $e");
    }
    update();
  }

  void setSelectedCompanyId(String? companyId) {
    if (companyId != null) {
      selectedCompanyId = companyId.obs;
      update();
    }
  }

  void incrementSeats() {
    seatCount++;
    seatsController.text = seatCount.value.toString();
    update();
  }

  void decrementSeats() {
    if (seatCount > 0) seatCount--;
    seatsController.text = seatCount.value.toString();
    update();
  }

  void changeMale(int index) {
    isMale.value = index == 0;
  }

  void onPageChanged(int index) {
    currentPageIndex.value = index;
  }

  @override
  void onClose() {
    fromController.dispose();
    toController.dispose();
    dateController.dispose();
    timeLeaveController.dispose();
    timeArriveController.dispose();
    seatsController.dispose();
    priceController.dispose();
    notesController.dispose();
    super.onClose();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      locale: const Locale('ar', ''),
    );
    if (picked != null) {
      dateController.text = '${picked.day}-${picked.month}-${picked.year}';
      update();
    }
  }

  bool validateFields() {
    if (selectedCompanyId == null || selectedCompanyId!.value.isEmpty) {
      Get.snackbar(
        '⚠️ Warning',
        'Please select a company',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
      );
      return false;
    }

    if (fromController.text.isEmpty || toController.text.isEmpty) {
      Get.snackbar(
        '⚠️ Warning',
        'Please select both cities',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
      );
      return false;
    }

    if (dateController.text.isEmpty) {
      Get.snackbar(
        '⚠️ Warning',
        'Please select a date',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
      );
      return false;
    }

    if (timeLeaveController.text.isEmpty || timeArriveController.text.isEmpty) {
      Get.snackbar(
        '⚠️ Warning',
        'Please enter both departure and arrival times',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
      );
      return false;
    }

    if (seatCount.value <= 0) {
      Get.snackbar(
        '⚠️ Warning',
        'Please add at least one seat',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
      );
      return false;
    }

    if (priceController.text.isEmpty || double.tryParse(priceController.text) == null) {
      Get.snackbar(
        '⚠️ Warning',
        'Please enter a valid price',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
      );
      return false;
    }

    return true;
  }

  Future<void> addTrip() async {
    if (!validateFields()) return;

    isLoading.value = true;

    try {
      final docRef = _firestore.collection('trips').doc();
      await docRef.set({
        'id': docRef.id,
        'companyId': selectedCompanyId!.value,
        'from': fromController.text.trim(),
        'to': toController.text.trim(),
        'date': dateController.text.trim(),
        'timeLeave': timeLeaveController.text.trim(),
        'timeArrive': timeArriveController.text.trim(),
        'seats': seatCount.value,
        'price': double.tryParse(priceController.text.trim()) ?? 0.0,
        'notes': notesController.text.trim(),
        'createdAt': Timestamp.now(),
      });

      Get.snackbar(
        '✅ Success',
        'Trip added successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
      );

      // Reset form
      formKey.currentState?.reset();
      seatCount.value = 0;
      seatsController.text = "0";
      fromController.clear();
      toController.clear();
      dateController.clear();
      timeLeaveController.clear();
      timeArriveController.clear();
      priceController.clear();
      notesController.clear();
      update();
      Get.back();
    } catch (e) {
      Get.snackbar(
        '❌ Error',
        'Failed to add trip: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
