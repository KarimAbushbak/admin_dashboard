import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TripsController extends GetxController {
  var tripsWithCompany = [].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllTripsWithCompanyData();
  }

  Future<void> fetchAllTripsWithCompanyData() async {
    try {
      isLoading.value = true;
      final tripsSnapshot = await FirebaseFirestore.instance.collection('trips').get();
      List<Map<String, dynamic>> processedTrips = [];

      for (var tripDoc in tripsSnapshot.docs) {
        final tripData = tripDoc.data() as Map<String, dynamic>;
        final companyId = tripData['companyId'] as String?;

        String companyName = 'Unknown Company';
        if (companyId != null) {
          final companyDoc = await FirebaseFirestore.instance.collection('companies').doc(companyId).get();
          if (companyDoc.exists) {
            companyName = (companyDoc.data() as Map<String, dynamic>)['companyName'] ?? 'Unknown Company';
          }
        }

        processedTrips.add({
          ...tripData,
          'id': tripDoc.id,
          'companyName': companyName,
        });
      }
      tripsWithCompany.value = processedTrips;
    } catch (e) {
      print("Error fetching trips with company data: $e");
    } finally {
      isLoading.value = false;
    }
  }

}
