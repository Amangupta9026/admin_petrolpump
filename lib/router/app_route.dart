import 'package:adminpetrolpump/local/pref.dart';
import 'package:adminpetrolpump/local/pref_names.dart';
import 'package:adminpetrolpump/screen/change_password.dart';
import 'package:adminpetrolpump/screen/customdate_screen.dart';
import 'package:adminpetrolpump/screen/profile.dart';
import 'package:adminpetrolpump/screen/today.dart';
import 'package:adminpetrolpump/screen/tomorrow.dart';
import 'package:adminpetrolpump/screen/update_data.dart';
import 'package:adminpetrolpump/screen/update_drop_down_value.dart';
import 'package:go_router/go_router.dart';
import '../screen/home.dart';
import '../screen/login.dart';
import 'routes_names.dart';

bool isUserLogin = Prefs.getValue(PrefNames.isLogin) ?? false;

String getInitialRoute() {
  if (isUserLogin) {
    return RouteNames.home;
  } else {
    return RouteNames.login;
  }
}

final appRoute = GoRouter(initialLocation: getInitialRoute(), routes: [
  GoRoute(
      path: RouteNames.login,
      name: RouteNames.login,
      builder: (context, state) {
        return const Login();
      }),
  GoRoute(
      path: RouteNames.home,
      name: RouteNames.home,
      builder: (context, state) {
        return const Home();
      }),
  GoRoute(
      path: RouteNames.apply,
      name: RouteNames.apply,
      builder: (context, state) {
        return const Home();
      }),
  GoRoute(
      path: RouteNames.update,
      name: RouteNames.update,
      builder: (context, state) {
        return const UpdateData();
      }),
  GoRoute(
      path: RouteNames.changePassword,
      name: RouteNames.changePassword,
      builder: (context, state) {
        return const ChangePassword();
      }),
  GoRoute(
      path: RouteNames.profile,
      name: RouteNames.profile,
      builder: (context, state) {
        return const Profile();
      }),
  GoRoute(
      path: RouteNames.today,
      name: RouteNames.today,
      builder: (context, state) {
        return const Today();
      }),
  GoRoute(
      path: RouteNames.yesterday,
      name: RouteNames.yesterday,
      builder: (context, state) {
        return const Tomorrow();
      }),
  GoRoute(
      path: '/customdatescreen/:pickeddate',
      name: RouteNames.customdatescreen,
      builder: (context, state) {
        return CustomDateScreen(
          selectedDate: state.pathParameters['pickeddate'] ?? '',
        );
      }),
  GoRoute(
      path: RouteNames.updateDropDownValue,
      name: RouteNames.updateDropDownValue,
      builder: (context, state) {
        return const UpdateDropDownValue();
      }),
]);
