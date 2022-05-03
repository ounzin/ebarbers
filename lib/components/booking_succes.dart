import 'package:ebarber/landing_activies/home/landing_home.dart';
import 'package:ebarber/landing_activies/home/reservations.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

//
import 'package:http/http.dart' as http;
import '../assets/strings.dart' as strings;
import '../assets/colors.dart' as colors;

class BookingSucces extends StatefulWidget {
  const BookingSucces({Key? key}) : super(key: key);

  @override
  State<BookingSucces> createState() => _BookingSuccesState();
}

class _BookingSuccesState extends State<BookingSucces> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          "Succès 🎉",
          style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
        ),
        Image.asset(
          "images/cool.png",
          width: 30.h,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 1.5.h, 0, 1.5.h),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(3.h, 0, 3.h, 0),
          child: ElevatedButton(
              style: ButtonStyle(
                  textStyle: MaterialStateProperty.all(
                    TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w300),
                  ),
                  padding: MaterialStateProperty.all(
                      EdgeInsets.fromLTRB(5.h, 2.h, 5.h, 2.h)),
                  backgroundColor:
                      MaterialStateProperty.all(colors.primary_color)),
              child: const Text("Retour"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LandingHome()),
                );
              }),
        ),
      ]),
    );
  }
}
