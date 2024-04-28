import 'dart:developer';

import 'package:adminpetrolpump/local/pref.dart';
import 'package:adminpetrolpump/local/pref_names.dart';
import 'package:adminpetrolpump/riverpod/login_notifier.dart';
import 'package:adminpetrolpump/router/routes_names.dart';
import 'package:adminpetrolpump/utils/colors.dart';
import 'package:adminpetrolpump/widget/textformfield_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ChangePassword extends ConsumerStatefulWidget {
  const ChangePassword({super.key});

  @override
  ConsumerState<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends ConsumerState<ChangePassword> {

  void checkLogin() {
    if (Prefs.getValue(PrefNames.isLogin) == true) {
      log('logined');
    } else {
      context.pushReplacement(RouteNames.login);
    }
  }

  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final refRead = ref.read(homeNotifierProvider.notifier);
    final refWatch = ref.watch(homeNotifierProvider);
    return Scaffold(
      backgroundColor: whiteBackgroundColor,
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
            PointerDeviceKind.trackpad,
            PointerDeviceKind.unknown,
            PointerDeviceKind.invertedStylus,
            PointerDeviceKind.stylus
          },
        ),
        child: SafeArea(
            child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text(
              'Change Credentials',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 20),
            CustomTextFormField(
                labelText: 'Email id',
                hintText: 'Enter email id',
                controller: refWatch.value?.changeEmailController,
                keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 20),
            CustomTextFormField(
                labelText: 'Change Password:',
                hintText: 'Change Password',
                controller: refWatch.value?.changePasswordController,
                keyboardType: TextInputType.number),
            const SizedBox(height: 20),
            CustomTextFormField(
                labelText: 'Confirm Change Password:',
                hintText: 'Confirm Change Password:',
                controller: refWatch.value?.changeConfirmPasswordController,
                keyboardType: TextInputType.number),
            const SizedBox(height: 40),
            Center(
              child: InkWell(
                onTap: () {
                  refRead.onChangePasswordSubmit(context);
                },
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 52,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: const Center(
                      child: Text(
                        'Submit',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    )),
              ),
            ),
          ]),
        )),
      ),
    );
  }
}
