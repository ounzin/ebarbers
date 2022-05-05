// ignore_for_file: unnecessary_new, prefer_const_constructors

import 'package:ebarber/containers/about.dart';
import 'package:ebarber/containers/billing.dart';
import 'package:ebarber/onboarding/sign_in.dart';
import 'package:ebarber/onboarding/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sizer/sizer.dart';

//
import '../../assets/strings.dart' as strings;
import '../../assets/colors.dart' as colors;

class Profil extends StatefulWidget {
  const Profil({Key? key}) : super(key: key);

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: new Container(
        child: new ListView(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          children: [
            new Padding(
              padding: EdgeInsets.fromLTRB(0, 1.5.h, 0, 1.5.h),
            ),
            new Card(
                elevation: 01,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                child: new ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Billing()),
                    );
                  },
                  trailing: new Icon(Icons.chevron_right),
                  title: new Text(
                    "Mes achats",
                    style:
                        TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                  ),
                  subtitle: new Text(
                    "Un récapitulatif de vos achats",
                    style: TextStyle(fontSize: 10.sp),
                  ),
                )),
            Divider(),
            new Card(
                elevation: 01,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                child: new ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const About()),
                    );
                  },
                  trailing: new Icon(Icons.chevron_right),
                  title: new Text(
                    "A propos",
                    style:
                        TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                  ),
                  subtitle: new Text(
                    "Découvrez l'équipe E-barber",
                    style: TextStyle(fontSize: 10.sp),
                  ),
                )),
            Divider(),
            new Card(
                elevation: 01,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                child: new ListTile(
                  onTap: () {
                    _updatePreference("no");
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const SignIn()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  trailing: new Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                  title: new Text(
                    "Deconnexion",
                    style:
                        TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void _updatePreference(String isLogged) async {
    // store jwt and id
    FlutterSecureStorage storage = new FlutterSecureStorage();
    await storage.write(key: 'isLogged', value: isLogged);
  }
}
