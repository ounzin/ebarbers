import 'dart:async';

import 'package:ebarber/components/employee_select.dart';
import 'package:ebarber/landing_activies/home/landing_home.dart';
import 'package:ebarber/onboarding/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

//
import 'assets/strings.dart' as strings;
import 'assets/colors.dart' as colors;

//
import 'onboarding/sign_in.dart';
import 'containers/category_card.dart';

void main() {
  runApp(Sizer(
    builder: (context, orientation, deviceType) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      return MaterialApp(
        title: 'E-Barber',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Poppins'),
        home: const Home(),
        routes: {
          // Onboarding activities
          'sign_in': (_) => const SignIn(),
          'sign_up': (_) => const SignUp(),

          //landing activities
          'landing_home': (_) => const LandingHome(),

          //containers
          //'category_card': (_) => const CategoryCard(),
          //'employee': (_) => const EmployeeSelect()
        },
      );
    },
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 2500), () {
      Navigator.pushNamed(context, 'landing_home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(color: colors.secondary_color),
      padding: EdgeInsets.all(2.h),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.asset(
          "images/logo.png",
          height: 40.h,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 1.h, 0, 1.h),
        ),
        Text(
          strings.appName,
          style: TextStyle(
              fontSize: 30.sp,
              fontWeight: FontWeight.bold,
              color: colors.primary_color),
        ),
      ]),
    ));
  }
}
