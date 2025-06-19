import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../companies/presntation/model/company_model.dart';

class EditCompanyController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController companyPaymentLinkController = TextEditingController();

  final Company company;

  EditCompanyController(this.company);

  void initializeFields() {
    usernameController.text = company.username;
    companyNameController.text= company.companyName;
    passwordController.text = company.password;
    phoneController.text = company.phone;
    addressController.text = company.address;
    companyPaymentLinkController.text = company.companyPaymentLink ?? '';
  }
  Future<void> fetchAndInitializeFields() async {
    final doc = await FirebaseFirestore.instance
        .collection('companies')
        .doc(company.id)
        .get();

    final updatedCompany = Company.fromMap(doc.id, doc.data()!);

    usernameController.text = updatedCompany.username;
    companyNameController.text = updatedCompany.companyName;
    passwordController.text = updatedCompany.password;
    phoneController.text = updatedCompany.phone;
    addressController.text = updatedCompany.address;
    companyPaymentLinkController.text = updatedCompany.companyPaymentLink ?? '';
  }


  Future<void> saveChanges(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('companies')
          .doc(company.id)
          .update({
        'username': usernameController.text.trim(),
        'companyName': companyNameController.text.trim(),
        'password': passwordController.text.trim(),
        'phone': phoneController.text.trim(),
        'address': addressController.text.trim(),
        'companyPaymentLink': companyPaymentLinkController.text.trim(),
      });


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم حفظ التعديلات بنجاح')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ: $e')),
      );
    }
  }

  Future<void> deleteCompany(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('companies')
          .doc(company.id)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم حذف الشركة بنجاح')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ: $e')),
      );
    }
  }
}
