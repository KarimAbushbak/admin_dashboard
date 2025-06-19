import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/booking_model.dart';

class CompanyBookingsController extends GetxController {
  var bookings = <Booking>[].obs;

  Future<void> fetchCompanyBookings(String companyId, {String? tripId}) async {
    try {
      // First get the trip IDs for this company
      List<String> tripIds = [];
      if (tripId != null) {
        tripIds = [tripId];
      } else {
        final tripsSnapshot = await FirebaseFirestore.instance
            .collection('trips')
            .where('companyId', isEqualTo: companyId)
            .get();
        
        tripIds = tripsSnapshot.docs.map((doc) => doc.id).toList();
      }

      if (tripIds.isEmpty) {
        bookings.value = [];
        return;
      }

      // Get all bookings for these trips
      final bookingsSnapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .where('tripId', whereIn: tripIds)
          .get();

      bookings.value = bookingsSnapshot.docs.map((doc) {
        return Booking.fromMap(doc.id, doc.data());
      }).toList();

      print('Fetched ${bookings.length} bookings'); // Debug print
    } catch (e) {
      print('Error fetching company bookings: $e'); // Debug print
      Get.snackbar('خطأ', 'حدث خطأ أثناء جلب الحجوزات');
      bookings.value = [];
    }
  }

  Future<void> confirmBooking(String bookingId) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .update({
        'status': 'confirmed',
      });
      updateBookingStatusLocally(bookingId, 'confirmed');
      Get.snackbar("تم", "تم تأكيد الحجز بنجاح");
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء تأكيد الحجز");
    }
  }

  Future<void> cancelBooking(String bookingId, String reason) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .update({
        'status': 'cancelled',
        'cancellationReason': reason
      });
      updateBookingStatusLocally(bookingId, 'cancelled');
      Get.snackbar("تم", "تم إلغاء الحجز بنجاح");
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء إلغاء الحجز");
    }
  }

  Future<void> rescheduleBooking(String bookingId, String newDate, String newTime) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .update({
        'status': 'rescheduled',
        'newDate': newDate,
        'newTime': newTime
      });
      updateBookingStatusLocally(bookingId, 'rescheduled');
      Get.snackbar("تم", "تم تأجيل الحجز بنجاح");
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء تأجيل الحجز");
    }
  }

  void updateBookingStatusLocally(String bookingId, String status) {
    final index = bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      final booking = bookings[index];
      bookings[index] = Booking(
        id: booking.id,
        tripId: booking.tripId,
        companyId: booking.companyId,
        userName: booking.userName,
        userPhone: booking.userPhone,
        seats: booking.seats,
        status: status,
        gender: booking.gender
      );
      bookings.refresh();
    }
  }
}
