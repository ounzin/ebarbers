import 'package:flutter/material.dart';

import 'package:validators/validators.dart';
import 'package:sizer/sizer.dart';

//
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
                      onPressed: () {
                        if (!checkBoxValue) {
                        } else {}
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
}
