// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sizer/sizer.dart';

//
import '../../assets/strings.dart' as strings;
import '../../assets/colors.dart' as colors;

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("À propos"),
          backgroundColor: colors.primary_color,
        ),
        body: Container(
            padding: EdgeInsets.all(10.w),
            child: ListView(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              children: [
                Text(
                  strings.aboutTeam,
                  style: TextStyle(fontSize: 14.sp),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 1.h, 0, 1.h),
                ),
                // ahmed adjibade
                Card(
                    elevation: 01,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    child: ListTile(
                      onTap: () async {
                        if (!await launch("https://github.com/ounzin")) {
                          throw 'Could not launch link';
                        }
                      },
                      leading: CircleAvatar(
                        backgroundImage: AssetImage("images/ahmed.jpg"),
                      ),
                      trailing: Icon(Icons.link_rounded),
                      title: Text(
                        "Ahmed Adjibade",
                        style: TextStyle(
                            fontSize: 12.sp, fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text(
                        "Github Link",
                        style: TextStyle(fontSize: 10.sp),
                      ),
                    )),
                Divider(),
                // louis gomes
                Card(
                    elevation: 01,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    child: ListTile(
                      onTap: () async {
                        if (!await launch("https://github.com/")) {
                          throw 'Could not launch link';
                        }
                      },
                      leading: CircleAvatar(
                        backgroundImage: AssetImage("images/cool.png"),
                      ),
                      trailing: Icon(Icons.link_rounded),
                      title: Text(
                        "Louis Gomes",
                        style: TextStyle(
                            fontSize: 12.sp, fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text(
                        "Github Link",
                        style: TextStyle(fontSize: 10.sp),
                      ),
                    )),
                Divider(),
                // paul zanaglia
                Card(
                    elevation: 01,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    child: ListTile(
                      onTap: () async {
                        if (!await launch("https://github.com/")) {
                          throw 'Could not launch link';
                        }
                      },
                      leading: CircleAvatar(
                        backgroundImage: AssetImage("images/cool.png"),
                      ),
                      trailing: Icon(Icons.link_rounded),
                      title: Text(
                        "Paul Zanaglia",
                        style: TextStyle(
                            fontSize: 12.sp, fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text(
                        "Github Link",
                        style: TextStyle(fontSize: 10.sp),
                      ),
                    )),

                Padding(
                  padding: EdgeInsets.fromLTRB(0, 3.h, 0, 3.h),
                ),

                Text(
                  "--- Powered by ounzin ---",
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                )
              ],
            )));
  }
}
