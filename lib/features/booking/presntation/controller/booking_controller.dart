import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllBookingsController extends GetxController {
  var bookings = [].obs;

  Future<void> fetchAllBookings() async {
    final snapshot = await FirebaseFirestore.instance.collection('bookings').get();
    bookings.value = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'id': doc.id,
        'userName': data['userName'] ?? '',
        'userPhone': data['userPhone'] ?? '',
        'status': data['status'] ?? '',
        // add other fields as needed
      };
    }).toList();
  }

  Future<void> confirmBooking(String bookingId) async {
    await FirebaseFirestore.instance.collection('bookings').doc(bookingId).update({'status': 'confirmed'});
    updateBookingStatusLocally(bookingId, 'confirmed');
  }

  Future<void> cancelBooking(String bookingId) async {
    await FirebaseFirestore.instance.collection('bookings').doc(bookingId).update({'status': 'cancelled'});
    updateBookingStatusLocally(bookingId, 'cancelled');
  }

  void updateBookingStatusLocally(String bookingId, String status) {
    final index = bookings.indexWhere((b) => b['id'] == bookingId);
    if (index != -1) {
      bookings[index]['status'] = status;
      bookings.refresh();
    }
  }

  // Add your updateBookingStatusLocally, confirmBooking, etc. here if needed
}
