// ignore_for_file: avoid_unnecessary_containers, unnecessary_new

import 'package:ebarber/components/category.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

//
import '../assets/strings.dart' as strings;
import '../assets/colors.dart' as colors;
//

class CategoryCard extends StatefulWidget {
  int? idCategory;
  String? categoryName;
  String? holderUrl;
  CategoryCard({Key? key, this.idCategory, this.categoryName, this.holderUrl})
      : super(key: key);

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    return new Card(
        margin: EdgeInsets.all(2.w),
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        shadowColor: colors.primary_color,
        child: new InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Category(
                          idCategory: widget.idCategory,
                          categoryName: widget.categoryName,
                          holderUrl: widget.holderUrl,
                        )),
              );
            },
            child: new Container(
              height: 20.h,
              margin: EdgeInsets.all(0.5.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                image: widget.holderUrl == null
                    ? null
                    : DecorationImage(
                        image: NetworkImage(widget.holderUrl!),
                        fit: BoxFit.cover,
                      ),
              ),
              child: new Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.black.withOpacity(0.40)),
                child: Text(
                  widget.categoryName!,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            )));
  }
}
