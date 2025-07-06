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
import '../../controller/reset_password_controller.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final TextEditingController _emailController = TextEditingController();
  final ResetPasswordController _controller = Get.put(ResetPasswordController());

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                ManagerStrings.appName,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: ManagerFontWeight.w800,
                ),
              ),
              SizedBox(width: ManagerWidth.w8),
              Container(
                width: ManagerWidth.w68,
                height: 68,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(ManagerAssets.outBoarding1),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ManagerHeight.h100),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: ManagerWidth.w20),
                child: Text(
                  'أدخل بريدك الإلكتروني',
                  style: TextStyle(
                    color: ManagerColors.black,
                    fontSize: ManagerFontSizes.s24,
                    fontWeight: ManagerFontWeight.regular,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ManagerHeight.h12),
          Container(
            padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w250),
            child: TextField(
              controller: _emailController,
              textAlign: TextAlign.end,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(ManagerRadius.r20),
                  ),
                  borderSide: BorderSide(
                    color: ManagerColors.bgColorOutBoardingButton,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(ManagerRadius.r20),
                  ),
                  borderSide: BorderSide(
                    color: ManagerColors.bgColorOutBoardingButton,
                  ),
                ),
                hintText: 'أدخل بريدك الإلكتروني',
                hintStyle: TextStyle(
                  color: ManagerColors.bgColorOutBoardingButton,
                  fontSize: ManagerFontSizes.s18,
                ),
                filled: true,
                fillColor: ManagerColors.bgColorTextField,
              ),
            ),
          ),
          SizedBox(height: ManagerHeight.h40),
          Obx(() => Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: ManagerWidth.w210,
                height: ManagerHeight.h75,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ManagerColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: _controller.isLoading.value
                      ? null
                      : () {
                          _controller.sendResetEmail(
                            context,
                            _emailController.text,
                          );
                        },
                  child: Text(
                    'إرسال رابط إعادة تعيين كلمة المرور',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ManagerFontSizes.s20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              if (_controller.isLoading.value)
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
            ],
          )),
        ],
      ),
    );
  }
} 