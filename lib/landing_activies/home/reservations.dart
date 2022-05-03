// ignore_for_file: unnecessary_new, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sizer/sizer.dart';

//
import 'package:http/http.dart' as http;
import '../../assets/strings.dart' as strings;
import '../../assets/colors.dart' as colors;

class Reservations extends StatefulWidget {
  const Reservations({Key? key}) : super(key: key);

  @override
  State<Reservations> createState() => _ReservationsState();
}

class _ReservationsState extends State<Reservations> {
  int? idClient;
  _loadEmployees() async {
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? id = await storage.read(key: 'idClient');

    setState(() {
      idClient = int.parse(id!);
    });
  }

  @override
  void initState() {
    _loadEmployees();
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        child: idClient == null
            ? null
            : FutureBuilder(
                future: getReservations(idClient!),
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
                    return const Center(
                      child:
                          CircularProgressIndicator(), // <- error API :: error Connexion
                    );
                  }

                  if (snapshot.hasData) {
                    Map? data = snapshot.data as Map?;

                    List reservations = data!['data'];

                    int reservationsLength = reservations.length;

                    return ListView(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 1.5.h, 0, 1.5.h),
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount: reservationsLength,
                              itemBuilder: (context, index) {
                                int idPrestation = reservations[index]['id'];
                                String prestationTitle = reservations[index]
                                        ['attributes']['prestation']['data']
                                    ['attributes']['title'];
                                String date =
                                    reservations[index]['attributes']['date'];
                                String time =
                                    reservations[index]['attributes']['time'];
                                List<String> timeSplitted = time.split(':');
                                time = timeSplitted[0];

                                return new Card(
                                    margin: EdgeInsets.all(1.5.w),
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: colors.primary_color,
                                        child: Text(
                                          "$index",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      title: Text(prestationTitle),
                                      subtitle: Text(
                                          reservationDatePrinter(date, time),
                                          overflow: TextOverflow.ellipsis),
                                      trailing: InkWell(
                                          onTap: () async {
                                            bool res = await deleteReservation(
                                                idPrestation);
                                            if (res) {
                                              setState(() {});
                                            }
                                          },
                                          child: Icon(
                                            Icons.cancel,
                                            color: Colors.redAccent,
                                          )),
                                    ));
                              }),
                        ]);
                  }
                  return const Center();
                },
              ),
      ),
    );
  }

  Future<Map> getReservations(int idClient) async {
    String apiUrl = strings.reservationsApiUrl +
        "?populate=*" +
        "&filters[client][id][" +
        "\$" +
        "eq]=" +
        idClient.toString();
    http.Response response = await http.get(Uri.parse(apiUrl));
    return json.decode(response.body);
  }

  String reservationDatePrinter(String date, String time) {
    String res = "Le ";
    List<String> dateSplitted = date.split('-');
    String dateFinal =
        dateSplitted[2] + '-' + dateSplitted[1] + '-' + dateSplitted[0];
    res += dateFinal +
        " de " +
        time +
        "h à " +
        (int.parse(time) + 1).toString() +
        "h";
    return res;
  }

  Future<bool> deleteReservation(int idPrestation) async {
    String apiUrl = strings.reservationsApiUrl + '/' + idPrestation.toString();
    http.Response response = await http.delete(Uri.parse(apiUrl));
    if (response.statusCode == 200) return true;
    return false;
  }
}
