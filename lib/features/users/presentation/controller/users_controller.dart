import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UsersController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<QueryDocumentSnapshot> users = [];
  bool isLoading = true;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      isLoading = true;
      update();

      final QuerySnapshot snapshot = await _firestore.collection('users').get();
      users = snapshot.docs;
      
      isLoading = false;
      update();
    } catch (e) {
      print('Error fetching users: $e');
      isLoading = false;
      update();
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
      await fetchUsers(); // Refresh the list after deletion
    } catch (e) {
      print('Error deleting user: $e');
    }
  }
} 