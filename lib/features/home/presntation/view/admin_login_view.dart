import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_assets.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_font_sizes.dart';
import '../../../../core/resources/manager_font_weight.dart';
import '../../../../core/resources/manager_height.dart';
import '../../../../core/resources/manager_raduis.dart';
import '../../../../core/resources/manager_strings.dart';
import '../../../../core/resources/manager_width.dart';
import '../../controller/admin_login_controller.dart';

class AdminLoginView extends StatelessWidget {
  const AdminLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminLoginController>(
      init: AdminLoginController(),
      builder: (controller) {
        return Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("تذكرة",style: TextStyle(
                        fontSize: 48,
                        fontWeight: ManagerFontWeight.bold,
                      ),),
                      SizedBox(width: ManagerWidth.w10,),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(ManagerAssets.auth1),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ManagerHeight.h40,),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width > 600 ? 250 : 24,
                    ),
                    child: TextField(
                      controller: controller.usernameController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(24)),
                          borderSide: BorderSide(
                            color: ManagerColors.bgColorTextField,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(24)),
                          borderSide: BorderSide.none,
                        ),
                        hintText: ManagerStrings.enterEmailOrUser,
                        hintStyle: TextStyle(
                            color: ManagerColors.bgColorTextFieldString),
                        filled: true,
                        fillColor: ManagerColors.bgColorTextField,
                      ),
                    ),
                  ),
                  SizedBox(height: ManagerHeight.h24,),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width > 600 ? 250 : 24,
                    ),
                    child: TextField(
                      controller: controller.passwordController, // for password
                      textAlign: TextAlign.center, // لمحاذاة النص أفقيًا في المنتصف
                      obscureText: true,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(24)),
                          borderSide: BorderSide(
                            color: ManagerColors.bgColorTextField,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(24)),
                          borderSide: BorderSide.none,
                        ),
                        hintText: ManagerStrings.password,
                        hintStyle: TextStyle(
                            color: ManagerColors.bgColorTextFieldString),
                        filled: true,
                        fillColor: ManagerColors.bgColorTextField,
                      ),
                    ),
                  ),
                  SizedBox(height: ManagerHeight.h60,),
                  GestureDetector(
                    onTap: () => Get.toNamed('/resetPassword'),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Text(
                        'هل نسيت كلمة السر؟',
                        style: TextStyle(
                          color: ManagerColors.primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return SizedBox(
                      width: ManagerWidth.w210,
                      height: ManagerHeight.h75,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ManagerColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: controller.loginAdmin,
                        child: Text(
                          ManagerStrings.login,
                          style: TextStyle(
                            fontWeight: ManagerFontWeight.regular,
                            fontSize: 48,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
} 