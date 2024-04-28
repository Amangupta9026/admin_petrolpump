import 'dart:developer';

import 'package:adminpetrolpump/local/pref.dart';
import 'package:adminpetrolpump/local/pref_names.dart';
import 'package:adminpetrolpump/riverpod/login_notifier.dart';
import 'package:adminpetrolpump/router/routes_names.dart';
import 'package:adminpetrolpump/utils/colors.dart';
import 'package:adminpetrolpump/widget/textformfield_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {

  void checkLogin() {
    if (Prefs.getValue(PrefNames.isLogin) == true) {
      log('logined');
    } else {
      context.pushReplacement(RouteNames.login);
     // log('not login');
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
              'Profile',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('changepassword')
                        .get(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      var alldata = snapshot.data?.docs;
                      log(alldata?[0]['changepassword'].toString() ??
                          'data not found');

                      if (!snapshot.hasData) {
                        return const Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 60),
                              CircularProgressIndicator(),
                            ],
                          ),
                        );
                      }

                      return Column(
                        children: [
                          CustomTextFormField(
                              readOnly: true,
                              labelText: 'Email id',
                              hintText: 'Enter email id',
                              controller: TextEditingController(
                                  text: alldata?[0]['email'].toString()),
                              keyboardType: TextInputType.emailAddress),
                          const SizedBox(height: 20),
                          // CustomTextFormField(
                          //     readOnly: true,
                          //     labelText: 'Password:',
                          //     hintText: 'Password',
                          //     controller: TextEditingController(
                          //         text:
                          //             alldata?[0]['changepassword'].toString()),
                          //     keyboardType: TextInputType.number),
                          const SizedBox(height: 20),
                        ],
                      );
                    }),
                const SizedBox(height: 40),
              ],
            ),
          ]),
        )),
      ),
    );
  }
}
