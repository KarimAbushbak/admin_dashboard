import 'package:admin_dashboard/features/companies/presntation/controller/company_controller.dart';
import 'package:admin_dashboard/features/home/controller/home_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/storage/local/database/shared_preferences/app_settings_shared_preferences.dart';
import '../features/company_create/presntation/controller/company_create_controller.dart';
import '../firebase_options.dart';

initModule() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  await AppSettingsSharedPreferences().initPreferences();
}

initCompanyCreate() {
  Get.put<CompanyCreateController>(CompanyCreateController());
}

iniHome() {
  Get.put<HomeController>(HomeController());
}

initCompanies() {
  Get.put<CompanyController>(CompanyController());
}


