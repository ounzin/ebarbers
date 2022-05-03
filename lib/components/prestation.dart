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

class Prestation extends StatefulWidget {
  int? idPrestation;
  int? duration;
  int? price;
  String? title;
  String? description;
  String? categoryImageUrl;
  Prestation(
      {Key? key,
      required this.idPrestation,
      required this.duration,
      required this.price,
      required this.title,
      required this.description,
      required this.categoryImageUrl})
      : super(key: key);

  @override
  State<Prestation> createState() => _PrestationState();
}

class _PrestationState extends State<Prestation> {
  List? employees;
  int? lengthEmployees;
  int? idClient;

  _loadEmployees() async {
    Map? data = await getEmployees();
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? id = await storage.read(key: 'idClient');

    setState(() {
      idClient = int.parse(id!);
      employees = data['data'];
      lengthEmployees = employees!.length;
    });
  }

  @override
  void initState() {
    _loadEmployees();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          padding: EdgeInsets.all(3.w),
          child: ListView(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            children: [
              // pop button
              new Row(
                children: [
                  new InkWell(
                      onTap: () => Navigator.pop(context),
                      child: new CircleAvatar(
                        backgroundColor: colors.primary_color,
                        child: Icon(Icons.chevron_left, color: Colors.white),
                      )),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 1.5.h, 0, 1.5.h),
              ),
              // Categorie picture, prestation title, duration and price
              new Container(
                height: 35.h,
                decoration: BoxDecoration(
                    color: colors.primary_color.withOpacity(0.8),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: new Column(children: [
                  new Container(
                    margin: EdgeInsets.fromLTRB(0, 3.8.w, 0, 0),
                    child: CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(widget.categoryImageUrl!),
                        radius: 75,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 1.h, 0, 1.h),
                  ),
                  new Center(
                    child: new Text(
                      widget.title!,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 1.h, 0, 1.h),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(3.w, 0, 3.w, 0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        new Text(
                          "${widget.duration}H 00",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600),
                        ),
                        new Text("${widget.price} " + strings.currencySymbol,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w800,
                            ))
                      ],
                    ),
                  )
                ]),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 1.5.h, 0, 1.5.h),
              ),

              new Text(
                "Description",
                style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 1.h, 0, 1.h),
              ),
              //description
              new Text(widget.description!),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 1.h, 0, 1.h),
              ),

              //button reserver
              new Container(
                margin: EdgeInsets.fromLTRB(3.h, 0, 3.h, 0),
                child: new ElevatedButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          EdgeInsets.fromLTRB(0, 2.h, 0, 2.h)),
                      backgroundColor:
                          MaterialStateProperty.all(colors.primary_color)),
                  child: new Text("Choisir prestataire"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EmployeeSelect(
                                employees: employees,
                                idClient: idClient,
                                idPrestation: widget.idPrestation,
                              )),
                    );
                  },
                ),
              )
            ],
          )),
    );
  }

  Future<Map> getEmployees() async {
    String apiUrl = strings.employeeApiUrl +
        '?filters[role][' +
        '\$' +
        'eq]=Employe&populate=*';
    http.Response response = await http.get(Uri.parse(apiUrl));
    return json.decode(response.body);
  }
}
