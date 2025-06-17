import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_font_sizes.dart';
import '../../../../core/resources/manager_font_weight.dart';
import '../../../../core/resources/manager_strings.dart';
import '../controller/users_controller.dart';

class UsersView extends StatelessWidget {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UsersController>(
      init: UsersController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              ManagerStrings.users,
              style: TextStyle(
                fontSize: ManagerFontSizes.s24,
                fontWeight: ManagerFontWeight.bold,
              ),
            ),
            backgroundColor: ManagerColors.primaryColor,
            foregroundColor: ManagerColors.white,
          ),
          body: controller.isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: controller.users.length,
                  itemBuilder: (context, index) {
                    final user = controller.users[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        title: Text(
                          user['name'] ?? 'No Name',
                          style: TextStyle(
                            fontWeight: ManagerFontWeight.bold,
                            fontSize: ManagerFontSizes.s18,
                          ),
                        ),
                        subtitle: Text(
                          user['email'] ?? 'No Email',
                          style: TextStyle(
                            fontSize: ManagerFontSizes.s14,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: ManagerColors.red),
                          onPressed: () => controller.deleteUser(user.id),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
} 