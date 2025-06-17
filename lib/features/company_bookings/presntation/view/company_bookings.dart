import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_font_sizes.dart';
import '../../../../core/resources/manager_font_weight.dart';
import '../../../../core/resources/manager_height.dart';
import '../../../../core/resources/manager_strings.dart';
import '../../../companies_trip_booking/presntation/controller/booking_controller.dart';
import '../../../companies_trip_booking/presntation/model/booking_model.dart';
import '../../../companies_trip_booking/presntation/view/cancel_booking_page.dart';
import '../../../companies_trip_booking/presntation/view/reschadule_booking_page.dart';

class CompanyBookings extends StatelessWidget {
  final String? companyId;
  final String? tripId;

  const CompanyBookings({Key? key, this.companyId, this.tripId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (companyId == null && tripId == null) {
      return const Scaffold(
        body: Center(child: Text("No company or trip ID provided")),
      );
    }

    final controller = Get.put(CompanyBookingsController());
    controller.fetchCompanyBookings(companyId ?? '', tripId: tripId);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'حجوزات الشركة',
          style: TextStyle(
            fontSize: 44,
            fontWeight: ManagerFontWeight.bold,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.bookings.isEmpty) {
          return const Center(child: Text("لا توجد حجوزات حالياً"));
        }

        return ListView.builder(
          itemCount: controller.bookings.length,
          itemBuilder: (context, index) {
            final booking = controller.bookings[index];
            double containerWidth = screenWidth > 600 ? 500 : screenWidth * 0.9;
            double horizontalMargin = screenWidth > 600 ? (screenWidth - containerWidth) / 2 : screenWidth * 0.05;
            
            return Column(
              children: [
                if (index == 0) SizedBox(height: ManagerHeight.h50),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
                  width: containerWidth,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: ManagerColors.bgColorcompany,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: ManagerColors.bgFrameColorcompany,
                      width: 1,
                    ),
                  ),
                  child: _buildBookingCardContent(booking, controller),
                ),
                SizedBox(height: ManagerHeight.h10),
              ],
            );
          },
        );
      }),
    );
  }

  Widget _buildBookingCardContent(Booking booking, CompanyBookingsController controller) {
    return Column(
      children: [
        SizedBox(height: ManagerHeight.h20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              booking.tripId,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                color: Colors.black,
                fontSize: ManagerFontSizes.s24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              booking.userName,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                color: Colors.black,
                fontSize: ManagerFontSizes.s24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: ManagerHeight.h20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'ذكر',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: ManagerFontSizes.s18,
                    fontWeight: ManagerFontWeight.regular,
                  ),
                ),
                Text(
                  ManagerStrings.gender,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: ManagerFontSizes.s18,
                    fontWeight: ManagerFontWeight.regular,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  booking.userPhone,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: ManagerFontSizes.s18,
                    fontWeight: ManagerFontWeight.regular,
                  ),
                ),
                Text(
                  ManagerStrings.phoneBookATrip,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: ManagerFontSizes.s18,
                    fontWeight: ManagerFontWeight.regular,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: ManagerHeight.h20),
        if (booking.status == 'pending')
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final result = await Get.to(() => CancelBookingPage(bookingId: booking.id));
                  if (result == true) {
                    controller.updateBookingStatusLocally(booking.id, 'cancelled');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                ),
                child: Text(
                  'إلغاء',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ManagerFontSizes.s18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final result = await Get.to(() => RescheduleBookingPage(bookingId: booking.id));
                  if (result == true) {
                    controller.updateBookingStatusLocally(booking.id, 'rescheduled');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                ),
                child: Text(
                  'تأجيل',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ManagerFontSizes.s18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => controller.confirmBooking(booking.id),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                ),
                child: Text(
                  'تأكيد',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ManagerFontSizes.s18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          )
        else
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: booking.status == 'confirmed' ? Colors.green :
                               booking.status == 'cancelled' ? Colors.red :
                               Colors.yellow[700],
                disabledBackgroundColor: booking.status == 'confirmed' ? Colors.green :
                                       booking.status == 'cancelled' ? Colors.red :
                                       Colors.yellow[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
              child: Text(
                booking.status == 'confirmed' ? 'تم التأكيد' :
                booking.status == 'cancelled' ? 'تم الإلغاء' :
                'تم التأجيل',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ManagerFontSizes.s18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
