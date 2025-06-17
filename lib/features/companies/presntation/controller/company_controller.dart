import 'dart:async';

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/company_model.dart'; // adjust path as needed
import '../../../../core/resources/manager_strings.dart';

class CompanyController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList<Company> companies = <Company>[].obs;
  RxList<Company> filteredCompanies = <Company>[].obs;
  RxBool isLoading = true.obs;
  String searchQuery = '';
  Map<String, int> companyTripCounts = {};
  StreamSubscription<QuerySnapshot>? _companiesSubscription;

  @override
  void onInit() {
    super.onInit();
    fetchCompanies();
    listenToCompanies();
  }

  Future<void> fetchCompanies() async {
    try {
      isLoading.value = true;
      final QuerySnapshot snapshot = await _firestore.collection('companies').get();
      companies.value = snapshot.docs
          .map((doc) => Company.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
      filteredCompanies.value = companies;
      isLoading.value = false;
    } catch (e) {
      print('Error fetching companies: $e');
      isLoading.value = false;
    }
  }

  void searchCompanies(String query) {
    searchQuery = query;
    if (query.isEmpty) {
      filteredCompanies.value = companies;
    } else {
      filteredCompanies.value = companies.where((company) {
        return company.companyName.toLowerCase().contains(query.toLowerCase()) ||
               company.phone.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }

  void listenToCompanies() {
    _companiesSubscription = FirebaseFirestore.instance
        .collection('companies')
        .snapshots()
        .listen((snapshot) async {
      companies.value = snapshot.docs.map((doc) {
        return Company.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();

      // Fetch adding_trips counts for each company
      for (var company in companies) {
        final tripsSnapshot = await FirebaseFirestore.instance
            .collection('trips')
            .where('companyId', isEqualTo: company.id)
            .get();
        
        companyTripCounts[company.id] = tripsSnapshot.size;
      }

      searchCompanies(searchQuery);
    });
  }

  int getTripCount(String companyId) {
    return companyTripCounts[companyId] ?? 0;
  }

  @override
  void onClose() {
    // Cancel the subscription when the controller is disposed
    _companiesSubscription?.cancel();
    super.onClose();
  }
}
