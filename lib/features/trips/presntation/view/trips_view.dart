import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/routes.dart';
import '../controller/trips_controller.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_font_sizes.dart';
import '../../../../core/resources/manager_font_weight.dart';
import '../../../../core/resources/manager_height.dart';
import '../../../../core/resources/manager_strings.dart';
import '../../../../core/resources/manager_width.dart';

class TripsView extends StatelessWidget {
  const TripsView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth > 600 ? 500.0 : screenWidth * 0.9;
    final horizontalMargin = screenWidth > 600 ? (screenWidth - containerWidth) / 2 : screenWidth * 0.05;
    final TripsController controller = Get.put(TripsController());

    return Scaffold(
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, -1),
            ),
          ],
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(Icons.search, color: Colors.white, size: 30),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(250, 50),
                backgroundColor: ManagerColors.green,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                Get.toNamed(Routes.addTripPage);
              },
              icon: Icon(Icons.add, color: Colors.white),
              label: Text(
                ManagerStrings.addANewTrip,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ManagerFontSizes.s18,
                  fontWeight: ManagerFontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.sync, color: ManagerColors.primaryColor, size: 44),
          onPressed: () {
            controller.fetchAllTripsWithCompanyData();
          },
        ),
        title: Text(
          ManagerStrings.trips,
          style: TextStyle(
            fontSize: 44,
            fontWeight: ManagerFontWeight.bold,
          ),
        ),
        actions: [
          Text(
            'السابق',
            style: TextStyle(
              color: ManagerColors.black,
              fontSize: ManagerFontSizes.s16,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios_sharp, color: ManagerColors.primaryColor, size: 44),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.tripsWithCompany.isEmpty) {
          return const Center(child: Text("No trips available."));
        }
        return ListView.builder(
          itemCount: controller.tripsWithCompany.length,
          itemBuilder: (context, index) {
            final trip = controller.tripsWithCompany[index];
            return Column(
              children: [
                SizedBox(height: ManagerHeight.h50),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
                  width: containerWidth,
                  height: 300,
                  decoration: BoxDecoration(
                    color: ManagerColors.bgColorcompany,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: ManagerColors.bgFrameColorcompany,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: ManagerHeight.h20),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: ManagerColors.bgColorTextTrips,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  // Example: '15 مقعد متاح'
                                  '${trip['seats'] ?? 'N/A'} مقعد متاح',
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: ManagerFontSizes.s20,
                                    fontWeight: ManagerFontWeight.regular,
                                  ),
                                ),
                              ),
                            ),
                            Text(

                              trip['companyName'] ?? '',
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: ManagerFontSizes.s24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: ManagerHeight.h20),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 180,
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: ManagerColors.bgColorTextTrips,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  trip['date']?.toString() ?? '',
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                    fontWeight: ManagerFontWeight.regular,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              ManagerStrings.tripHistory,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: ManagerFontSizes.s24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: ManagerHeight.h10),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'ل.س',
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: ManagerFontSizes.s14,
                                    fontWeight: ManagerFontWeight.regular,
                                  ),
                                ),
                                Text(
                                  trip['price']?.toString() ?? '',
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      trip['timeArrive'] ?? '',
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: ManagerFontSizes.s24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      trip['from']?.toString() ?? '',
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: ManagerFontSizes.s16,
                                        fontWeight: ManagerFontWeight.regular,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: ManagerWidth.w30),
                                Column(
                                  children: [
                                    Text(
                                      trip['timeLeave'] ?? '',
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: ManagerFontSizes.s24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      trip['to']?.toString() ?? '',
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: ManagerFontSizes.s16,
                                        fontWeight: ManagerFontWeight.regular,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: ManagerHeight.h10),
                      Divider(
                        color: Colors.grey[400],
                        thickness: 1,
                        height: 20,
                        indent: 16,
                        endIndent: 16,
                      ),
                      SizedBox(height: ManagerHeight.h10),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                final result = await Get.toNamed('/editTrip', arguments: trip);
                                if (result == true) {
                                  controller.fetchAllTripsWithCompanyData();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ManagerColors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                              ),
                              child: Text(
                                ManagerStrings.editDetails,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ManagerFontSizes.s18,
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: () {
                                Get.toNamed(
                                  Routes.companyBookingView,
                                  arguments: {
                                    'companyId': trip['companyId'],
                                    'tripId': trip['id'],
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                              ),
                              child: Text(
                                ManagerStrings.reservations,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ManagerFontSizes.s18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      }),
    );
  }
}
