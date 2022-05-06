// ignore_for_file: avoid_unnecessary_containers, unnecessary_new, prefer_const_constructors, must_be_immutable

import 'dart:async';
import 'dart:convert';
import 'package:ebarber/components/booking_succes.dart';
import 'package:ebarber/components/prestation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

//
import 'package:http/http.dart' as http;
import '../assets/strings.dart' as strings;
import '../assets/colors.dart' as colors;

class SearchPrestation extends StatefulWidget {
  List? prestations;
  int? lengthPrestation;
  SearchPrestation(
      {Key? key, required this.prestations, required this.lengthPrestation})
      : super(key: key);

  @override
  State<SearchPrestation> createState() => _SearchPrestationState();
}

class _SearchPrestationState extends State<SearchPrestation> {
  //
  TextEditingController editingController =
      TextEditingController(); // <- search bar
  List resultFilter = [];
  int lengthResult = 0;

  bool isListDisplay = true;

  _loadingData() {
    resultFilter = [];
    lengthResult = resultFilter.length;
  }

  //function to filter

  _runFilter(String keyword) {
    List? results;

    if (keyword.isEmpty) {
      results = [];
    } else {
      results = widget.prestations!
          .where((element) => element['attributes']['title']
              .toLowerCase()
              .contains(keyword.toLowerCase()))
          .toList();
    }
    setState(() {
      resultFilter = results!;
      lengthResult = results.length;
    });
  }

  @override
  void initState() {
    _loadingData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: new Container(
          padding: EdgeInsets.all(4.w),
          child: new ListView(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            children: [
              new Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                      onChanged: (value) => _runFilter(value),
                      controller: editingController,
                      decoration: InputDecoration(
                          labelText: "Rechercher une prestation",
                          hintText: "Rechercher une prestation",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)))))),
              // memo title and icons
              new Container(
                margin: EdgeInsets.fromLTRB(2.w, 0, 2.w, 0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    new Text(
                      "Résultats",
                      style: TextStyle(
                          fontSize: 12.sp, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),

              new Padding(
                padding: EdgeInsets.all(1.w),
              ),

              new Padding(
                padding: EdgeInsets.all(1.w),
              ),

              new Container(
                  child: lengthResult == 0
                      ? new Column(
                          children: [
                            new Padding(
                              padding: EdgeInsets.fromLTRB(0, 0.5.h, 0, 0.5.h),
                            ),
                            new Text("Aucun résultat ...")
                          ],
                        )
                      : new StatefulBuilder(
                          builder: (context, setState) {
                            return RefreshIndicator(
                                onRefresh: refresher,
                                child: new Column(
                                  children: [
                                    new Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 1.h, 0, 1.h),
                                    ),
                                    new Container(
                                      child: new ListView.builder(
                                        shrinkWrap: true,
                                        physics: ScrollPhysics(),
                                        itemCount: widget.lengthPrestation,
                                        itemBuilder: (context, index) {
                                          int idPrestation =
                                              widget.prestations![index]['id'];

                                          int duration =
                                              widget.prestations![index]
                                                  ['attributes']['duration'];
                                          String description =
                                              widget.prestations![index]
                                                  ['attributes']['description'];

                                          String categoryImageUrl = strings
                                                  .host +
                                              widget.prestations![index]
                                                              ['attributes']
                                                          ['categorie']['data']
                                                      ['attributes']['holder']
                                                  ['data']['attributes']['url'];
                                          //
                                          String titlePrestation =
                                              widget.prestations![index]
                                                  ['attributes']['title'];
                                          int price = widget.prestations![index]
                                              ['attributes']['price'];
                                          return new Card(
                                            elevation: 01,
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: Colors.white),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(10.0),
                                              ),
                                            ),
                                            child: new ListTile(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Prestation(
                                                            idPrestation:
                                                                idPrestation,
                                                            duration: duration,
                                                            price: price,
                                                            title:
                                                                titlePrestation,
                                                            description:
                                                                description,
                                                            categoryImageUrl:
                                                                categoryImageUrl,
                                                          )),
                                                );
                                              },
                                              trailing: Icon(
                                                Icons.visibility,
                                                color: colors.primary_color,
                                              ),
                                              title: new Text(
                                                titlePrestation,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              subtitle: new Text(
                                                price.toString() +
                                                    strings.currencySymbol,
                                                overflow: TextOverflow.ellipsis,
                                                style:
                                                    TextStyle(fontSize: 10.sp),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ));
                          },
                        ))
            ],
          )),
    );
  }

  //
  Future<void> refresher() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {});
  }
}
