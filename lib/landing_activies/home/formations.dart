// ignore_for_file: avoid_unnecessary_containers, unnecessary_new, prefer_const_constructors

import 'dart:convert';

import 'package:ebarber/containers/formation_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sizer/sizer.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:validators/validators.dart';

//
import 'package:http/http.dart' as http;
import '../../assets/strings.dart' as strings;
import '../../assets/colors.dart' as colors;

class Formations extends StatefulWidget {
  const Formations({Key? key}) : super(key: key);

  @override
  State<Formations> createState() => _FormationsState();
}

class _FormationsState extends State<Formations> {
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
    buyedFormations = await getBuyedFormations(idClient!);
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
        child: new ListView(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 1.h, 0, 1.h),
            ),
            new Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: 40.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      image: new DecorationImage(
                          image: AssetImage("images/cover-formation.jpg"),
                          fit: BoxFit.cover)),
                ),
                // gradient box
                Container(
                  height: 25.h,
                  alignment: Alignment(0, 0.35),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.center,
                        colors: [
                          Colors.white.withOpacity(0),
                          colors.primary_color.withOpacity(.95)
                        ]),
                  ),
                  child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        new Text(
                          "Nos formations",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold),
                        ),
                        new Text(
                          "Des compétences à votre portée !",
                          style:
                              TextStyle(color: Colors.white, fontSize: 12.sp),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 1.h, 0, 1.h),
                        ),
                      ]),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 1.h, 0, 1.h),
            ),
            // Formations liste builder ...
            FutureBuilder(
                future: getFormations(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Padding(
                      padding: EdgeInsets.all(5.w),
                      child: new CircularProgressIndicator(
                          color: colors.primary_color),
                    );
                  }

                  if (snapshot.hasData) {
                    Map? data = snapshot.data as Map?;

                    List? formations;
                    int? lengthFormations;

                    if (data != null) {
                      formations = data['data'];
                      lengthFormations = formations!.length;
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: lengthFormations,
                      itemBuilder: (context, index) {
                        String titleFormation =
                            formations![index]['attributes']['title'];
                        String descriptionFromation =
                            formations[index]['attributes']['title'];
                        String urlCover = strings.host +
                            formations[index]['attributes']['cover']['data']
                                ['attributes']['url'];

                        int priceFormation =
                            formations[index]['attributes']['price'];
                        List videos =
                            formations[index]['attributes']['videos']['data'];
                        int nbrVideos = videos.length;
                        int idFormation = formations[index]['id'];

                        return FormationTile(
                          isBuyed: buyedFormations.contains(idFormation)
                              ? true
                              : false,
                          idFormation: idFormation,
                          nbrVideos: nbrVideos,
                          titleFormation: titleFormation,
                          price: priceFormation,
                          description: descriptionFromation,
                          videos: videos,
                          urlCover: urlCover,
                          buyedFormations: buyedFormations,
                        );
                      },
                    );
                  }
                  return Center(
                    child: Text("null"),
                  );
                })
          ],
        ),
      ),
    );
  }

  Future<Map> getFormations() async {
    String apiUrl = strings.formationApiUrl +
        "?populate[videos][populate]=*&populate[cover][populate]=*";
    http.Response response = await http.get(Uri.parse(apiUrl), headers: {
      'Authorization': 'Bearer $jwt',
    });
    return json.decode(response.body);
  }

  Future<List> getBuyedFormations(String idClient) async {
    String apiUrl = strings.clientsApiUrl +
        "/" +
        idClient +
        '?populate[formations][populate]=*';
    http.Response response = await http.get(Uri.parse(apiUrl), headers: {
      'Authorization': 'Bearer $jwt',
    });
    if (response.statusCode == 200) {
      List<int> idList = [];
      Map body = json.decode(response.body);
      List formations = body['data']['attributes']['formations']['data'];
      for (var i = 0; i < formations.length; i++) {
        idList.add(formations[i]['id']);
      }
      return idList;
    } else {
      return [];
    }
  }
}
