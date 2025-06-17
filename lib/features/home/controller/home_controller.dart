import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  int tripCount = 0;
  int companyCount = 0;
  int bookingCount = 0;
  int userCount = 0;

  Future<void> fetchCounts() async {
    final trips = await FirebaseFirestore.instance.collection('trips').get();
    final companies = await FirebaseFirestore.instance
        .collection('companies')
        .get();
    final bookings = await FirebaseFirestore.instance
        .collection('bookings')
        .get();
    final users = await FirebaseFirestore.instance
        .collection('users')
        .get();

    tripCount = trips.size;
    companyCount = companies.size;
    bookingCount = bookings.size;
    userCount = users.size;

    update();
  }

  @override
  void onInit() {
    super.onInit();
    fetchCounts();
  }
}