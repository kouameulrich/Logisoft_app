// ignore_for_file: camel_case_types, avoid_print, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:logisoft_gsc/pagedeconnexion.dart';
import 'package:logisoft_gsc/utils/global.colors.dart';

class motdepassoublier extends StatefulWidget {
  const motdepassoublier({
    Key? key,
  }) : super(key: key);

  @override
  State<motdepassoublier> createState() => _motdepassoublierState();
}

class _motdepassoublierState extends State<motdepassoublier> {
  final _formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  var email = " ";

  resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const pagedeconnexion()));
    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        print('No user found for that email');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: GlobalColors.textColor,
            content: const Text(
              'No user found for that email',
              style: TextStyle(fontSize: 15.0),
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const pagedeconnexion()));
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xffffffff),
        body: Form(
          key: _formkey,
          child: Stack(
            children: <Widget>[
              Pinned.fromPins(
                Pin(size: 298.0, middle: 0.5065),
                Pin(start: 80.0, end: 36.0),
                child: SingleChildScrollView(
                  primary: false,
                  child: SizedBox(
                    width: 298.0,
                    height: 604.0,
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 92.0),
                          child: Stack(
                            children: <Widget>[
                              Align(
                                alignment: const Alignment(-0.008, -1.0),
                                child: SizedBox(
                                  width: 298.0,
                                  height: 504.0,
                                  child: Stack(
                                    children: <Widget>[
                                      Pinned.fromPins(
                                        Pin(start: 0.0, end: 0.0),
                                        Pin(size: 242.0, start: 0.0),
                                        child: Stack(
                                          children: <Widget>[
                                            Container(
                                              decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/logo.png'),
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Pinned.fromPins(
                                Pin(start: 0.0, end: 0.0),
                                Pin(size: 302.0, end: 0.0),
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xfff1f1f1),
                                        borderRadius:
                                            BorderRadius.circular(23.0),
                                      ),
                                    ),
                                    Pinned.fromPins(
                                      Pin(start: 35.0, end: 36.0),
                                      Pin(size: 114.0, middle: 0.5),
                                      child: Stack(
                                        children: <Widget>[
                                          Pinned.fromPins(
                                            Pin(start: 55.0, end: 0.0),
                                            Pin(size: 49.0, end: 0.0),
                                            child: Stack(
                                              children: <Widget>[
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xff0e6324),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                    border: Border.all(
                                                        width: 1.0,
                                                        color: const Color(
                                                            0xff707070)),
                                                  ),
                                                  child: TextButton(
                                                      onPressed: () {
                                                        if (_formkey
                                                            .currentState!
                                                            .validate()) {
                                                          setState(() {
                                                            email =
                                                                emailController
                                                                    .text;
                                                          });
                                                          resetPassword();
                                                        }
                                                      },
                                                      child: const Text(
                                                        '       Envoyer      ',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Segoe UI',
                                                          fontSize: 15,
                                                          color:
                                                              Color(0xffffffff),
                                                        ),
                                                        softWrap: false,
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Pinned.fromPins(
                                            Pin(start: 0.0, end: 5.0),
                                            Pin(size: 49.0, start: 0.0),
                                            child: Stack(
                                              children: <Widget>[
                                                Stack(
                                                  children: <Widget>[
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                            0x4df6ef76),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.0),
                                                      ),
                                                    ),
                                                    TextFormField(
                                                      textAlign:
                                                          TextAlign.center,
                                                      controller:
                                                          emailController,
                                                      autofocus: false,
                                                      obscureText: false,
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText:
                                                            'Entrer votre mail',
                                                        hintStyle: TextStyle(
                                                            color: Color(
                                                                0xff0e6324)),
                                                        border:
                                                            InputBorder.none,
                                                        contentPadding:
                                                            EdgeInsets.all(15),
                                                        labelStyle: TextStyle(
                                                          fontFamily: 'Ubuntu',
                                                          fontSize: 15,
                                                          color:
                                                              Color(0xff0e0d0d),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
