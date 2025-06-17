import 'package:admin_dashboard/features/company_create/presntation/controller/company_create_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_font_sizes.dart';
import '../../../../core/resources/manager_font_weight.dart';
import '../../../../core/resources/manager_height.dart';
import '../../../../core/resources/manager_strings.dart';
import '../../../../core/resources/manager_width.dart';

class AddCompanyView extends StatelessWidget {
  const AddCompanyView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CompanyCreateController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Text(
              ManagerStrings.newCompany,
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
                      _buildTextField(ManagerStrings.enterUserName, horizontalMargin,controller.usernameController),

                      SizedBox(height: 30),
                      _buildLabel(ManagerStrings.password, horizontalMargin),
                      _buildTextField(ManagerStrings.enterYourPassword, horizontalMargin,controller.passwordController),
                      SizedBox(height: 30),
                      _buildLabel(ManagerStrings.companyName, horizontalMargin),
                      _buildTextField(ManagerStrings.companyName, horizontalMargin,controller.companyNameController),

                      SizedBox(height: 30),
                      _buildLabel(ManagerStrings.phoneNumber, horizontalMargin),
                      _buildTextField(ManagerStrings.enterPhoneNumber, horizontalMargin,controller.phoneController),

                      SizedBox(height: 30),
                      _buildLabel(ManagerStrings.address, horizontalMargin),
                      _buildTextField(ManagerStrings.enterTheAddress, horizontalMargin,controller.addressController),

                      SizedBox(height: 30),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ManagerColors.green,
                                fixedSize: Size(250, 40),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onPressed: () {
                                controller.createCompany();
                              },
                              child: Text(
                                ManagerStrings.addition,
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
                              onPressed: () {},
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
                    ],
                  ),
                );
              },
            ),
          ),
        );
      }
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

Widget _buildTextField(String hint, double margin,TextEditingController controller) {
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