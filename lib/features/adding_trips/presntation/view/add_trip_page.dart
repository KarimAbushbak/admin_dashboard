import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_font_sizes.dart';
import '../../../../core/resources/manager_font_weight.dart';
import '../../../../core/resources/manager_height.dart';
import '../../../../core/resources/manager_strings.dart';
import '../controller/trip_controller.dart';

class AddTripPage extends StatelessWidget {
  final TripController controller = Get.put(TripController());

  AddTripPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TripController>(builder: (controller) {
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
                offset: const Offset(0, -1),
              ),
            ],
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 80,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ManagerColors.grey,
                    fixedSize: const Size(200, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    ManagerStrings.cancellation,
                    style: TextStyle(
                      color: ManagerColors.white,
                      fontSize: ManagerFontSizes.s18,
                      fontWeight: ManagerFontWeight.bold,
                    ),
                  ),
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(250, 50),
                  backgroundColor: ManagerColors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () => controller.addTrip(context),
                icon: const Icon(Icons.file_copy, color: Colors.white),
                label: Text(
                  ManagerStrings.saveInformation,
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
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: screenWidth > 500 ? 70 : 55,
                    height: 36,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: ManagerColors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        ManagerStrings.delete,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth > 500 ? ManagerFontSizes.s16 : ManagerFontSizes.s14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        ManagerStrings.trips,
                        style: TextStyle(
                          fontSize: screenWidth > 500 ? 44 : 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'السابق',
                        style: TextStyle(
                          color: ManagerColors.black,
                          fontSize: ManagerFontSizes.s16,
                          fontWeight: ManagerFontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_forward_ios_sharp,
                          color: ManagerColors.primaryColor,
                          size: 28,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final containerWidth = screenWidth > 1000 ? 900.0 : (screenWidth > 600 ? screenWidth * 0.95 : screenWidth * 0.98);
            final horizontalMargin = (screenWidth - containerWidth) / 2;
            return Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: containerWidth),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        SizedBox(height: ManagerHeight.h20),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 0),
                          width: double.infinity,
                          height: 60,
                          padding: EdgeInsets.symmetric(horizontal: screenWidth > 600 ? 20 : 8),
                          decoration: BoxDecoration(
                            color: ManagerColors.bgColorcompany,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: ManagerColors.bgFrameColorcompany,
                              width: 1,
                            ),
                          ),
                          child: Obx(() {
                            if (controller.companies.isEmpty) {
                              return Center(child: Text("Loading companies..."));
                            }
                            return DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: Text("Select Company"),
                                value: controller.selectedCompanyId?.value,
                                items: controller.companies.map((company) {
                                  return DropdownMenuItem<String>(
                                    value: company['id'],
                                    child: Text(
                                      company['name'],
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: ManagerFontSizes.s18,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  controller.setSelectedCompanyId(newValue);
                                },
                                dropdownColor: ManagerColors.bgColorcompany,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: ManagerFontSizes.s18
                                ),
                                icon: Icon(Icons.arrow_drop_down, color: ManagerColors.primaryColor),
                              ),
                            );
                          }),
                        ),
                        SizedBox(height: ManagerHeight.h12),
                        screenWidth > 600
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: (containerWidth - 20) / 2,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: ManagerColors.bgColorcompany,
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: ManagerColors.bgFrameColorcompany,
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        ManagerStrings.toTheCity,
                                        style: TextStyle(
                                          fontWeight: ManagerFontWeight.bold,
                                          fontSize: 22,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        width: 120,
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF4F4F4),
                                          borderRadius: BorderRadius.circular(15),
                                          border: Border.all(color: Colors.grey.shade300),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            value: controller.toController.text.isEmpty ? 'إدلب' : controller.toController.text,
                                            icon: const Icon(Icons.arrow_drop_down),
                                            items: [
                                              'إدلب',
                                              'دمشق',
                                              'حلب',
                                              'حمص',
                                              'اللاذقية',
                                              'طرطوس',
                                              'درعا',
                                              'الرقة',
                                              'الحسكة',
                                              'القنيطرة',
                                            ].map((city) {
                                              return DropdownMenuItem<String>(
                                                value: city,
                                                child: Text(city),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              if (value != null) {
                                                controller.toController.text = value;
                                                controller.update();
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: (containerWidth - 20) / 2,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: ManagerColors.bgColorcompany,
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: ManagerColors.bgFrameColorcompany,
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        ManagerStrings.fromTheCity,
                                        style: TextStyle(
                                          fontWeight: ManagerFontWeight.bold,
                                          fontSize: 22,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        width: 120,
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF4F4F4),
                                          borderRadius: BorderRadius.circular(15),
                                          border: Border.all(color: Colors.grey.shade300),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            value: controller.fromController.text.isEmpty ? 'إدلب' : controller.fromController.text,
                                            icon: const Icon(Icons.arrow_drop_down),
                                            items: [
                                              'إدلب',
                                              'دمشق',
                                              'حلب',
                                              'حمص',
                                              'اللاذقية',
                                              'طرطوس',
                                              'درعا',
                                              'الرقة',
                                              'الحسكة',
                                              'القنيطرة',
                                            ].map((city) {
                                              return DropdownMenuItem<String>(
                                                value: city,
                                                child: Text(city),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              if (value != null) {
                                                controller.fromController.text = value;
                                                controller.update();
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Container(
                                  width: containerWidth,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: ManagerColors.bgColorcompany,
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: ManagerColors.bgFrameColorcompany,
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        ManagerStrings.toTheCity,
                                        style: TextStyle(
                                          fontWeight: ManagerFontWeight.bold,
                                          fontSize: 22,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        width: 120,
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF4F4F4),
                                          borderRadius: BorderRadius.circular(15),
                                          border: Border.all(color: Colors.grey.shade300),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            value: controller.toController.text.isEmpty ? 'إدلب' : controller.toController.text,
                                            icon: const Icon(Icons.arrow_drop_down),
                                            items: [
                                              'إدلب',
                                              'دمشق',
                                              'حلب',
                                              'حمص',
                                              'اللاذقية',
                                              'طرطوس',
                                              'درعا',
                                              'الرقة',
                                              'الحسكة',
                                              'القنيطرة',
                                            ].map((city) {
                                              return DropdownMenuItem<String>(
                                                value: city,
                                                child: Text(city),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              if (value != null) {
                                                controller.toController.text = value;
                                                controller.update();
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 8),
                                Container(
                                  width: containerWidth,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: ManagerColors.bgColorcompany,
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: ManagerColors.bgFrameColorcompany,
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        ManagerStrings.fromTheCity,
                                        style: TextStyle(
                                          fontWeight: ManagerFontWeight.bold,
                                          fontSize: 22,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        width: 120,
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF4F4F4),
                                          borderRadius: BorderRadius.circular(15),
                                          border: Border.all(color: Colors.grey.shade300),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            value: controller.fromController.text.isEmpty ? 'إدلب' : controller.fromController.text,
                                            icon: const Icon(Icons.arrow_drop_down),
                                            items: [
                                              'إدلب',
                                              'دمشق',
                                              'حلب',
                                              'حمص',
                                              'اللاذقية',
                                              'طرطوس',
                                              'درعا',
                                              'الرقة',
                                              'الحسكة',
                                              'القنيطرة',
                                            ].map((city) {
                                              return DropdownMenuItem<String>(
                                                value: city,
                                                child: Text(city),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              if (value != null) {
                                                controller.fromController.text = value;
                                                controller.update();
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                        SizedBox(height: ManagerHeight.h12),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 0),
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                            color: ManagerColors.bgColorcompany,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: ManagerColors.bgFrameColorcompany,
                              width: 1,
                            ),
                          ),
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 180,
                                  height: 38,
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: ManagerColors.bgColorTextTrips,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Center(
                                    child: TextField(
                                      controller: controller.dateController,
                                      readOnly: true,
                                      onTap: () => controller.selectDate(context),
                                      textAlign: TextAlign.center,
                                      textDirection: TextDirection.rtl,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'dd-mm-yyyy',
                                        hintStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: ManagerFontSizes.s18,
                                          fontWeight: ManagerFontWeight.regular,
                                        ),
                                      ),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: ManagerFontSizes.s18,
                                        fontWeight: ManagerFontWeight.regular,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  ManagerStrings.theDate,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: ManagerFontWeight.bold,
                                    fontSize: 22,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: ManagerHeight.h12),
                        screenWidth > 600
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: (containerWidth - 20) / 2,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: ManagerColors.bgColorcompany,
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: ManagerColors.bgFrameColorcompany,
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        ManagerStrings.access,
                                        style: TextStyle(
                                          fontWeight: ManagerFontWeight.bold,
                                          fontSize: 22,
                                        ),
                                      ),
                                      const SizedBox(height: 14),
                                      Container(
                                        width: 100,
                                        height: 42,
                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: ManagerColors.bgColorTextTrips,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: TextField(
                                            controller: controller.timeArriveController,
                                            textAlign: TextAlign.center,
                                            textDirection: TextDirection.rtl,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: '00:00',
                                              hintStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: ManagerFontSizes.s18,
                                                fontWeight: ManagerFontWeight.regular,
                                              ),
                                            ),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: ManagerFontSizes.s18,
                                              fontWeight: ManagerFontWeight.regular,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: (containerWidth - 20) / 2,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: ManagerColors.bgColorcompany,
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: ManagerColors.bgFrameColorcompany,
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        ManagerStrings.launch,
                                        style: TextStyle(
                                          fontWeight: ManagerFontWeight.bold,
                                          fontSize: 22,
                                        ),
                                      ),
                                      const SizedBox(height: 14),
                                      Container(
                                        width: 100,
                                        height: 42,
                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: ManagerColors.bgColorTextTrips,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: TextField(
                                            controller: controller.timeLeaveController,
                                            textAlign: TextAlign.center,
                                            textDirection: TextDirection.rtl,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: '00:00',
                                              hintStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: ManagerFontSizes.s18,
                                                fontWeight: ManagerFontWeight.regular,
                                              ),
                                            ),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: ManagerFontSizes.s18,
                                              fontWeight: ManagerFontWeight.regular,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Container(
                                  width: containerWidth,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: ManagerColors.bgColorcompany,
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: ManagerColors.bgFrameColorcompany,
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        ManagerStrings.access,
                                        style: TextStyle(
                                          fontWeight: ManagerFontWeight.bold,
                                          fontSize: 22,
                                        ),
                                      ),
                                      const SizedBox(height: 14),
                                      Container(
                                        width: 100,
                                        height: 42,
                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: ManagerColors.bgColorTextTrips,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: TextField(
                                            controller: controller.timeArriveController,
                                            textAlign: TextAlign.center,
                                            textDirection: TextDirection.rtl,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: '00:00',
                                              hintStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: ManagerFontSizes.s18,
                                                fontWeight: ManagerFontWeight.regular,
                                              ),
                                            ),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: ManagerFontSizes.s18,
                                              fontWeight: ManagerFontWeight.regular,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 8),
                                Container(
                                  width: containerWidth,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: ManagerColors.bgColorcompany,
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: ManagerColors.bgFrameColorcompany,
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        ManagerStrings.launch,
                                        style: TextStyle(
                                          fontWeight: ManagerFontWeight.bold,
                                          fontSize: 22,
                                        ),
                                      ),
                                      const SizedBox(height: 14),
                                      Container(
                                        width: 100,
                                        height: 42,
                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: ManagerColors.bgColorTextTrips,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: TextField(
                                            controller: controller.timeLeaveController,
                                            textAlign: TextAlign.center,
                                            textDirection: TextDirection.rtl,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: '00:00',
                                              hintStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: ManagerFontSizes.s18,
                                                fontWeight: ManagerFontWeight.regular,
                                              ),
                                            ),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: ManagerFontSizes.s18,
                                              fontWeight: ManagerFontWeight.regular,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                        SizedBox(height: ManagerHeight.h12),
                        screenWidth > 600
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: (containerWidth - 20) / 2,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: ManagerColors.bgColorcompany,
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: ManagerColors.bgFrameColorcompany,
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        ManagerStrings.ticketPrice,
                                        style: TextStyle(
                                          fontWeight: ManagerFontWeight.bold,
                                          fontSize: 22,
                                        ),
                                      ),
                                      const SizedBox(height: 14),
                                      Container(
                                        width: 100,
                                        height: 42,
                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: ManagerColors.bgColorTextTrips,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: TextField(
                                            controller: controller.priceController,
                                            keyboardType: TextInputType.number,
                                            textAlign: TextAlign.center,
                                            textDirection: TextDirection.rtl,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: '0',
                                              hintStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: ManagerFontSizes.s18,
                                                fontWeight: ManagerFontWeight.regular,
                                              ),
                                            ),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: ManagerFontSizes.s18,
                                              fontWeight: ManagerFontWeight.regular,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: (containerWidth - 20) / 2,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: ManagerColors.bgColorcompany,
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: ManagerColors.bgFrameColorcompany,
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        ManagerStrings.numberOfSeats,
                                        style: TextStyle(
                                          fontWeight: ManagerFontWeight.bold,
                                          fontSize: 22,
                                        ),
                                      ),
                                      const SizedBox(height: 14),
                                      Container(
                                        height: 42,
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: ManagerColors.bgColorTextTrips,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            GestureDetector(
                                              onTap: controller.decrementSeats,
                                              child: Icon(Icons.remove, color: ManagerColors.primaryColor),
                                            ),
                                            const SizedBox(width: 12),
                                            Obx(() => Text(
                                              controller.seatCount.toString(),
                                              style: TextStyle(
                                                fontSize: ManagerFontSizes.s18,
                                                fontWeight: ManagerFontWeight.regular,
                                                color: Colors.black,
                                              ),
                                            )),
                                            const SizedBox(width: 12),
                                            GestureDetector(
                                              onTap: controller.incrementSeats,
                                              child: Icon(Icons.add, color: ManagerColors.primaryColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Container(
                                  width: containerWidth,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: ManagerColors.bgColorcompany,
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: ManagerColors.bgFrameColorcompany,
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        ManagerStrings.ticketPrice,
                                        style: TextStyle(
                                          fontWeight: ManagerFontWeight.bold,
                                          fontSize: 22,
                                        ),
                                      ),
                                      const SizedBox(height: 14),
                                      Container(
                                        width: 100,
                                        height: 42,
                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: ManagerColors.bgColorTextTrips,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: TextField(
                                            controller: controller.priceController,
                                            keyboardType: TextInputType.number,
                                            textAlign: TextAlign.center,
                                            textDirection: TextDirection.rtl,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: '0',
                                              hintStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: ManagerFontSizes.s18,
                                                fontWeight: ManagerFontWeight.regular,
                                              ),
                                            ),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: ManagerFontSizes.s18,
                                              fontWeight: ManagerFontWeight.regular,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 8),
                                Container(
                                  width: containerWidth,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: ManagerColors.bgColorcompany,
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: ManagerColors.bgFrameColorcompany,
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        ManagerStrings.numberOfSeats,
                                        style: TextStyle(
                                          fontWeight: ManagerFontWeight.bold,
                                          fontSize: 22,
                                        ),
                                      ),
                                      const SizedBox(height: 14),
                                      Container(
                                        height: 42,
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: ManagerColors.bgColorTextTrips,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            GestureDetector(
                                              onTap: controller.decrementSeats,
                                              child: Icon(Icons.remove, color: ManagerColors.primaryColor),
                                            ),
                                            const SizedBox(width: 12),
                                            Obx(() => Text(
                                              controller.seatCount.toString(),
                                              style: TextStyle(
                                                fontSize: ManagerFontSizes.s18,
                                                fontWeight: ManagerFontWeight.regular,
                                                color: Colors.black,
                                              ),
                                            )),
                                            const SizedBox(width: 12),
                                            GestureDetector(
                                              onTap: controller.incrementSeats,
                                              child: Icon(Icons.add, color: ManagerColors.primaryColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
}