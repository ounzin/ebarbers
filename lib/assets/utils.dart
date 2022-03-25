// My custom Widget and functions Library

// ignore_for_file: unnecessary_new

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

//
import '../../assets/colors.dart' as colors;
import '../../assets/strings.dart' as strings;

Widget landingBody(Widget topBar, Widget childrenBody) {
  return Container(
      margin: EdgeInsets.fromLTRB(2.h, 0.5.h, 2.h, 0),
      child: new StatefulBuilder(
        builder: ((context, setState) {
          return ListView(
            children: [topBar, childrenBody],
          );
        }),
      ));
}
