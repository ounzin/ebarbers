// ignore_for_file: avoid_unnecessary_containers, unnecessary_new, prefer_const_constructors, must_be_immutable

import 'dart:async';
import 'dart:convert';
import 'package:ebarber/components/booking_succes.dart';
import 'package:ebarber/components/search_prestation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

//
import 'package:http/http.dart' as http;
import '../assets/strings.dart' as strings;
import '../assets/colors.dart' as colors;

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Rechercher une prestation"),
          backgroundColor: colors.primary_color,
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(0, 2.w, 0, 0),
          child: ListView(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            children: [
              FutureBuilder(
                future: getPrestations(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Container(
                        alignment: Alignment.center,
                        child: new Center(
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              new CircularProgressIndicator(),
                              new Padding(
                                padding: EdgeInsets.all(1.h),
                              ),
                              new Text(strings.loadingDataText),
                              new Padding(
                                padding: EdgeInsets.all(1.h),
                              ),
                              new ElevatedButton(
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
                      child: new Center(
                        child:
                            new CircularProgressIndicator(), // <- error API :: error Connexion
                      ),
                    );
                  }
                  if (snapshot.hasData) {
                    Map? data = snapshot.data as Map;
                    List prestations = data['data'];

                    int promotersLength = prestations.length;
                    //
                    return SearchPrestation(
                      prestations: prestations,
                      lengthPrestation: promotersLength,
                    );
                  }

                  return Container(
                    child: new Center(
                      child:
                          new CircularProgressIndicator(), // <- error API :: to mod
                    ),
                  ); // <- future builder outpoint (else)
                },
              ),
            ],
          ),
        ));
  }

  Future<Map> getPrestations() async {
    String apiUrl =
        strings.prestationsApiUrl + "?populate[categorie][populate]=*";
    http.Response response = await http.get(Uri.parse(apiUrl));
    return json.decode(response.body);
  }
}
