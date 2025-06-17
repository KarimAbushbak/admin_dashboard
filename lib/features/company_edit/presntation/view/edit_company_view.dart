import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_font_sizes.dart';
import '../../../../core/resources/manager_font_weight.dart';
import '../../../../core/resources/manager_height.dart';
import '../../../../core/resources/manager_raduis.dart';
import '../../../../core/resources/manager_strings.dart';
import '../../../../core/resources/manager_width.dart';
import '../../../../core/routes.dart';
import '../../../companies/presntation/model/company_model.dart';
import '../controller/edit_company_controller.dart';

class EditCompanyView extends StatelessWidget {
  final Company company;

  const EditCompanyView({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put<EditCompanyController>(
      EditCompanyController(company),
      tag: company.id,
    );
    controller.fetchAndInitializeFields();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          ManagerStrings.companyName,
          style: TextStyle(
            fontSize: 44,
            fontWeight: ManagerFontWeight.bold,
          ),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;
            double horizontalMargin = screenWidth > 800 ? 200 : 20;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: ManagerHeight.h24),
                  _buildLabel(ManagerStrings.userName, horizontalMargin),
                  SizedBox(height: 10),
                  _buildTextField(
                    ManagerStrings.enterUserName,
                    horizontalMargin,
                    controller.usernameController,
                  ),
                  SizedBox(height: 30),
                  _buildLabel(ManagerStrings.password, horizontalMargin),
                  SizedBox(height: 10),
                  _buildTextField(
                    ManagerStrings.enterYourPassword,
                    horizontalMargin,
                    controller.passwordController,
                  ),
                  SizedBox(height: 30),
                  _buildLabel(ManagerStrings.phoneNumber, horizontalMargin),
                  SizedBox(height: 10),
                  _buildTextField(
                    ManagerStrings.enterPhoneNumber,
                    horizontalMargin,
                    controller.phoneController,
                  ),
                  SizedBox(height: 30),
                  _buildLabel(ManagerStrings.address, horizontalMargin),
                  SizedBox(height: 10),
                  _buildTextField(
                    ManagerStrings.enterTheAddress,
                    horizontalMargin,
                    controller.addressController,
                  ),
                  SizedBox(height: 30),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ManagerColors.bgColorNamecompany,
                            fixedSize: Size(250, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () => controller.saveChanges(context),
                          child: Text(
                            ManagerStrings.eidt,
                            style: TextStyle(
                              color: ManagerColors.white,
                              fontSize: ManagerFontSizes.s12,
                            ),
                          ),
                        ),
                        SizedBox(width: ManagerWidth.w20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ManagerColors.red,
                            fixedSize: Size(150, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () async {
                            await controller.deleteCompany(context);
                          },
                          child: Text(
                            ManagerStrings.delete,
                            style: TextStyle(
                              color: ManagerColors.white,
                              fontSize: ManagerFontSizes.s12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(
                             Routes.companyTripsView, 
                              arguments: {'companyId': company.id},
                            );
                          },
                          child: Container(
                            width: 200,
                            height: 150,
                            decoration: BoxDecoration(
                              color: ManagerColors.green,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.directions_bus_sharp,
                                    color: ManagerColors.white, size: 80),
                                Text(
                                  ManagerStrings.trips,
                                  style: TextStyle(
                                    fontWeight: ManagerFontWeight.regular,
                                    fontSize: ManagerFontSizes.s20,
                                    color: ManagerColors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Container(
                          width: 200,
                          height: 150,
                          decoration: BoxDecoration(
                            color: ManagerColors.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: GestureDetector(
                            onTap: (){
                              Get.toNamed(
                                Routes.companyBookings,
                                arguments: {'companyId': company.id},
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.store,
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
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

Widget _buildLabel(String text, double margin) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: margin),
    child: Text(
      text,
      style: TextStyle(
        fontSize: ManagerFontSizes.s18,
        fontWeight: ManagerFontWeight.regular,
        color: ManagerColors.black,
      ),
    ),
  );
}

Widget _buildTextField(String hint, double margin, TextEditingController controller) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: margin),
    child: TextField(
      controller: controller,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: ManagerColors.bgColorTextField),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        hintText: hint,
        hintStyle: TextStyle(color: ManagerColors.bgColorTextFieldString),
        filled: true,
        fillColor: ManagerColors.bgColorTextField,
      ),
    ),
  );
}
