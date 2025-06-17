import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class CompanyTripsController extends GetxController {
  final String companyId;
  CompanyTripsController(this.companyId);
  RxList tripList = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTrips();
  }

  Future<void> fetchTrips() async {
    try {
      final QuerySnapshot tripsSnapshot = await FirebaseFirestore.instance
          .collection('trips')
          .where('companyId', isEqualTo: companyId)
          .get();

      tripList.value = tripsSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'seats': data['seats'] ?? 0,
          'date': data['date'] ?? '',
          'price': data['price'] ?? 0,
          'timeArrive': data['timeArrive'] ?? '',
          'timeLeave': data['timeLeave'] ?? '',
          'from': data['from'] ?? '',
          'to': data['to'] ?? '',
          'companyId': data['companyId'] ?? '',
        };
      }).toList();
      update();
    } catch (e) {
      print('Error fetching trips: $e');
    }
  }
}