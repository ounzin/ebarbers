// ignore_for_file: avoid_unnecessary_containers, unnecessary_new, prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'package:ebarber/components/prestation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

//
import 'package:http/http.dart' as http;
import '../assets/strings.dart' as strings;
import '../assets/colors.dart' as colors;

// ignore: must_be_immutable
class Category extends StatefulWidget {
  int? idCategory;
  String? categoryName;
  String? holderUrl;
  Category(
      {Key? key,
      required this.idCategory,
      required this.categoryName,
      required this.holderUrl})
      : super(key: key);

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  List? prestations;
  int? lengthPrestations;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(
        padding: EdgeInsets.all(3.w),
        child: new ListView(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 1.5.h, 0, 1.5.h),
            ),
            // pop button and Category name
            Padding(
              padding: EdgeInsets.fromLTRB(3.w, 0, 3.w, 0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  new InkWell(
                      onTap: () => Navigator.pop(context),
                      child: new CircleAvatar(
                        backgroundColor: colors.primary_color,
                        child: Icon(Icons.chevron_left, color: Colors.white),
                      )),
                  Padding(
                    padding: EdgeInsets.fromLTRB(3.w, 0, 3.w, 0),
                    child: new Text(widget.categoryName!,
                        style: TextStyle(
                            fontSize: 20.sp, fontWeight: FontWeight.bold)),
                  ),
                  new CircleAvatar(
                    backgroundImage: widget.holderUrl == null
                        ? NetworkImage(widget
                            .holderUrl!) // une diversion pour eviter que flutter rale
                        : NetworkImage(widget.holderUrl!),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 1.h, 0, 1.h),
            ),
            // prestations in category displayer
            new FutureBuilder(
              future: getPrestationsInCategory(widget.idCategory!),
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
                  //
                  Map<dynamic, dynamic>? data = snapshot.data as Map?;
                  //
                  if (data != null) {
                    prestations = data['data'];
                    lengthPrestations = prestations!.length;
                  }
                  //
                  if (lengthPrestations == 0 || prestations == null) {
                    return new Text(strings.labelNoPrestationAvailable);
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: lengthPrestations,
                      itemBuilder: (context, index) {
                        int idPrestation = prestations![index]['id'];
                        int pricePrestation =
                            prestations![index]['attributes']['price'];
                        int durationPrestation =
                            prestations![index]['attributes']['duration'];
                        String titlePrestation =
                            prestations![index]['attributes']['title'];
                        String descriptionPrestation =
                            prestations![index]['attributes']['description'];

                        return new InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Prestation(
                                          idPrestation: idPrestation,
                                          duration: durationPrestation,
                                          price: pricePrestation,
                                          title: titlePrestation,
                                          description: descriptionPrestation,
                                          categoryImageUrl: widget.holderUrl,
                                        )),
                              );
                            },
                            child: new Card(
                                margin: EdgeInsets.all(1.5.w),
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: new ListTile(
                                  leading: new CircleAvatar(
                                    backgroundColor: colors.primary_color,
                                    child: new Text(
                                      "$durationPrestation h",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  title: new Text(titlePrestation),
                                  subtitle: new Text(descriptionPrestation,
                                      overflow: TextOverflow.ellipsis),
                                  trailing: new Text(
                                    "$pricePrestation " +
                                        strings.currencySymbol,
                                    style: TextStyle(
                                        color: colors.primary_color,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )));
                      },
                    );
                  }
                }

                return Container(
                  child: new Center(
                    child:
                        CircularProgressIndicator(), // <- error API :: to mod
                  ),
                ); // <- future builder outpoint (else)
              },
            )
          ],
        ),
      ),
    );
  }

  Future<Map> getPrestationsInCategory(int idCategory) async {
    String apiUrl = strings.prestationsApiUrl +
        '?populate=*&filters[categorie][id][' +
        '\$' +
        'eq]=$idCategory';

    http.Response data = await http.get(Uri.parse(apiUrl));
    return json.decode(data.body);
  }
}
