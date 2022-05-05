// ignore_for_file: avoid_unnecessary_containers, unnecessary_new, prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'dart:convert';

import 'package:ebarber/containers/video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sizer/sizer.dart';
import 'package:glassmorphism/glassmorphism.dart';

//

import 'package:http/http.dart' as http;
import '../../assets/strings.dart' as strings;
import '../../assets/colors.dart' as colors;

class FormationPresentation extends StatefulWidget {
  bool? isBuyed;
  int? priceFormation;
  int? idFormation;
  String? titleFormation;
  String? descriptionFormation;
  String? urlCover;
  List? videos;
  List? buyedFormations;

  FormationPresentation(
      {Key? key,
      required this.buyedFormations,
      required this.idFormation,
      required this.isBuyed,
      required this.urlCover,
      required this.priceFormation,
      required this.titleFormation,
      required this.descriptionFormation,
      required this.videos})
      : super(key: key);

  @override
  State<FormationPresentation> createState() => _FormationPresentationState();
}

class _FormationPresentationState extends State<FormationPresentation> {
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
                    onTap: () => Navigator.pop(context), // <- previous activity
                    child: new Icon(
                      Icons.chevron_left_outlined,
                      size: 25.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 1.5.h, 0, 1.5.h),
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
                          image: NetworkImage(widget.urlCover!),
                          fit: BoxFit.cover)),
                ),
                new Padding(
                    padding: EdgeInsets.all(2.w),
                    child: new Column(
                      children: [
                        //title and price
                        new GlassmorphicContainer(
                            width: 40.h,
                            height: 20.h,
                            borderRadius: 20,
                            blur: 10,
                            alignment: Alignment.center,
                            border: 1,
                            linearGradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  colors.primary_color.withOpacity(0.1),
                                  Color(0xFFFFFFFF).withOpacity(0.05),
                                ],
                                stops: [
                                  0.1,
                                  1,
                                ]),
                            borderGradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                colors.primary_color.withOpacity(0.5),
                                Color((0xFFFFFFFF)).withOpacity(0.5),
                              ],
                            ),
                            child: new Container(
                              padding: EdgeInsets.all(2.w),
                              child: new Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    new Text(
                                      widget.titleFormation!,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15.sp),
                                    ),
                                    Container(
                                      child: widget.isBuyed!
                                          ? null
                                          : new Text(
                                              "Prix :  " +
                                                  widget.priceFormation
                                                      .toString() +
                                                  " " +
                                                  strings.currencySymbol,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                    )
                                  ]),
                            )),
                        new Padding(
                          padding: EdgeInsets.all(2.w),
                        ),
                        Container(
                          child: widget.isBuyed!
                              ? null
                              : new GestureDetector(
                                  onTap: () async {
                                    bool res = await buyFormation(
                                        idClient!,
                                        widget.idFormation!,
                                        widget.buyedFormations!);

                                    if (res) {
                                      setState(() {
                                        widget.isBuyed = true;
                                      });
                                    }
                                  },
                                  child: GlassmorphicContainer(
                                      width: 40.h,
                                      height: 05.h,
                                      borderRadius: 20,
                                      blur: 10,
                                      alignment: Alignment.center,
                                      border: 1,
                                      linearGradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0xFFffffff).withOpacity(0.1),
                                            colors.primary_color
                                                .withOpacity(0.05),
                                          ],
                                          stops: [
                                            0.1,
                                            1,
                                          ]),
                                      borderGradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFFffffff).withOpacity(0.5),
                                          colors.primary_color.withOpacity(0.5),
                                        ],
                                      ),
                                      child: new Container(
                                        padding: EdgeInsets.all(2.w),
                                        child: new Text(
                                          "Acheter",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.sp),
                                        ),
                                      )),
                                ),
                        )
                      ],
                    ))
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 1.5.h, 0, 1.5.h),
            ),
            new Text(
              "Description :",
              style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline),
            ),
            new Text(widget.descriptionFormation!),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 1.5.h, 0, 1.5.h),
            ),
            new Text(
              "Vidéos",
              style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 1.5.h, 0, 1.5.h),
            ),
            new Padding(
              padding: EdgeInsets.fromLTRB(0, 1.w, 0, 1.w),
              child: new Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: widget.videos!.length,
                  itemBuilder: (context, index) {
                    String titleVideo =
                        widget.videos![index]['attributes']['title'];
                    String descriptionVideo =
                        widget.videos![index]['attributes']['description'];
                    String urlVideo = strings.host +
                        widget.videos![index]['attributes']['file']['data']
                            ['attributes']['url'];

                    return new Padding(
                      padding: EdgeInsets.all(0.5.w),
                      child: SizedBox(
                          child: new ListTile(
                        leading: new CircleAvatar(
                          backgroundColor: colors.primary_color,
                          child: Text(
                            index.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          titleVideo,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: InkWell(
                          onTap: () {
                            widget.isBuyed!
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DefaultPlayer(
                                              url: urlVideo,
                                              title: titleVideo,
                                              description: descriptionVideo,
                                            )),
                                  )
                                : null;
                          },
                          child: Icon(
                              widget.isBuyed! ? Icons.play_arrow : Icons.lock,
                              color: colors.primary_color),
                        ),
                      )),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<bool> buyFormation(
      String idClient, int idFormation, List buyedFormations) async {
    List newBuyedFormations = buyedFormations;
    newBuyedFormations.add(idFormation);
    //

    String apiUrl = strings.clientsApiUrl + "/" + idClient;
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('PUT', Uri.parse(apiUrl));
    request.body = json.encode({
      "data": {"formations": newBuyedFormations}
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      // add element to achats tables
      final DateTime now = DateTime.now();
      final String date = now.toIso8601String().split('T').first;

      String apiUrl2 = strings.sellsApiUrl;
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse(apiUrl2));
      request.body = json.encode({
        "data": {
          "date": date,
          "formation": idFormation,
          "client": int.parse(idClient)
        }
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        return true;
      } else {
        // ignore: avoid_print
        print("Added to Formation but can't add to Achat");
      }
      //
      return true;
    } else {
      return false;
    }
  }
}
