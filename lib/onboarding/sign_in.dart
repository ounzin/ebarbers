import 'dart:convert';

import 'package:ebarber/landing_activies/home/landing_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:validators/validators.dart';
import 'package:sizer/sizer.dart';

//
import 'package:http/http.dart' as http;
import '../assets/strings.dart' as strings;
import '../assets/colors.dart' as colors;

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _passwordVisible = true;
  bool checkBoxValue = false;
  bool showWarning = false;
  Color checkBoxTextColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.fromLTRB(2.h, 0, 2.h, 2.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "images/logo.png",
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 1.5.h, 0, 1.5.h),
            ),
            Card(
                color: Colors.white,
                elevation: 20,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.all(2.5.h),
                  child: Column(children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 1.h, 0, 1.h),
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: emailController,
                      style: TextStyle(fontSize: 10.sp),
                      validator: (val) =>
                          !isEmail(val!) ? strings.emailHintText : null,
                      decoration: InputDecoration(
                        hintText: strings.labelEmail,
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: colors.primary_color),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15),
                            )),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 1.h, 0, 1.h),
                    ),
                    TextFormField(
                      controller: passwordController,
                      style: TextStyle(fontSize: 10.sp),
                      obscureText: _passwordVisible,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                        hintText: strings.labelPassword,
                        suffixIcon: IconButton(
                          icon: Icon(_passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: colors.primary_color),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15),
                            )),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 1.h, 0, 1.h),
                    ),
                    if (showWarning)
                      const Text(
                        "Ce profil n'existe pas !",
                        style: TextStyle(color: Colors.red),
                      ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 1.h, 0, 1.h),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          value: checkBoxValue,
                          fillColor:
                              MaterialStateProperty.all(colors.primary_color),
                          onChanged: (bool? value) {
                            setState(() {
                              checkBoxValue = value!;
                              checkBoxTextColor = Colors.black;
                            });
                          },
                        ),
                        Text(
                          strings.rememberMe,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: checkBoxValue
                                  ? colors.primary_color
                                  : checkBoxTextColor,
                              fontSize: 10.sp),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 1.2.h, 0, 1.2.h),
                    ),
                    ElevatedButton(
                      child: Text(
                        strings.labelConnexion,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 3.8.w,
                            fontWeight: FontWeight.w700),
                      ),
                      onPressed: () async {
                        var data = await logUser(
                            emailController.text.toString(),
                            passwordController.text.toString());

                        if (data.length < 2) {
                          setState(() {
                            showWarning = true;
                          });
                        }
                        {
                          if (!checkBoxValue) {
                            _savePreferences(data[1], data[0], "no");
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LandingHome()),
                              (Route<dynamic> route) => false,
                            );
                          } else {
                            _savePreferences(data[1], data[0], "yes");
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LandingHome()),
                              (Route<dynamic> route) => false,
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        primary: colors.primary_color,
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 2.h),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 1.h),
                    )
                  ]),
                )),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 3.h, 0, 3.h),
            ),
            Center(
              child: InkWell(
                  onTap: () {},
                  child: Text(
                    strings.createAccountInvitation,
                    style: TextStyle(fontSize: 10.sp),
                  )),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 2.5.h, 0, 2.5.h),
            ),
            Center(
              child: InkWell(
                  onTap: () {},
                  child: Text(
                    strings.labelCGU,
                    style: TextStyle(fontSize: 10.sp),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Future<List> logUser(String identifier, String password) async {
    List<String> res = []; // <- will contain user jwt, id
    String jwt;
    String idClient;
    //
    String apiUrl = strings.logUserApiUrl;
    http.Response response = await http.post(Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"identifier": identifier, "password": password}));

    if (response.statusCode == 200) {
      Map data = json.decode(response.body);
      int id = -1;
      int idUser = data['user']['id'];
      jwt = data['jwt'];
      res.add(jwt);
      id = await getClientId(idUser);

      if (id != -1) {
        idClient = id.toString();
        res.add(idClient);
      }
    }
    //
    return res;
  }

  Future getClientId(int userId) async {
    String apiUrl = strings.clientsApiUrl +
        "?filters[user][id][" +
        "\$" +
        "eq]=" +
        userId.toString();
    http.Response response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      Map data = json.decode(response.body);
      int id = data['data'][0]['id'];
      return id;
    }
    return -1;
  }

  void _savePreferences(String id, String jwt, String isLogged) async {
    // store jwt and id
    FlutterSecureStorage storage = new FlutterSecureStorage();
    await storage.write(key: 'idClient', value: id);
    await storage.write(key: 'jwt', value: jwt);
    await storage.write(key: 'isLogged', value: isLogged);
  }
}
