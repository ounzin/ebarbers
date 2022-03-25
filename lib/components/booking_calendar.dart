// ignore_for_file: avoid_unnecessary_containers, unnecessary_new, prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'package:ebarber/components/employee_select.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sizer/sizer.dart';

//
import 'package:http/http.dart' as http;
import '../assets/strings.dart' as strings;
import '../assets/colors.dart' as colors;

class BookingCalendar extends StatefulWidget {
  int? idClient;
  int? idEmployee;
  BookingCalendar({Key? key, required this.idClient, required this.idEmployee})
      : super(key: key);

  @override
  State<BookingCalendar> createState() => _BookingCalendarState();
}

class _BookingCalendarState extends State<BookingCalendar> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: new Container(
        padding: EdgeInsets.all(5.w),
        child: ListView(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          children: [
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                new Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: colors.primary_color),
                      color: colors.primary_color,
                      borderRadius: BorderRadius.circular(100)),
                  padding: EdgeInsets.all(1.w),
                  child: new InkWell(
                    onTap: () => Navigator.pop(context), // <- previous activity
                    child: new Icon(
                      Icons.chevron_left_outlined,
                      size: 25.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
                // chevron and dot to follow
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    new Text(
                      "●",
                      style: new TextStyle(
                          fontSize: 20.sp,
                          color: colors.primary_color.withOpacity(0.4)),
                    ),
                    new Padding(
                      padding: EdgeInsets.fromLTRB(0.2.h, 0, 0.2.h, 0),
                    ),
                    new Text(
                      "●",
                      style: new TextStyle(
                          fontSize: 20.sp, color: colors.primary_color),
                    ),
                    new Padding(
                      padding: EdgeInsets.fromLTRB(0.2.h, 0, 0.2.h, 0),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 1.5.h, 0, 1.5.h),
            ),
          ],
        ),
      ),
    );
  }
}
