// ignore_for_file: unnecessary_new

import 'package:ebarber/landing_activies/home/formations.dart';
import 'package:ebarber/landing_activies/home/home.dart';
import 'package:ebarber/landing_activies/home/profil.dart';
import 'package:ebarber/landing_activies/home/reservations.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';
import 'package:custom_bottom_navigation_bar/custom_bottom_navigation_bar_item.dart';

//
import '../../assets/strings.dart' as strings;
import '../../assets/colors.dart' as colors;
import '../../assets/utils.dart' as utils;

class LandingHome extends StatefulWidget {
  const LandingHome({Key? key}) : super(key: key);

  @override
  State<LandingHome> createState() => _LandingHomeState();
}

class _LandingHomeState extends State<LandingHome> {
  int _activityIndex = 0;

  List<Widget> _children = [Home(), Reservations(), Formations(), Profil()];
  PageController? pageController;

  _onItemTapped(int index) {
    setState(() {
      _activityIndex = index;
      pageController!.jumpToPage(_activityIndex);
    });
  }

  @override
  void initState() {
    pageController = PageController(initialPage: _activityIndex);
    super.initState();
  }

  @override
  void dispose() {
    pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: [
          utils.landingBody(topBar("images/logo-top-bar.png", Icons.search),
              _children[0]), // Home
          utils.landingBody(
            topBar("images/logo-top-bar.png", Icons.search),
            _children[1],
          ), // Reservations
          utils.landingBody(
            topBar("images/logo-top-bar.png", Icons.search),
            _children[2],
          ), // Formations
          utils.landingBody(
            topBar("images/logo-top-bar.png", Icons.search),
            _children[3],
          ), // Profil
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        onTap: _onItemTapped,
        backgroundColor: colors.primary_color,
        itemBackgroudnColor: colors.primary_color,
        items: [
          CustomBottomNavigationBarItem(
              icon: Icons.home_outlined, title: strings.labelHome),
          //
          CustomBottomNavigationBarItem(
              icon: Icons.calendar_month, title: strings.labelReservation),
          //
          CustomBottomNavigationBarItem(
              icon: Icons.perm_media, title: strings.labelFormations),
          //
          CustomBottomNavigationBarItem(
              icon: Icons.person_outlined, title: strings.labelProfil)
        ],
      ),
    );
  }

  Widget topBar(String logoUrl, IconData icon) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // <- Top Banner
      children: [
        //
        new Image.asset(
          logoUrl,
          width: 30.w,
        ),
        //
        new Icon(
          icon,
          color: colors.primary_color,
          size: 8.w,
        )
      ],
    );
  }
}
