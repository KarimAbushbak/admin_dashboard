import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class RescheduleBookingPage extends StatefulWidget {
  final String bookingId;

  const RescheduleBookingPage({super.key, required this.bookingId});

  @override
  State<RescheduleBookingPage> createState() => _RescheduleBookingPageState();
}

class _RescheduleBookingPageState extends State<RescheduleBookingPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("تأجيل الرحلة")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );
                setState(() => selectedDate = date);
              },
              child: const Text("اختر التاريخ الجديد"),
            ),
            ElevatedButton(
              onPressed: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                setState(() => selectedTime = time);
              },
              child: const Text("اختر الوقت الجديد"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (selectedDate != null && selectedTime != null) {
                  await FirebaseFirestore.instance
                      .collection('bookings')
                      .doc(widget.bookingId)
                      .update({
                    'status': 'rescheduled',
                    'newDate': "${selectedDate!.toIso8601String().split('T').first}",
                    'newTime': "${selectedTime!.hour}:${selectedTime!.minute.toString().padLeft(2, '0')}",
                  });

                  Get.back(result: true);
                  Get.snackbar("تم", "تم تأجيل الرحلة");
                }
              },
              child: const Text("تأكيد التأجيل"),
            ),
          ],
        ),
      ),
    );
  }
}
