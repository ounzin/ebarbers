// ignore_for_file: unnecessary_new
import 'dart:convert';
import 'package:ebarber/landing_activies/home/landing_home.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:validators/validators.dart';

//
import 'package:http/http.dart' as http;
import '../assets/strings.dart' as strings;
import '../assets/colors.dart' as colors;

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String initialCountry = 'FR';
  String phoneNumber = "";
  TextEditingController phoneController = new TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _passwordVisible = true;
  bool checkBoxValue = false;
  Color checkBoxTextColor = Colors.black;

  //
  @override
  Widget build(BuildContext context) {
    return Material(
      child: new Container(
          padding: EdgeInsets.all(3.h),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new Text(
                "Inscription",
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w800),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 1.5.h, 0, 1.5.h),
              ),
              Image.asset(
                "images/logo.png",
                height: 20.h,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 1.5.h, 0, 1.5.h),
              ),
              new IntlPhoneField(
                // ignore: deprecated_member_use
                searchText: strings.countrySearchPlaceholder,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (val) => val == "" ? strings.validatePhone : null,
                controller: phoneController,
                onChanged: (phone) {
                  setState(() {
                    phoneNumber = phone.completeNumber;
                  });
                },
                style: TextStyle(fontSize: 10.sp),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: strings.phone,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                ),
                initialCountryCode: 'FR',
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
                  ),
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
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 1.h, 0, 1.h),
              ),
              Row(
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    value: checkBoxValue,
                    fillColor: MaterialStateProperty.all(colors.primary_color),
                    onChanged: (bool? value) {
                      setState(() {
                        checkBoxValue = value!;
                        checkBoxTextColor = Colors.black;
                      });
                    },
                  ),
                  Text(
                    strings.acceptTerms,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: checkBoxValue
                            ? colors.primary_color
                            : checkBoxTextColor,
                        fontSize: 7.sp),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 1.2.h, 0, 1.2.h),
              ),
              ElevatedButton(
                child: Text(
                  strings.labelInscription,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 3.8.w,
                      fontWeight: FontWeight.w700),
                ),
                onPressed: () async {
                  //print(emailController.text.toString().isNotEmpty);
                  if (checkBoxValue &&
                      phoneController.text.toString().isNotEmpty &&
                      emailController.text.toString().isNotEmpty &&
                      passwordController.text.toString().isNotEmpty) {
                    // going to next activity...

                    bool condition = await createNewUser(
                        phoneController.text.toString(),
                        emailController.text.toString(),
                        passwordController.text.toString());
                    if (condition) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LandingHome()),
                      );
                    }
                  } else {
                    print("error");
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  primary: colors.primary_color,
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 2.h),
                ),
              ),
            ],
          )),
    );
  }

  Future<bool> createNewUser(
      String phone, String email, String password) async {
    // variables
    String? jwt;
    int? idClient;
    bool result = false;

    // first step :: Create a new User from User permission :
    http.Response responseUserPermission = await http.post(
        Uri.parse(strings.createUserApiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json
            .encode({"username": email, "email": email, "password": password}));

    if (responseUserPermission.statusCode == 200) {
      Map dataUserPermission = json.decode(responseUserPermission.body);
      int idUser = dataUserPermission['user']['id'];
      jwt = dataUserPermission['jwt'];
      // create new Client

      http.Response responseClient =
          await http.post(Uri.parse(strings.clientsApiUrl),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode({
                "data": {
                  "email": email,
                  "password": password,
                }
              }));

      if (responseClient.statusCode == 200) {
        Map dataClient = json.decode(responseClient.body);

        idClient = dataClient['data']['id'];
        // link client and user from user permission
        String apiLinkUrl = strings.clientsApiUrl + "/" + idClient.toString();
        http.Response responseLink = await http.put(Uri.parse(apiLinkUrl),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: json.encode({
              "data": {"user": idUser}
            }));
        if (responseLink.statusCode == 200) {
          // client and user are linked
          _savePreferences(idClient.toString(), jwt!, "yes");
          setState(() {
            result = true;
          });
        }
      }
    }

    return result;
  }

  void _savePreferences(String id, String jwt, String isLogged) async {
    // store jwt and id
    FlutterSecureStorage storage = new FlutterSecureStorage();
    await storage.write(key: 'idClient', value: id);
    await storage.write(key: 'jwt', value: jwt);
    await storage.write(key: 'isLogged', value: isLogged);
  }
}
