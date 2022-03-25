// ignore_for_file: avoid_unnecessary_containers, unnecessary_new, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:validators/validators.dart';

//

import '../../assets/strings.dart' as strings;
import '../../assets/colors.dart' as colors;

class FormationTile extends StatefulWidget {
  const FormationTile({Key? key}) : super(key: key);

  @override
  State<FormationTile> createState() => _FormationTileState();
}

class _FormationTileState extends State<FormationTile> {
  @override
  Widget build(BuildContext context) {
    return new Card(
        margin: EdgeInsets.all(2.w),
        color: colors.primary_color,
        elevation: 05,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        child: new InkWell(
          onTap: () {},
          child: new Container(
            height: 14.5.h, // <- to remove ?
            margin: EdgeInsets.fromLTRB(0, 0.5.w, 0, 0.5.w),
            child: new Column(children: [
              new Row(
                children: [
                  new Container(
                      margin: EdgeInsets.all(3.w),
                      child: new Center(
                          child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          backgroundImage: AssetImage("images/logo.png"),
                          radius: 48,
                        ),
                      ))),
                  new Padding(
                    padding: EdgeInsets.fromLTRB(1.w, 0, 1.w, 0),
                  ),
                  //
                  new Flexible(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        new Text(
                          "null",
                          overflow: TextOverflow.ellipsis,
                          style:
                              TextStyle(fontSize: 10.sp, color: Colors.white),
                        ),
                        new Padding(
                          padding: EdgeInsets.fromLTRB(1.w, 0, 1.w, 0),
                        ),
                        new Row(
                          children: [
                            new Icon(
                              Icons.public,
                              color: Colors.white,
                              size: 1.2.h,
                            ),
                            new Padding(
                              padding: EdgeInsets.fromLTRB(1.w, 0, 1.w, 0),
                            ),
                            new Text(
                              "null store",
                              style: TextStyle(
                                  fontSize: 08.sp, color: Colors.white),
                            )
                          ],
                        ),
                        new Container(
                            padding: EdgeInsets.fromLTRB(0, 3.w, 0, 0),
                            alignment: Alignment.centerLeft,
                            child: new GlassmorphicContainer(
                                width: 20.w,
                                height: 2.5.h,
                                borderRadius: 50,
                                blur: 30,
                                alignment: Alignment.center,
                                border: 1,
                                linearGradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFFffffff).withOpacity(0.1),
                                      Color(0xFFFFFFFF).withOpacity(0.05),
                                    ],
                                    stops: const [
                                      0.1,
                                      1,
                                    ]),
                                borderGradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFffffff).withOpacity(0.5),
                                    Color((0xFFFFFFFF)).withOpacity(0.5),
                                  ],
                                ),
                                child: new Text("null",
                                    style: TextStyle(
                                        fontSize: 8.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white)))),
                      ],
                    ),
                  ),
                  new Container(
                    child: new Center(
                        child: Icon(
                      Icons.chevron_right,
                      size: 18.sp,
                      color: Colors.white,
                    )),
                  ),
                  new Padding(
                    padding: EdgeInsets.fromLTRB(1.w, 0, 4.w, 0),
                  ),
                ],
              )
            ]),
          ),
        ));
  }
}
