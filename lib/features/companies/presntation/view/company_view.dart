import 'package:admin_dashboard/features/companies/presntation/controller/company_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_font_sizes.dart';
import '../../../../core/resources/manager_font_weight.dart';
import '../../../../core/resources/manager_height.dart';
import '../../../../core/resources/manager_strings.dart';
import '../../../../core/routes.dart';
import '../../../company_edit/presntation/view/edit_company_view.dart';

class CompanyView extends StatelessWidget {
  const CompanyView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CompanyController>(
      init: CompanyController(),
      builder: (controller) {
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
                  offset: Offset(0, -1),
                ),
              ],
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.search, color: Colors.white, size: 30),
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate: CompanySearchDelegate(controller),
                      );
                    },
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(250, 50),
                    backgroundColor: ManagerColors.green,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Get.toNamed(Routes.companyCreatePage);
                  },
                  icon: Icon(Icons.add, color: Colors.white),
                  label: Text(
                    ManagerStrings.addANewCompany,
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
            centerTitle: true,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Get.back();
              },
            ),
            title: Text(
              ManagerStrings.companies,
              style: TextStyle(
                fontSize: 44,
                fontWeight: ManagerFontWeight.bold,
              ),
            ),
          ),
          body: Obx(() => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : LayoutBuilder(
                  builder: (context, constraints) {
                    double screenWidth = constraints.maxWidth;
                    double contentWidth = screenWidth > 800 ? 760 : screenWidth - 40;
                    double horizontalMargin = screenWidth > 800 ? (screenWidth - contentWidth) / 2 : 20;

                    return ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      itemCount: controller.filteredCompanies.length,
                      itemBuilder: (context, index) {
                        final company = controller.filteredCompanies[index];
                        final tripCount = controller.getTripCount(company.id);

                        return Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: horizontalMargin, vertical: 10),
                          width: contentWidth,
                          height: 180,
                          decoration: BoxDecoration(
                            color: ManagerColors.bgColorcompany,
                            border: Border.all(
                              color: ManagerColors.bgFrameColorcompany,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 30),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: ManagerColors.green,
                                        fixedSize: Size(100, 0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                      ),
                                      onPressed: () {},
                                      child: Text(
                                        ManagerStrings.effective,
                                        style: TextStyle(
                                          color: ManagerColors.white,
                                          fontSize: ManagerFontSizes.s14,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: ManagerHeight.h20),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: ManagerColors.red,
                                        fixedSize: Size(100, 40),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => EditCompanyView(company: company),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        ManagerStrings.details,
                                        style: TextStyle(
                                          color: ManagerColors.white,
                                          fontSize: ManagerFontSizes.s12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: screenWidth > 800 ? 380 : 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        company.companyName,
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: ManagerFontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: ManagerHeight.h18),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            company.phone,
                                            style: TextStyle(
                                                fontSize: ManagerFontSizes.s18,
                                                fontWeight: ManagerFontWeight.regular,
                                                color: ManagerColors.grey),
                                          ),
                                          Text(
                                            ManagerStrings.phone,
                                            style: TextStyle(
                                                fontSize: ManagerFontSizes.s18,
                                                fontWeight: ManagerFontWeight.regular,
                                                color: ManagerColors.grey),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            '$tripCount',
                                            style: TextStyle(
                                                fontSize: ManagerFontSizes.s18,
                                                fontWeight: ManagerFontWeight.regular,
                                                color: ManagerColors.grey),
                                          ),
                                          Text(
                                            ManagerStrings.numberOfTrips,
                                            style: TextStyle(
                                                fontSize: ManagerFontSizes.s18,
                                                fontWeight: ManagerFontWeight.regular,
                                                color: ManagerColors.grey),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
        ));
      },
    );
  }
}

class CompanySearchDelegate extends SearchDelegate {
  final CompanyController controller;

  CompanySearchDelegate(this.controller);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          controller.searchCompanies(query);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    controller.searchCompanies(query);
    return ListView.builder(
      itemCount: controller.filteredCompanies.length,
      itemBuilder: (context, index) {
        final company = controller.filteredCompanies[index];
        return ListTile(
          title: Text(company.companyName),
          subtitle: Text(company.phone),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EditCompanyView(company: company),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    controller.searchCompanies(query);
    return ListView.builder(
      itemCount: controller.filteredCompanies.length,
      itemBuilder: (context, index) {
        final company = controller.filteredCompanies[index];
        return ListTile(
          title: Text(company.companyName),
          subtitle: Text(company.phone),
          onTap: () {
            query = company.companyName;
            showResults(context);
          },
        );
      },
    );
  }
}