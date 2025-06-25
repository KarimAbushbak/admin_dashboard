import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_font_sizes.dart';
import '../../../../core/resources/manager_font_weight.dart';
import '../../../../core/resources/manager_height.dart';
import '../../../../core/resources/manager_strings.dart';

class EditTripPage extends StatefulWidget {
  const EditTripPage({Key? key}) : super(key: key);

  @override
  State<EditTripPage> createState() => _EditTripPageState();
}

class _EditTripPageState extends State<EditTripPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController fromController;
  late TextEditingController toController;
  late TextEditingController dateController;
  late TextEditingController timeLeaveController;
  late TextEditingController timeArriveController;
  late TextEditingController priceController;
  late TextEditingController notesController;
  int seatCount = 0;
  bool isLoading = false;
  late String tripId;

  @override
  void initState() {
    super.initState();
    final trip = Get.arguments as Map<String, dynamic>;
    tripId = trip['id'];
    fromController = TextEditingController(text: trip['from'] ?? '');
    toController = TextEditingController(text: trip['to'] ?? '');
    dateController = TextEditingController(text: trip['date'] ?? '');
    timeLeaveController = TextEditingController(text: trip['timeLeave'] ?? '');
    timeArriveController = TextEditingController(text: trip['timeArrive'] ?? '');
    priceController = TextEditingController(text: trip['price']?.toString() ?? '');
    notesController = TextEditingController(text: trip['notes'] ?? '');
    seatCount = trip['seats'] ?? 0;
  }

  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
    dateController.dispose();
    timeLeaveController.dispose();
    timeArriveController.dispose();
    priceController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      locale: const Locale('ar', ''),
    );
    if (picked != null) {
      setState(() {
        dateController.text = '${picked.day}-${picked.month}-${picked.year}';
      });
    }
  }

  Future<void> updateTrip() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { isLoading = true; });
    try {
      await FirebaseFirestore.instance.collection('trips').doc(tripId).update({
        'from': fromController.text.trim(),
        'to': toController.text.trim(),
        'date': dateController.text.trim(),
        'timeLeave': timeLeaveController.text.trim(),
        'timeArrive': timeArriveController.text.trim(),
        'seats': seatCount,
        'price': double.tryParse(priceController.text.trim()) ?? 0.0,
        'notes': notesController.text.trim(),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم تعديل الرحلة بنجاح!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
      Get.snackbar(
        '✅ Success',
        'Trip updated successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
      );
      Get.back(result: true);
    } catch (e) {
      Get.snackbar(
        '❌ Error',
        'Failed to update trip: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
      );
    } finally {
      setState(() { isLoading = false; });
    }
  }

  Future<void> deleteTrip() async {
    setState(() { isLoading = true; });
    try {
      await FirebaseFirestore.instance.collection('trips').doc(tripId).delete();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم حذف الرحلة بنجاح!'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
      Get.snackbar(
        'تم الحذف',
        'تم حذف الرحلة بنجاح!',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
      );
      Get.back(result: 'deleted');
    } catch (e) {
      Get.snackbar(
        '❌ Error',
        'فشل حذف الرحلة: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
      );
    } finally {
      setState(() { isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth > 600 ? 500.0 : screenWidth * 0.9;
    final horizontalMargin = screenWidth > 600 ? (screenWidth - containerWidth) / 2 : screenWidth * 0.05;
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
              onPressed: isLoading ? null : updateTrip,
              icon: isLoading
                  ? SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.save, color: Colors.white),
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
                GestureDetector(
                  onTap: isLoading ? null : deleteTrip,
                  child: Container(
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
                        fontWeight: FontWeight.bold,
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
          final containerWidth = screenWidth > 600 ? 500.0 : screenWidth * 0.9;
          final horizontalMargin = screenWidth > 600 ? (screenWidth - containerWidth) / 2 : screenWidth * 0.05;
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: ManagerHeight.h30),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
                    width: containerWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: screenWidth > 600 ? (containerWidth - 20) / 2 : containerWidth,
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
                                    value: toController.text.isEmpty ? 'إدلب' : toController.text,
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
                                      setState(() {
                                        toController.text = value!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: screenWidth > 600 ? (containerWidth - 20) / 2 : containerWidth,
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
                                    value: fromController.text.isEmpty ? 'إدلب' : fromController.text,
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
                                      setState(() {
                                        fromController.text = value!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: ManagerHeight.h16),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
                    width: containerWidth,
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
                                controller: dateController,
                                readOnly: true,
                                onTap: () => selectDate(context),
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
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: ManagerHeight.h16),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: screenWidth > 600 ? (containerWidth - 20) / 2 : containerWidth,
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
                                    controller: timeArriveController,
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
                          width: screenWidth > 600 ? (containerWidth - 20) / 2 : containerWidth,
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
                                    controller: timeLeaveController,
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
                  ),
                  SizedBox(height: ManagerHeight.h16),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: screenWidth > 600 ? (containerWidth - 20) / 2 : containerWidth,
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
                                    controller: priceController,
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
                          width: screenWidth > 600 ? (containerWidth - 20) / 2 : containerWidth,
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
                                      onTap: () {
                                        setState(() {
                                          if (seatCount > 0) seatCount--;
                                        });
                                      },
                                      child: Icon(Icons.remove, color: ManagerColors.primaryColor),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      seatCount.toString(),
                                      style: TextStyle(
                                        fontSize: ManagerFontSizes.s18,
                                        fontWeight: ManagerFontWeight.regular,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          seatCount++;
                                        });
                                      },
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
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
} 