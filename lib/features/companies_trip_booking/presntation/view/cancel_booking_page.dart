import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class CancelBookingPage extends StatelessWidget {
  final String bookingId;
  final TextEditingController reasonController = TextEditingController();

  CancelBookingPage({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("سبب الإلغاء")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(labelText: "سبب الإلغاء"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('bookings')
                    .doc(bookingId)
                    .update({
                  'status': 'cancelled',
                  'cancellationReason': reasonController.text,
                });

                Get.back(result: true);
                Get.snackbar("تم", "تم إلغاء الحجز");
              },
              child: const Text("إرسال"),
            ),
          ],
        ),
      ),
    );
  }
}
