// ignore_for_file: avoid_unnecessary_containers, unnecessary_new, prefer_const_constructors

import 'package:ebarber/containers/formation_presentation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:validators/validators.dart';

//

import '../../assets/strings.dart' as strings;
import '../../assets/colors.dart' as colors;

class FormationTile extends StatefulWidget {
  bool? isBuyed;
  int? idFormation;
  int? nbrVideos;
  int? price;
  String? titleFormation;
  String? description;
  String? urlCover;
  List? videos;
  List? buyedFormations;

  FormationTile(
      {Key? key,
      required this.isBuyed,
      required this.idFormation,
      required this.nbrVideos,
      required this.titleFormation,
      required this.price,
      required this.description,
      required this.urlCover,
      required this.videos,
      required this.buyedFormations})
      : super(key: key);

  @override
  State<FormationTile> createState() => _FormationTileState();
}

class _FormationTileState extends State<FormationTile> {
  @override
  Widget build(BuildContext context) {
    return new Card(
        margin: EdgeInsets.all(2.w),
        color: colors.primary_color,
        elevation: 05,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        child: new InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FormationPresentation(
                        idFormation: widget.idFormation,
                        isBuyed: widget.isBuyed,
                        urlCover: widget.urlCover,
                        priceFormation: widget.price,
                        titleFormation: widget.titleFormation,
                        descriptionFormation: widget.description,
                        videos: widget.videos,
                        buyedFormations: widget.buyedFormations,
                      )),
            );
          },
          child: new Container(
            height: 15.h, // <- to remove ?
            margin: EdgeInsets.fromLTRB(0, 0.5.w, 0, 0.5.w),
            child: new Column(children: [
              new Row(
                children: [
                  new Container(
                      margin: EdgeInsets.all(3.w),
                      child: new Center(
                          child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(widget.urlCover!),
                          radius: 48,
                        ),
                      ))),

                  //
                  new Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 10.h, 0),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        new Text(
                          widget.titleFormation!,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w700),
                        ),
                        new Padding(
                          padding: EdgeInsets.fromLTRB(0, 0.5.h, 0, 0.5.h),
                        ),
                        new Text(
                          widget.nbrVideos!.toString() + " vidéos",
                          style:
                              TextStyle(color: Colors.white, fontSize: 10.sp),
                        ),
                      ],
                    ),
                  ),

                  new InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FormationPresentation(
                                  idFormation: widget.idFormation,
                                  isBuyed: widget.isBuyed,
                                  urlCover: widget.urlCover,
                                  priceFormation: widget.price,
                                  titleFormation: widget.titleFormation,
                                  descriptionFormation: widget.description,
                                  videos: widget.videos,
                                  buyedFormations: widget.buyedFormations,
                                )),
                      );
                    },
                    child: new CircleAvatar(
                        backgroundColor: Colors.white,
                        child: new Center(
                            child: Icon(
                          Icons.visibility,
                          size: 18.sp,
                          color: colors.primary_color,
                        ))),
                  )
                ],
              )
            ]),
          ),
        ));
  }
}
