import 'dart:developer';

import 'package:adminpetrolpump/local/pref.dart';
import 'package:adminpetrolpump/local/pref_names.dart';
import 'package:adminpetrolpump/riverpod/login_notifier.dart';
import 'package:adminpetrolpump/router/routes_names.dart';
import 'package:adminpetrolpump/utils/colors.dart';
import 'package:adminpetrolpump/widget/alertdialogbox.dart';
import 'package:adminpetrolpump/widget/responsive_devices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterflow_paginate_firestore/paginate_firestore.dart';
import 'package:go_router/go_router.dart';

//yesterday
class Tomorrow extends ConsumerStatefulWidget {
  const Tomorrow({super.key});

  @override
  ConsumerState<Tomorrow> createState() => _TomorrowState();
}

class _TomorrowState extends ConsumerState<Tomorrow> {
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
    int totallength;
    final refRead = ref.read(homeNotifierProvider.notifier);
    DateTime now = DateTime.now();
    DateTime yesterday = DateTime(now.year, now.month, now.day - 1);
    Query<Map<String, dynamic>> length1 = FirebaseFirestore.instance
        .collection('queryForm')
        .orderBy('servertime', descending: true)
        .where('servertime', isGreaterThanOrEqualTo: yesterday)
        .where('servertime',
            isLessThan: yesterday.add(const Duration(days: 1)));
    length1.get().then((value) {
      totallength = value.docs.length;
      //  sta = AsyncData(totallength);
    });

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
            child: Column(
              children: [
                if (Responsive.isDesktop(context))
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(40.0, 20, 40, 60),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  PopupMenuButton<int>(
                                    tooltip: 'Filter',
                                    itemBuilder: (context) => [
                                      // PopupMenuItem 1
                                      const PopupMenuItem(
                                        value: 1,
                                        // row with 2 children
                                        child: Text(
                                          "Today",
                                          style: TextStyle(
                                              color: whiteBackgroundColor,
                                              fontSize: 18),
                                        ),
                                      ),
                                      // PopupMenuItem 2
                                      const PopupMenuItem(
                                        value: 2,
                                        // row with two children
                                        child: Text(
                                          "Yesterday",
                                          style: TextStyle(
                                              color: whiteBackgroundColor,
                                              fontSize: 18),
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 3,
                                        // row with two children
                                        child: Text(
                                          "Custom",
                                          style: TextStyle(
                                              color: whiteBackgroundColor,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ],
                                    offset: const Offset(0, 40),
                                    icon: const Icon(Icons.filter_list),
                                    color: Colors.black,

                                    elevation: 2,
                                    // on selected we show the dialog box
                                    onSelected: (value) {
                                      // if value 1 show dialog
                                      if (value == 1) {
                                        context.pushNamed(RouteNames.today);
                                      } else if (value == 2) {
                                        context.pushNamed(RouteNames.yesterday);
                                      } else if (value == 3) {
                                        refRead.selectDate(context);
                                      }
                                    },
                                  ),
                                  const SizedBox(width: 20),
                                  InkWell(
                                    onTap: () {
                                      context.pushNamed(RouteNames.home);
                                    },
                                    child: const Text(
                                      'All Records',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: textColor),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      context.pushNamed(RouteNames.login);
                                    },
                                    child: const Text(
                                      'Logout',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: textColor),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Divider(
                            thickness: 1,
                            color: Colors.grey[200],
                          ),
                          const SizedBox(height: 20),
                          // Align(
                          //   alignment: Alignment.bottomRight,
                          //   child: Text('Total Records: $totallength Records',
                          //       style: const TextStyle(
                          //           color: textColor,
                          //           fontSize: 16,
                          //           fontWeight: FontWeight.bold)),
                          // ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: PaginateFirestore(
                                itemBuilderType: PaginateBuilderType
                                    .listView, //Change types accordingly

                                // orderBy is compulsory to enable pagination
                                query: FirebaseFirestore.instance
                                    .collection('queryForm')
                                    .orderBy('servertime', descending: true)
                                    .where('servertime',
                                        isGreaterThanOrEqualTo: yesterday)
                                    .where('servertime',
                                        isLessThan: yesterday
                                            .add(const Duration(days: 1))),
                                itemsPerPage: 10,
                                // to fetch real-time data
                                // isLive: true,
                                allowImplicitScrolling: true,
                                // bottomLoader: const Center(
                                //   child: CircularProgressIndicator(),
                                // ),
                                itemBuilder:
                                    (context, documentSnapshots, index) {
                                  final form =
                                      documentSnapshots[index].data() as Map?;
                                  DateTime date =
                                      DateTime.fromMicrosecondsSinceEpoch(
                                          (form?['servertime'] as Timestamp)
                                              .microsecondsSinceEpoch);
                                  final datetrim = date.toString();

                                  String trimDateTime(String datetrim) {
                                    final timestamp = DateTime.parse(datetrim);
                                    final trimmedDateTime = DateTime(
                                        timestamp.year,
                                        timestamp.month,
                                        timestamp.day,
                                        timestamp.hour,
                                        timestamp.minute);
                                    final trimmedTimestamp =
                                        Timestamp.fromDate(trimmedDateTime);
                                    return trimmedTimestamp.toDate().toString();
                                  }

                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              showMyDialog(
                                                  context,
                                                  'Alert!',
                                                  'Are you sure you want to Delete?',
                                                  () async {
                                                    await refRead
                                                        .deleteDocument(
                                                            context,
                                                            form?['email'] ??
                                                                '');
                                                  },
                                                  istwobutton: true,
                                                  actiontap1: () {
                                                    context.pop();
                                                  });
                                            },
                                            child: Icon(Icons.delete,
                                                color: Colors.red
                                                    .withOpacity(0.7)),
                                          ),
                                          const SizedBox(width: 5),
                                          Text(index.toString(),
                                              style: const TextStyle(
                                                  color: textColor,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                          const SizedBox(width: 20),
                                          Expanded(
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      20, 10, 20, 10),
                                              margin: const EdgeInsets.only(
                                                  bottom: 20),
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey[300]!,
                                                    width: 1.0),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        'Name:',
                                                        style: TextStyle(
                                                            color: textColor,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Text(
                                                        form?['name'] ?? '',
                                                        style: const TextStyle(
                                                            color: textColor,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        'Email:',
                                                        style: TextStyle(
                                                            color: textColor,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Expanded(
                                                        child: Text(
                                                          form?['email'] ?? '',
                                                          style: const TextStyle(
                                                              color: textColor,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        'Mobile No.: ',
                                                        style: TextStyle(
                                                            color: textColor,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Text(
                                                        form?['number'] ?? '',
                                                        style: const TextStyle(
                                                            color: textColor,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        'Location:',
                                                        style: TextStyle(
                                                            color: textColor,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Text(
                                                        form?['quantity'] ?? '',
                                                        style: const TextStyle(
                                                            color: textColor,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        'Company:',
                                                        style: TextStyle(
                                                            color: textColor,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Expanded(
                                                        child: Text(
                                                          form?['selected_company'] ??
                                                              '',
                                                          style: const TextStyle(
                                                              color: textColor,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        'Category:',
                                                        style: TextStyle(
                                                            color: textColor,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Expanded(
                                                        child: Text(
                                                          form?['selected_category'] ??
                                                              '',
                                                          style: const TextStyle(
                                                              color: textColor,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        'Application number:',
                                                        style: TextStyle(
                                                            color: textColor,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Expanded(
                                                        child: Text(
                                                          form?['application_number']
                                                                  .toString() ??
                                                              '',
                                                          style: const TextStyle(
                                                              color: textColor,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        'Date:',
                                                        style: TextStyle(
                                                            color: textColor,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Text(
                                                        trimDateTime(datetrim),
                                                        style: const TextStyle(
                                                            color: textColor,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (Responsive.isMobile(context) ||
                    Responsive.isTablet(context))
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 20, 20, 60),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  PopupMenuButton<int>(
                                    tooltip: 'Filter',
                                    itemBuilder: (context) => [
                                      // PopupMenuItem 1
                                      const PopupMenuItem(
                                        value: 1,
                                        // row with 2 children
                                        child: Text(
                                          "Today",
                                          style: TextStyle(
                                              color: whiteBackgroundColor,
                                              fontSize: 18),
                                        ),
                                      ),
                                      // PopupMenuItem 2
                                      const PopupMenuItem(
                                        value: 2,
                                        // row with two children
                                        child: Text(
                                          "Yesterday",
                                          style: TextStyle(
                                              color: whiteBackgroundColor,
                                              fontSize: 18),
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 3,
                                        // row with two children
                                        child: Text(
                                          "Custom",
                                          style: TextStyle(
                                              color: whiteBackgroundColor,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ],
                                    offset: const Offset(0, 40),
                                    icon: const Icon(Icons.filter_list),
                                    color: Colors.black,

                                    elevation: 2,
                                    // on selected we show the dialog box
                                    onSelected: (value) {
                                      // if value 1 show dialog
                                      if (value == 1) {
                                        context.pushNamed(RouteNames.today);
                                      } else if (value == 2) {
                                        context.pushNamed(RouteNames.yesterday);
                                      } else if (value == 3) {
                                        refRead.selectDate(context);
                                      }
                                    },
                                  ),
                                  const SizedBox(width: 20),
                                  InkWell(
                                    onTap: () {
                                      context.pushNamed(RouteNames.home);
                                    },
                                    child: const Text(
                                      'All Records',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: textColor),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          context.pushNamed(RouteNames.login);
                                        },
                                        child: const Text(
                                          'Logout',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: textColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Divider(
                            thickness: 1,
                            color: Colors.grey[200],
                          ),
                          Expanded(
                            child: PaginateFirestore(
                                itemBuilderType: PaginateBuilderType
                                    .listView, //Change types accordingly

                                // orderBy is compulsory to enable pagination
                                query: FirebaseFirestore.instance
                                    .collection('queryForm')
                                    .orderBy('servertime', descending: true)
                                    .where('servertime',
                                        isGreaterThanOrEqualTo: yesterday)
                                    .where('servertime',
                                        isLessThan: yesterday
                                            .add(const Duration(days: 1))),
                                itemsPerPage: 10,
                                // to fetch real-time data
                                // isLive: true,
                                allowImplicitScrolling: true,
                                // bottomLoader: const Center(
                                //   child: CircularProgressIndicator(),
                                // ),
                                itemBuilder:
                                    (context, documentSnapshots, index) {
                                  final form =
                                      documentSnapshots[index].data() as Map?;
                                  DateTime date =
                                      DateTime.fromMicrosecondsSinceEpoch(
                                          (form?['servertime'] as Timestamp)
                                              .microsecondsSinceEpoch);
                                  final datetrim = date.toString();

                                  String trimDateTime(String datetrim) {
                                    final timestamp = DateTime.parse(datetrim);
                                    final trimmedDateTime = DateTime(
                                        timestamp.year,
                                        timestamp.month,
                                        timestamp.day,
                                        timestamp.hour,
                                        timestamp.minute);
                                    final trimmedTimestamp =
                                        Timestamp.fromDate(trimmedDateTime);
                                    return trimmedTimestamp.toDate().toString();
                                  }

                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  showMyDialog(
                                                      context,
                                                      'Alert!',
                                                      'Are you sure you want to Delete?',
                                                      () async {
                                                        await refRead
                                                            .deleteDocument(
                                                                context,
                                                                form?['email'] ??
                                                                    '');
                                                      },
                                                      istwobutton: true,
                                                      actiontap1: () {
                                                        context.pop();
                                                      });
                                                },
                                                child: Icon(Icons.delete,
                                                    color: Colors.red
                                                        .withOpacity(0.7)),
                                              ),
                                              const SizedBox(height: 20),
                                              Text(index.toString(),
                                                  style: const TextStyle(
                                                      color: textColor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          ),
                                          const SizedBox(width: 20),
                                          Expanded(
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      20, 10, 20, 10),
                                              margin: const EdgeInsets.only(
                                                  bottom: 20),
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey[300]!,
                                                    width: 1.0),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        'Name:',
                                                        style: TextStyle(
                                                            color: textColor,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Text(
                                                        form?['name'] ?? '',
                                                        style: const TextStyle(
                                                            color: textColor,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        'Email:',
                                                        style: TextStyle(
                                                            color: textColor,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Expanded(
                                                        child: Text(
                                                          form?['email'] ?? '',
                                                          style: const TextStyle(
                                                              color: textColor,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        'Mobile No.: ',
                                                        style: TextStyle(
                                                            color: textColor,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Text(
                                                        form?['number'] ?? '',
                                                        style: const TextStyle(
                                                            color: textColor,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 20),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        'Location:',
                                                        style: TextStyle(
                                                            color: textColor,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Expanded(
                                                        child: Text(
                                                          form?['quantity'] ??
                                                              '',
                                                          style: const TextStyle(
                                                              color: textColor,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 20),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          const Text(
                                                            'Company:',
                                                            style: TextStyle(
                                                                color:
                                                                    textColor,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          const SizedBox(
                                                              width: 10),
                                                          Text(
                                                            form?['selected_company'] ??
                                                                '',
                                                            style: const TextStyle(
                                                                color:
                                                                    textColor,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Text(
                                                            'Category:',
                                                            style: TextStyle(
                                                                color:
                                                                    textColor,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          const SizedBox(
                                                              width: 10),
                                                          Text(
                                                            form?['selected_category'] ??
                                                                '',
                                                            style: const TextStyle(
                                                                color:
                                                                    textColor,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          const SizedBox(
                                                              width: 20),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 20),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        'Application number:',
                                                        style: TextStyle(
                                                            color: textColor,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Expanded(
                                                        child: Text(
                                                          form?['application_number']
                                                                  .toString() ??
                                                              '',
                                                          style: const TextStyle(
                                                              color: textColor,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        'Date:',
                                                        style: TextStyle(
                                                            color: textColor,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Expanded(
                                                        child: Text(
                                                          trimDateTime(
                                                              datetrim),
                                                          style: const TextStyle(
                                                              color: textColor,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            // }),
          ),
        ));
  }
}
