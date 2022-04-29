// ignore_for_file: unnecessary_new, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sizer/sizer.dart';
import '../../containers/category_card.dart';

//
import 'package:http/http.dart' as http;
import '../../assets/strings.dart' as strings;
import '../../assets/colors.dart' as colors;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List? categories;
  int? lengthCategories;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: new Container(
        padding: EdgeInsets.all(2.w),
        child: new ListView(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 1.h, 0, 1.h),
            ),
            new Text(
              "Bonjour,",
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            new Text(
              "Profitez dès maintenant de nos prestations !",
              style: TextStyle(fontSize: 10.sp),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 1.5.h, 0, 1.5.h),
            ),
            new FutureBuilder(
              future: getCategories(),
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
                    categories = data['data'];
                    lengthCategories = categories!.length;
                  }

                  if (lengthCategories == 0) {
                    return Text("C'est bien vide par ici ...");
                  } else {
                    return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 1.w,
                            crossAxisCount: 2,
                            crossAxisSpacing: 1.w),
                        itemCount: lengthCategories,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemBuilder: (context, index) {
                          int idCategorie = categories![index]['id'];
                          String categoryName =
                              categories![index]['attributes']['name'];
                          String? holderUrl;

                          if (categories![index]['attributes']['holder']
                                  ['data'] ==
                              null) {
                            holderUrl = null;
                          } else {
                            holderUrl = strings.host +
                                categories![index]['attributes']['holder']
                                    ['data']['attributes']['url'];
                          }

                          return CategoryCard(
                              idCategory: idCategorie,
                              categoryName: categoryName,
                              holderUrl: holderUrl);
                        });
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
}

Future<Map> getCategories() async {
  String apiUrl = strings.categoriesApiUrl + "?populate=*";
  http.Response response = await http.get(Uri.parse(apiUrl));
  return json.decode(response.body);
}
