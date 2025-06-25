import 'package:admin_dashboard/core/resources/manager_strings.dart';
import 'package:admin_dashboard/features/booking/presntation/view/booking_view.dart';
import 'package:admin_dashboard/features/companies/presntation/view/company_view.dart';
import 'package:admin_dashboard/features/company_bookings/presntation/view/company_bookings.dart';
import 'package:admin_dashboard/features/company_trips/presntation/view/company_trips_view.dart';
import 'package:admin_dashboard/features/home/presntation/view/home_view.dart';
import 'package:admin_dashboard/features/trips/presntation/view/trips_view.dart';
import 'package:admin_dashboard/features/users/presentation/view/users_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../config/dependancy_injection.dart';
import '../features/adding_trips/presntation/view/add_trip_page.dart';
import '../features/companies_trip_booking/presntation/view/company_bookings_page.dart';
import '../features/company_create/presntation/view/add_company_view.dart';
import '../features/trips/presntation/view/edit_trip_page.dart';
import '../features/home/presntation/view/admin_login_view.dart';
import '../features/home/presntation/view/reset_password_view.dart';

class Routes {
  static const String splashScreen = '/splash_screen';
  static const String languagePage = '/language_page';
  static const String homeView = '/homeView';
  static const String outBoarding = '/outBoardingView';
  static const String loginView = '/loginView';
  static const String registerView = '/registerView';
  static const String signUpScreen = '/signUpScreen';
  static const String profileView = '/profileView';
  static const String detailsView = '/detailsView';
  static const String settingsView = '/settingsView';
  static const String cartView = '/cartView';
  static const String brandView = '/brandView';
  static const String categoriesView = '/categoriesView';
  static const String favoriteView = '/favoriteView';
  static const String productsView = '/productsView';
  static const String addTripPage = '/addTripPage';
  static const String companyCreatePage = '/companyCreatePage';
  static const String companyView = '/companyView';
  static const String companyTripsView = '/companyTripsView';
  static const String companyBookingView = '/CompanyBookingView';
  static const String bookingView = '/bookingView';
  static const String tripsView = '/tripsView';
  static const String companyBookings = '/companyBookings';
  static const String usersView = '/usersView';
  static const String editTripPage = '/editTrip';
  static const String adminLogin = '/adminLogin';
  static const String resetPassword = '/resetPassword';
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.addTripPage:
        return MaterialPageRoute(
          builder: (_) => AddTripPage(),
        );
      case Routes.companyCreatePage:
        initCompanyCreate();
        return MaterialPageRoute(builder: (_) => AddCompanyView());
      case Routes.homeView:
        iniHome();
        return MaterialPageRoute(builder: (_) => HomeView());
      case Routes.companyView:
        initCompanies();
        return MaterialPageRoute(builder: (_) => CompanyView());
      case Routes.companyTripsView:
        final args = settings.arguments as Map<String, dynamic>;
        final companyId = args['companyId'] as String;
        return MaterialPageRoute(
            builder: (_) => CompanyTripsView(companyId: companyId));
      case Routes.companyBookingView:
        final args = settings.arguments as Map<String, dynamic>;
        final companyId = args['companyId'] as String;
        final tripId = args['tripId'] as String?;
        return MaterialPageRoute(
          builder: (_) =>
              CompanyBookingsPage(companyId: companyId, tripId: tripId),
        );
      case Routes.bookingView:
        initCompanies();
        return MaterialPageRoute(builder: (_) => BookingView());
      case Routes.tripsView:
        return MaterialPageRoute(builder: (_) => TripsView());
      case Routes.companyBookings:
        final args = settings.arguments as Map<String, dynamic>?;
        final companyId = args?['companyId'] as String?;
        final tripId = args?['tripId'] as String?;
        return MaterialPageRoute(
          builder: (_) => CompanyBookings(companyId: companyId, tripId: tripId),
        );
      case Routes.usersView:
        return MaterialPageRoute(builder: (_) => UsersView());
      case Routes.editTripPage:
        final trip = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => EditTripPage(),
          settings: RouteSettings(arguments: trip),
        );
      case Routes.adminLogin:
        return MaterialPageRoute(builder: (_) => AdminLoginView());
      case Routes.resetPassword:
        return MaterialPageRoute(builder: (_) => ResetPasswordView());
      // case Routes.detailsView:
      //   final product = settings.arguments as Map<String, dynamic>;
      //   initDetails();
      //   return MaterialPageRoute(
      //       builder: (_) => ProductDetailsView(product: product));
      // case Routes.cartView:
      //   initCart();
      //   return MaterialPageRoute(builder: (_) => CartView());
      // case Routes.favoriteView:
      //   initHome();
      //   return MaterialPageRoute(builder: (_) => FavoriteView());
      // case Routes.productsView:
      //   initHome();
      //   return MaterialPageRoute(builder: (_) => ProductsView());
      // case Routes.profileView:
      //   initProfile();
      //   return MaterialPageRoute(builder: (_) => ProfileView());

      default:
        return unDefineRoute();
    }
  }

  static Route<dynamic> unDefineRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text(ManagerStrings.notFoundRoute),
        ),
      ),
    );
  }
}
