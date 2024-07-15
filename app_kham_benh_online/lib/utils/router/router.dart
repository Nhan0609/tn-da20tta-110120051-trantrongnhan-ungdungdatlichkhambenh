import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:koruko_app/core/path/string.router.dart';
import 'package:koruko_app/presentation/admin/admin.dart';
import 'package:koruko_app/presentation/appointment_list/appointment_list.dart';
import 'package:koruko_app/presentation/cashier/cashier.dart';
import 'package:koruko_app/presentation/example/example.dart';
import 'package:koruko_app/presentation/home/view/home.dart';
import 'package:koruko_app/presentation/introduce/introduce.dart';
import 'package:koruko_app/presentation/list_medical_clinic/view/list_medical_clinic.dart';
import 'package:koruko_app/presentation/login/view/login.dart';
import 'package:koruko_app/presentation/medical_record_manager/view/medical_list_profile.dart';
import 'package:koruko_app/presentation/medical_record_manager/widgets/profile_detail.dart';
import 'package:koruko_app/presentation/medical_record_manager/widgets/register_profile.dart';
import 'package:koruko_app/presentation/medical_record_manager/widgets/update_profile.dart';
import 'package:koruko_app/presentation/register/view/register.dart';
import 'package:koruko_app/presentation/register_calender/register_calender.dart';
import 'package:koruko_app/presentation/register_calender/widgets/payment.dart';
import 'package:koruko_app/presentation/splash/view/splash.dart';

class AppRouter {
  AppRouter._();

  static GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: RouterPath.splash,
        builder: (BuildContext context, GoRouterState state) {
          return const SplashScreen();
        },
      ),
      GoRoute(
        path: RouterPath.login,
        builder: (BuildContext context, GoRouterState state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: RouterPath.home,
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: RouterPath.register,
        builder: (BuildContext context, GoRouterState state) {
          return const RegisterScreen();
        },
      ),
      GoRoute(
        path: RouterPath.listMedicalClinic,
        builder: (BuildContext context, GoRouterState state) {
          return const ListMedicalClinic();
        },
      ),
      GoRoute(
        path: RouterPath.listProfile,
        builder: (BuildContext context, GoRouterState state) {
          return const MedicalListProfile();
        },
      ),
      GoRoute(
        path: RouterPath.registerProfile,
        builder: (BuildContext context, GoRouterState state) {
          return const RegisterProfile();
        },
      ),
      GoRoute(
        path: RouterPath.updateProfile,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return UpdateProfile(
            profileId: id,
          );
        },
      ),
      GoRoute(
        path: RouterPath.profileDetail,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ProfilePage(
            profileId: id,
          );
        },
      ),
      GoRoute(
        path: RouterPath.registerCalender,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return RegisterCalender(
            medicalId: id,
          );
        },
      ),
      GoRoute(
        path: RouterPath.appointment,
        builder: (context, state) {
          return const AppointmentScreen();
        },
      ),
      GoRoute(
        path: RouterPath.admin,
        builder: (context, state) {
          return const AdminScreen();
        },
      ),
      GoRoute(
        path: RouterPath.payment,
        builder: (context, state) {
          return const VNPayPayment();
        },
      ),
      GoRoute(
        path: RouterPath.cashier,
        builder: (context, state) {
          return const CashierScreen();
        },
      ),
       GoRoute(
        path: RouterPath.example,
        builder: (context, state) {
          return const ExampleScreen();
        },
      ),
       GoRoute(
        path: RouterPath.introduce,
        builder: (context, state) {
          return const IntroDuceScreen();
        },
      ),
    ],
  );
}
