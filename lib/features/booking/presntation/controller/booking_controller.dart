import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllBookingsController extends GetxController {
  var bookings = [].obs;
  var isLoading = false.obs;

  Future<void> fetchAllBookings() async {
    isLoading.value = true;
    try {
      final snapshot = await FirebaseFirestore.instance.collection('bookings').get();
      List<Map<String, dynamic>> bookingsWithTrips = [];
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        String tripNumber = 'N/A';
        // Fetch trip information if tripId exists
        if (data['tripId'] != null && data['tripId'].toString().isNotEmpty) {
          try {
            final tripDoc = await FirebaseFirestore.instance
                .collection('trips')
                .doc(data['tripId'])
                .get();
            if (tripDoc.exists) {
              final tripData = tripDoc.data() as Map<String, dynamic>;
              tripNumber = tripData['tripNumber'] ?? 'N/A';
            }
          } catch (e) {
            print('Error fetching trip info: $e');
          }
        }
        bookingsWithTrips.add({
          'id': doc.id,
          'userName': data['userName'] ?? '',
          'userPhone': data['userPhone'] ?? '',
          'gender': data['gender'] ?? '',
          'status': data['status'] ?? 'pending',
          'tripId': data['tripId'] ?? '',
          'tripNumber': tripNumber,
        });
      }
      bookings.value = bookingsWithTrips;
    } catch (e) {
      print('Error fetching bookings: $e');
      Get.snackbar('خطأ', 'حدث خطأ أثناء جلب الحجوزات');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> confirmBooking(String bookingId) async {
    try {
    await FirebaseFirestore.instance.collection('bookings').doc(bookingId).update({'status': 'confirmed'});
    updateBookingStatusLocally(bookingId, 'confirmed');
      Get.snackbar('تم', 'تم تأكيد الحجز بنجاح');
    } catch (e) {
      print('Error confirming booking: $e');
      Get.snackbar('خطأ', 'حدث خطأ أثناء تأكيد الحجز');
    }
  }

  Future<void> cancelBooking(String bookingId) async {
    try {
    await FirebaseFirestore.instance.collection('bookings').doc(bookingId).update({'status': 'cancelled'});
    updateBookingStatusLocally(bookingId, 'cancelled');
      Get.snackbar('تم', 'تم إلغاء الحجز بنجاح');
    } catch (e) {
      print('Error cancelling booking: $e');
      Get.snackbar('خطأ', 'حدث خطأ أثناء إلغاء الحجز');
    }
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
