import 'package:admin_dashboard/features/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_assets.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_font_sizes.dart';
import '../../../../core/resources/manager_font_weight.dart';
import '../../../../core/resources/manager_height.dart';
import '../../../../core/resources/manager_strings.dart';
import '../../../../core/resources/manager_width.dart';
import '../../../../core/routes.dart';
import '../../../companies/presntation/controller/company_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Icon(
              Icons.logout,
              color: ManagerColors.red,
              size: 40,
            ),
          ),
          actions: [
            Text(
              ManagerStrings.appName,
              style: TextStyle(
                fontSize: 44,
                fontWeight: ManagerFontWeight.bold,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ManagerAssets.auth1),
                ),
              ),
            ),
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;
            double cardWidth = screenWidth > 600 ? 500 : screenWidth * 0.9;
            double cardMargin = screenWidth > 600 ? (screenWidth - cardWidth) / 2 : screenWidth * 0.05;
            double miniCardWidth = screenWidth > 800 ? (cardWidth - 20) / 2 : cardWidth;

            return Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: cardWidth + cardMargin * 2,
                  ),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: cardMargin),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: ManagerHeight.h20), // reduced top padding
                        GestureDetector(
                          onTap:(){
                            Get.toNamed(Routes.bookingView);
                          },
                          child: Container(
                            width: cardWidth,
                            height: 140,
                            decoration: BoxDecoration(
                              color: ManagerColors.primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  controller.bookingCount.toString(),
                                  style: TextStyle(
                                    fontWeight: ManagerFontWeight.bold,
                                    fontSize: ManagerFontSizes.s50,
                                    color: ManagerColors.white,
                                  ),
                                ),
                                SizedBox(width: screenWidth > 600 ? 160 : 30),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.event_available,
                                        color: ManagerColors.white, size: 80),
                                    Text(
                                      ManagerStrings.reservations,
                                      style: TextStyle(
                                        fontWeight: ManagerFontWeight.regular,
                                        fontSize: ManagerFontSizes.s20,
                                        color: ManagerColors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: ManagerHeight.h30),

                        // الكرت الثاني
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.usersView);
                          },
                          child: Container(
                            width: cardWidth,
                            height: 140,
                            decoration: BoxDecoration(
                              color: ManagerColors.green,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  controller.userCount.toString(),
                                  style: TextStyle(
                                    fontWeight: ManagerFontWeight.bold,
                                    fontSize: ManagerFontSizes.s50,
                                    color: ManagerColors.white,
                                  ),
                                ),
                                SizedBox(width: screenWidth > 600 ? 160 : 30),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.person,
                                        color: ManagerColors.white, size: 80),
                                    Text(
                                      ManagerStrings.users,
                                      style: TextStyle(
                                        fontWeight: ManagerFontWeight.regular,
                                        fontSize: ManagerFontSizes.s20,
                                        color: ManagerColors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: ManagerHeight.h30),

                        // كروت الصف السفلي: responsive Row / Column
                        screenWidth > 800
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: (){
                                        Get.toNamed(Routes.tripsView);
                                      },
                                      child: buildMiniCard(
                                        buttonText: "اضافة رحلة",
                                        width: miniCardWidth,
                                        title: ManagerStrings.trips,
                                        icon: Icons.directions_bus_sharp,
                                        value: controller.tripCount.toString(),
                                        color: ManagerColors.red,
                                        iconColor: ManagerColors.red,
                                        onPressed: () {
                                          Get.toNamed(Routes.addTripPage);
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: ManagerWidth.w20),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: (){
                                        Get.put(CompanyController());
                                        Get.toNamed(Routes.companyView);
                                      },
                                      child: buildMiniCard(
                                        buttonText: "اضافة شركة",
                                        width: miniCardWidth,
                                        title: ManagerStrings.companies,
                                        icon: Icons.store,
                                        value: controller.companyCount.toString(),
                                        color: ManagerColors.yellow,
                                        iconColor: ManagerColors.yellow,
                                        onPressed: () {
                                          Get.toNamed(Routes.companyCreatePage);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      Get.toNamed(Routes.tripsView);
                                    },
                                    child: buildMiniCard(
                                      width: miniCardWidth,
                                      buttonText: "اضافة رحلة",

                                      title: ManagerStrings.trips,
                                      icon: Icons.directions_bus_sharp,
                                      value: controller.tripCount.toString(),
                                      color: ManagerColors.red,
                                      iconColor: ManagerColors.red,
                                      onPressed: () {
                                        Get.toNamed(Routes.addTripPage);
                                      },
                                    ),
                                  ),
                                  SizedBox(height: ManagerHeight.h20),
                                  GestureDetector(
                                    onTap: (){
                                      Get.put(CompanyController());
                                      Get.toNamed(Routes.companyView);
                                    },
                                    child: buildMiniCard(
                                      buttonText: "اضافة شركة",

                                      width: miniCardWidth,
                                      title: ManagerStrings.companies,
                                      icon: Icons.store,
                                      value: controller.companyCount.toString(),
                                      color: ManagerColors.yellow,
                                      iconColor: ManagerColors.yellow,
                                      onPressed: () {
                                        Get.toNamed(Routes.companyCreatePage);

                                      },
                                    ),
                                  ),
                                ],
                              ),
                        SizedBox(height: ManagerHeight.h20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ManagerColors.primaryColor,
                            fixedSize: Size(screenWidth > 400 ? 250 : screenWidth * 0.7, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () {},
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                ManagerStrings.citiesAndRegions,
                                style: TextStyle(
                                  color: ManagerColors.white,
                                  fontSize: ManagerFontSizes.s24,
                                ),
                              ),
                              Icon(
                                Icons.map,
                                color: ManagerColors.white,
                                size: 25,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: ManagerHeight.h20),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget buildMiniCard({
    required double width,
    required String title,
    required IconData icon,
    required String value,
    required Color color,
    required Color iconColor,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: width,
      height: 180,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: ManagerFontWeight.bold,
                  fontSize: ManagerFontSizes.s20,
                  color: ManagerColors.white,
                ),
              ),
              Icon(icon, color: ManagerColors.white, size: 30),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: ManagerFontWeight.bold,
              fontSize: 48,
              color: ManagerColors.white,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(0, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: onPressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      buttonText,
                      style: TextStyle(
                        color: ManagerColors.black,
                        fontSize: ManagerFontSizes.s24,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.add_circle,
                    color: iconColor,
                    size: 25,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
