// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sizer/sizer.dart';

//
import 'package:http/http.dart' as http;
import '../../assets/strings.dart' as strings;
import '../../assets/colors.dart' as colors;

class Billing extends StatefulWidget {
  const Billing({Key? key}) : super(key: key);

  @override
  State<Billing> createState() => _BillingState();
}

class _BillingState extends State<Billing> {
  String? jwt;
  String? idClient;
  List buyedFormations = [];

  _loadingData() async {
    FlutterSecureStorage storage = new FlutterSecureStorage();
    var jwtValue = await storage.read(key: 'jwt');
    var idValue = await storage.read(key: 'idClient');

    setState(() {
      jwt = jwtValue;
      idClient = idValue;
    });
  }

  @override
  void initState() {
    _loadingData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes achats"),
        backgroundColor: colors.primary_color,
      ),
      body: Container(
          padding: EdgeInsets.fromLTRB(2.w, 5.w, 2.w, 0),
          child:
              ListView(shrinkWrap: true, physics: ScrollPhysics(), children: [
            FutureBuilder(
              future: getBilling(idClient!),
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
                  Map? data = snapshot.data as Map?;
                  List achats = [];
                  int lengthAchats = 0;

                  if (data != null) {
                    achats = data['data'];
                    lengthAchats = achats.length;
                  }

                  if (lengthAchats == 0) {
                    return Text(
                      "C'est bien vide par ici ...",
                      textAlign: TextAlign.center,
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: lengthAchats,
                      itemBuilder: (context, index) {
                        String title = achats[index]['attributes']['formation']
                            ['data']['attributes']['title'];
                        int price = achats[index]['attributes']['formation']
                            ['data']['attributes']['price'];
                        String date = achats[index]['attributes']['date'];

                        return Container(
                          child: Column(children: [
                            Card(
                              elevation: 1,
                              child: ListTile(
                                title: Text(title),
                                subtitle: Text(date),
                                trailing: Text(
                                    price.toString() + strings.currencySymbol),
                              ),
                            ),
                            if (index != (lengthAchats - 1)) Divider()
                          ]),
                        );
                      },
                    );
                  }
                }
                return Center(
                  child: CircularProgressIndicator(), // <- error API :: to mod
                ); // <- future builder outpoint (else)
              },
            )
          ])),
    );
  }

  Future<Map> getBilling(String idClient) async {
    String apiUrl = strings.sellsApiUrl +
        "?filters[client][id][" +
        "\$" +
        "eq]=" +
        idClient +
        "&populate=*";
    http.Response response = await http.get(Uri.parse(apiUrl));
    return json.decode(response.body);
  }
}
