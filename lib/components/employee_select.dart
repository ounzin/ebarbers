// ignore_for_file: avoid_unnecessary_containers, unnecessary_new, prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'package:ebarber/components/booking_calendar.dart';
import 'package:ebarber/components/prestation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

//
import 'package:http/http.dart' as http;
import '../assets/strings.dart' as strings;
import '../assets/colors.dart' as colors;

class EmployeeSelect extends StatefulWidget {
  List? employees;
  int? idClient;
  int? idPrestation;
  EmployeeSelect(
      {Key? key,
      required this.employees,
      required this.idClient,
      required this.idPrestation})
      : super(key: key);

  @override
  State<EmployeeSelect> createState() => _EmployeeSelectState();
}

class _EmployeeSelectState extends State<EmployeeSelect> {
  List? employees;
  int? lengthEmployees;
  int val = 1;
  String? nomEmployee;
  _loadData() async {
    setState(() {
      employees = widget.employees;
      lengthEmployees = employees!.length;
    });
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: new Container(
          padding: EdgeInsets.all(5.w),
          child: new ListView(
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
                      onTap: () =>
                          Navigator.pop(context), // <- previous activity
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
                            fontSize: 20.sp, color: colors.primary_color),
                      ),
                      new Padding(
                        padding: EdgeInsets.fromLTRB(0.2.h, 0, 0.2.h, 0),
                      ),
                      new Text(
                        "●",
                        style: new TextStyle(
                            fontSize: 20.sp,
                            color: colors.primary_color.withOpacity(0.4)),
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
              new Text(
                "Selectionnez un prestatiare pour votre réservation ...",
                style: TextStyle(fontSize: 15.sp),
                overflow: TextOverflow.clip,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 2.h, 0, 2.h),
              ),
              // Employees radio displayer...
              new SizedBox(
                height: 50.h,
                child: new StatefulBuilder(
                  builder: (context, setState) {
                    List<bool> isCheckedRadioList = List.generate(
                        lengthEmployees!, (_) => false,
                        growable: false);
                    if (lengthEmployees == 0) {
                      return new Text("Aucun employee disponible !");
                    } else {
                      nomEmployee = employees![0]['attributes']['name'];
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: lengthEmployees,
                        itemBuilder: (context, index) {
                          String employeeName =
                              employees![index]['attributes']['name'];
                          int idEmployee = employees![index]['id'];
                          //

                          return ListTile(
                              title: Text(employeeName),
                              leading: new StatefulBuilder(
                                builder: (context, setState) {
                                  return Radio(
                                    value: idEmployee,
                                    groupValue: val,
                                    onChanged: (int? value) {
                                      if (isCheckedRadioList[index] == true) {
                                        setState(() {
                                          val = value!;
                                        });
                                      } else {
                                        setState(() {
                                          val = value!;
                                          nomEmployee = employeeName;
                                          _checkedListUpdater(
                                              isCheckedRadioList, value);
                                        });
                                      }
                                    },
                                    activeColor: colors.primary_color,
                                  );
                                },
                              ));
                        },
                      );
                    }
                  },
                ),
              ),
              //button choose date
              new Container(
                margin: EdgeInsets.fromLTRB(3.h, 0, 3.h, 0),
                child: new ElevatedButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          EdgeInsets.fromLTRB(0, 2.h, 0, 2.h)),
                      backgroundColor:
                          MaterialStateProperty.all(colors.primary_color)),
                  child: new Text("Choisir date et heure"),
                  onPressed: () {
                    Map availability =
                        widget.employees![val]['attributes']['availability'];

                    Map avalaible = {};
                    availability.forEach((k, v) {
                      if (v != "null") {
                        List interval = v.split('-');
                        List elements = [];

                        int start = int.parse(interval[0]);
                        int end = int.parse(interval[1]);
                        for (int i = start; i < end; i++) {
                          elements.add(i);
                        }
                        avalaible[k] = elements;
                      }
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BookingCalendar(
                                idClient: widget.idClient,
                                idEmployee: val,
                                nomEmployee: nomEmployee,
                                idPrestation: widget.idPrestation,
                                avalaible: avalaible,
                              )),
                    );
                  },
                ),
              )
            ],
          )),
    );
  }

  _checkedListUpdater(List<bool> values, int index) {
    List<bool> resultat = values;

    for (int i = 0; i < values.length; i++) {
      if (i != index) {
        resultat[i] = false;
      } else {
        resultat[i] = true;
      }
    }
    setState(() {
      values = resultat;
    });
  }
}
