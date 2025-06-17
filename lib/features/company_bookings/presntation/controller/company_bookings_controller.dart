import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CompanyBookingsController extends GetxController {
  var bookings = [].obs;
  var companyName = ''.obs;
  String? companyId;
  String? tripId;

  @override
  void onInit() {
    super.onInit();
    // Get arguments safely
    final args = Get.arguments;
    if (args != null) {
      companyId = args['companyId'] as String?;
      tripId = args['tripId'] as String?;
    }
    fetchCompanyBookings();
  }

  Future<void> fetchCompanyBookings() async {
    try {
      if (companyId == null && tripId == null) {
        bookings.value = [];
        return;
      }

      // First get the company name if we have companyId
      if (companyId != null) {
        final companyDoc = await FirebaseFirestore.instance
            .collection('companies')
            .doc(companyId)
            .get();
        
        if (companyDoc.exists) {
          companyName.value = companyDoc.data()?['companyName'] ?? '';
        }
      }

      // Get the trip IDs for this company
      List<String> tripIds = [];
      if (tripId != null) {
        tripIds = [tripId!];
      } else if (companyId != null) {
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

      // Get trip details for each booking
      List<Map<String, dynamic>> processedBookings = [];
      for (var doc in bookingsSnapshot.docs) {
        final bookingData = doc.data();
        final tripId = bookingData['tripId'];
        
        // Get trip details
        final tripDoc = await FirebaseFirestore.instance
            .collection('trips')
            .doc(tripId)
            .get();
        
        if (tripDoc.exists) {
          final tripData = tripDoc.data()!;
          processedBookings.add({
            'id': doc.id,
            'userName': bookingData['userName'] ?? '',
            'userPhone': bookingData['userPhone'] ?? '',
            'gender': bookingData['gender'] ?? '',
            'status': bookingData['status'] ?? 'pending',
            'tripId': tripId,
            'from': tripData['from'] ?? '',
            'to': tripData['to'] ?? '',
            'date': tripData['date'] ?? '',
            'timeLeave': tripData['timeLeave'] ?? '',
            'timeArrive': tripData['timeArrive'] ?? '',
            'price': tripData['price'] ?? 0,
          });
        }
      }

      bookings.value = processedBookings;
    } catch (e) {
      print('Error fetching company bookings: $e');
      Get.snackbar('خطأ', 'حدث خطأ أثناء جلب الحجوزات');
    }
  }

  Future<void> confirmBooking(String bookingId) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .update({'status': 'confirmed'});
      
      // Update local state
      final index = bookings.indexWhere((b) => b['id'] == bookingId);
      if (index != -1) {
        bookings[index]['status'] = 'confirmed';
        bookings.refresh();
      }
      
      Get.snackbar('تم', 'تم تأكيد الحجز بنجاح');
    } catch (e) {
      print('Error confirming booking: $e');
      Get.snackbar('خطأ', 'حدث خطأ أثناء تأكيد الحجز');
    }
  }

  Future<void> cancelBooking(String bookingId) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .update({'status': 'cancelled'});
      
      // Update local state
      final index = bookings.indexWhere((b) => b['id'] == bookingId);
      if (index != -1) {
        bookings[index]['status'] = 'cancelled';
        bookings.refresh();
      }
      
      Get.snackbar('تم', 'تم إلغاء الحجز بنجاح');
    } catch (e) {
      print('Error cancelling booking: $e');
      Get.snackbar('خطأ', 'حدث خطأ أثناء إلغاء الحجز');
    }
  }
} 