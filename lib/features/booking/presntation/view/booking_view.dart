import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_font_sizes.dart';
import '../../../../core/resources/manager_font_weight.dart';
import '../../../../core/resources/manager_height.dart';
import '../../../../core/resources/manager_strings.dart';
import '../controller/booking_controller.dart';

class BookingView extends StatelessWidget {
  BookingView({super.key}) {
    final controller = Get.put(AllBookingsController());
    controller.fetchAllBookings();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final controller = Get.find<AllBookingsController>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'كل الحجوزات',
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

  Widget _buildBookingCardContent(Map<String, dynamic> booking, AllBookingsController controller) {
    final status = booking['status'] ?? 'pending';
    final userName = booking['userName'] ?? '';
    final userPhone = booking['userPhone'] ?? '';
    final gender = booking['gender'] ?? '';

    return Column(
      children: [
        SizedBox(height: ManagerHeight.h20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              booking['tripNumber'] ?? 'N/A',
              textDirection: TextDirection.rtl,
              style: TextStyle(
                color: Colors.black,
                fontSize: ManagerFontSizes.s24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              userName,
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
                  gender,
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
                  userPhone,
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
        if (status == 'pending')
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () => controller.cancelBooking(booking['id']),
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
              SizedBox(
                width: 250,
                child: ElevatedButton(
                  onPressed: () => controller.confirmBooking(booking['id']),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 20),
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
              ),
            ],
          )
        else
          SizedBox(
             width: 450,
            child: ElevatedButton(
              onPressed: null, // Disabled button
              style: ElevatedButton.styleFrom(
                backgroundColor: status == 'confirmed' ? Colors.green :
                    status == 'cancelled' ? Colors.red :
                    Colors.amber, // Assuming 'rescheduled' maps to amber
                disabledBackgroundColor: status == 'confirmed' ? Colors.green :
                    status == 'cancelled' ? Colors.red :
                    Colors.amber,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 20),
              ),
              child: Text(
                status == 'confirmed' ? 'تم التأكيد' :
                status == 'cancelled' ? 'تم الإلغاء' :
                'تم التأجيل', // Assuming 'rescheduled' maps to this text
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
