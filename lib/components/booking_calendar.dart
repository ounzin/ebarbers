// ignore_for_file: avoid_unnecessary_containers, unnecessary_new, prefer_const_constructors, must_be_immutable

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

//
import 'package:http/http.dart' as http;
import '../assets/strings.dart' as strings;
import '../assets/colors.dart' as colors;

class BookingCalendar extends StatefulWidget {
  int? idClient;
  int? idEmployee;
  Map? avalaible;
  BookingCalendar(
      {Key? key,
      required this.idClient,
      required this.idEmployee,
      required this.avalaible})
      : super(key: key);

  @override
  State<BookingCalendar> createState() => _BookingCalendarState();
}

class _BookingCalendarState extends State<BookingCalendar> {
  final Locale frenchLanguage = Locale('fr', 'FR');
  final format = DateFormat("yyyy-MM-dd");
  TextEditingController? reservationDate;
  int selectedCardIndex = -1;

  @override
  void initState() {
    super.initState();
    String now = DateFormat("yyyy-MM-dd").format(DateTime.now());
    reservationDate = TextEditingController(text: now);
  }

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
            new Text(
              "Selectionnez une date et un créneau",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.sp),
              overflow: TextOverflow.clip,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 1.5.h, 0, 1.5.h),
            ),

            // end date
            DateTimeField(
              format: format,
              onChanged: (date) {
                setState(() {});
              },
              initialValue: DateTime.now(),
              controller: reservationDate,
              decoration: InputDecoration(
                label: Text("Choisir une date"),
                border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                  Radius.circular(10.0),
                )),
              ),
              onShowPicker: (context, currentValue) async {
                return showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    helpText: 'DATE DE RESERVATION',
                    locale: frenchLanguage,
                    cancelText: 'ANNULER',
                    initialDate:
                        currentValue ?? DateTime.now().add(Duration(days: 1)),
                    lastDate: DateTime(2100));
              },
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(0, 1.5.h, 0, 1.5.h),
            ),

            FutureBuilder(
              future: getEmployeeReservationsOnDate(
                  widget.idEmployee!, reservationDate!.text.toString()),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Container(
                      alignment: Alignment.center,
                      child: new Center(
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(),
                            new Padding(
                              padding: EdgeInsets.all(1.h),
                            ),
                            new Text(strings.loadingDataText),
                            new Padding(
                              padding: EdgeInsets.all(1.h),
                            ),
                            new ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      colors.primary_color)),
                              child: new Text(strings.labelGoBack),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                      ));
                }
                if (snapshot.hasError) {
                  return Container(
                    child: Center(
                      child:
                          CircularProgressIndicator(), // <- error API :: error Connexion
                    ),
                  );
                }

                if (snapshot.hasData) {
                  Map available = widget.avalaible!;
                  String date = reservationDate!.text.toString();
                  String todayName =
                      DateFormat('EEEE').format(DateTime.parse(date));

                  if (!available.containsKey(todayName)) {
                    return Center(
                      child:
                          Text("Il n'y a pas de disponibilité pour ce jour !"),
                    );
                  } else {
                    Map data = snapshot.data as Map;
                    List reservations = data['data'];
                    List locked = [];
                    List timeAvalaibleDay = available[todayName];
                    int lengthAvalaible = timeAvalaibleDay.length;
                    List<bool> isTimeSelected =
                        List.generate(lengthAvalaible, ((index) => false));

                    //construire une liste de plage déjà prises
                    for (int i = 0; i < reservations.length; i++) {
                      String time = reservations[i]['attributes']['time'];
                      List tmp = time.split(':');
                      int first = int.parse(tmp[0]);
                      if (first < 10) {
                        locked.add(first - 10 + 10);
                      } else {
                        locked.add(first);
                      }
                    }

                    return SizedBox(
                      height: 50.h,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 3.w,
                            crossAxisCount: 3,
                            crossAxisSpacing: 3.w),
                        itemCount: lengthAvalaible,
                        itemBuilder: (context, index) {
                          int hour = timeAvalaibleDay[index];
                          if (!locked.contains(hour)) {
                            return StatefulBuilder(
                              builder: ((context, setState) {
                                return InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedCardIndex = index;
                                      });
                                    },
                                    child: Card(
                                        elevation: 2,
                                        child: Container(
                                          alignment: Alignment.center,
                                          color: selectedCardIndex == index
                                              ? colors.primary_color
                                              : null,
                                          child: Text(
                                            hour.toString() + "h",
                                            style: TextStyle(
                                                color:
                                                    selectedCardIndex == index
                                                        ? Colors.white
                                                        : null),
                                          ),
                                        )));
                              }),
                            );
                          }
                          return Text("");
                        },
                      ),
                    );
                  }
                }

                return Center(
                  child: CircularProgressIndicator(), // <- error API :: to mod
                ); // <- future builder outpoint (else)
              },
            )
          ],
        ),
      ),
    );
  }

  Future<Map> getEmployeeReservationsOnDate(int idEmployee, String date) async {
    String apiUrl = strings.reservationsApiUrl +
        '?filters[employee][id][' +
        '\$' +
        'eq]=' +
        idEmployee.toString() +
        '&filters[date][' +
        '\$' +
        'eq]=' +
        date;

    http.Response response = await http.get(Uri.parse(apiUrl));
    return json.decode(response.body);
  }

  List<bool> isSelectedUpdater(int index, List<bool> elements) {
    List<bool> res = elements;
    for (var i = 0; i < elements.length; i++) {
      index == i ? res[i] = true : res[i] = false;
    }
    return res;
  }

  bool allFalse(List<bool> elements) {
    for (var i = 0; i < elements.length; i++) {
      if (elements[i] == true) return false;
    }
    return true;
  }
}
