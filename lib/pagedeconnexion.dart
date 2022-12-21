// ignore_for_file: unused_import, camel_case_types, unused_field, unused_element, unnecessary_null_comparison, unused_local_variable, avoid_print, prefer_typing_uninitialized_variables, deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logisoft_gsc/admin/listeAdmin.dart';
import 'package:logisoft_gsc/listesdesentretiens.dart';
import 'package:logisoft_gsc/motdepassoublier.dart';
import 'package:logisoft_gsc/utils/auth_helper.dart';
import 'package:logisoft_gsc/utils/global.colors.dart' show GlobalColors;
import 'package:shared_preferences/shared_preferences.dart';

class pagedeconnexion extends StatefulWidget {
  const pagedeconnexion({
    Key? key,
  }) : super(key: key);

  @override
  State<pagedeconnexion> createState() => _pagedeconnexionState();
}

class _pagedeconnexionState extends State<pagedeconnexion> {
  final _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final dbRef = FirebaseFirestore.instance.collection("users");
  String errorMessage = '';

  var email = " ";
  var password = " ";

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _showPassword = false;
  bool _isChecked = false;
  late SharedPreferences sharedPreferences;

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getCredential();
  }

  _onChanged(bool value) async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _isChecked = value;
      sharedPreferences.setBool("check", _isChecked);
      sharedPreferences.setString("username", emailController.text);
      sharedPreferences.setString("password", passwordController.text);
      sharedPreferences.commit();
      getCredential();
    });
  }

  getCredential() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _isChecked = sharedPreferences.getBool("check")!;
      if (_isChecked != null) {
        if (_isChecked) {
          emailController.text =
              sharedPreferences.getString("emailController")!;
          passwordController.text =
              sharedPreferences.getString("passwordController")!;
        } else {
          emailController.clear();
          passwordController.clear();
          sharedPreferences.clear();
        }
      } else {
        _isChecked = false;
      }
    });
  }

  route() {
    User? user = FirebaseAuth.instance.currentUser;
    var kk = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('role') == "admin") {
          var userId;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ListesAdmin(
                userId: userId,
              ),
            ),
          );
        } else {
          var userId;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => listesdesentretiens(userId: userId),
            ),
          );
        }
      } else {
        print('Document does not exist on the database');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: GlobalColors.textColor,
            content: const Text(
              'Document does not exist on the database',
              style: TextStyle(fontSize: 15.0),
            ),
          ),
        );
      }
    });
  }

  userLogin(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        route();
      } catch (e) {
        Fluttertoast.showToast(
            msg: "Votre login et/ou mot de passe incorect(s)");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  height: 504.0,
                  child: Stack(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Pinned.fromPins(
                            Pin(start: 0.0, end: 0.0),
                            Pin(size: 242.0, start: 0.0),
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image:
                                          AssetImage('assets/images/logo.png'),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ],
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
                                    borderRadius: BorderRadius.circular(23.0),
                                  ),
                                ),
                                Pinned.fromPins(
                                  Pin(start: 35.0, end: 36.0),
                                  Pin(size: 200.0, middle: 0.4),
                                  child: Stack(
                                    children: <Widget>[
                                      Center(
                                        child: Text(errorMessage),
                                      ),
                                      ////            SE CONNECTER  /////
                                      Pinned.fromPins(
                                        Pin(start: 60.0, end: 0.0),
                                        Pin(size: 49.0, end: 0.0),
                                        child: Stack(
                                          children: <Widget>[
                                            Container(
                                              decoration: BoxDecoration(
                                                color: const Color(0xff0e6324),
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                                border: Border.all(
                                                    width: 1.0,
                                                    color: const Color(
                                                        0xff707070)),
                                              ),
                                              child: TextButton(
                                                  onPressed: () {
                                                    userLogin(
                                                        emailController.text,
                                                        passwordController
                                                            .text);
                                                  },
                                                  child: const Text(
                                                    'Se connecter',
                                                    style: TextStyle(
                                                      fontFamily: 'Segoe UI',
                                                      fontSize: 15,
                                                      color: Color(0xffffffff),
                                                    ),
                                                    softWrap: false,
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),

                                      ////            CHAMP MOT DE PASSE   /////
                                      Pinned.fromPins(
                                        Pin(start: 0.0, end: 0.0),
                                        Pin(size: 55.0, middle: 0.5),
                                        child: Stack(
                                          children: <Widget>[
                                            Container(
                                              decoration: BoxDecoration(
                                                color: const Color(0x4df6ef76),
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                              child: TextFormField(
                                                controller: passwordController,
                                                autofocus: false,
                                                obscureText: !_showPassword,
                                                decoration: InputDecoration(
                                                    prefixIcon: GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          _showPassword =
                                                              !_showPassword;
                                                        });
                                                      },
                                                      child: Icon(
                                                        _showPassword
                                                            ? Icons.visibility
                                                            : Icons
                                                                .visibility_off,
                                                        size: 25,
                                                      ),
                                                    ),
                                                    hintText: 'Mot de passe',
                                                    border: InputBorder.none,
                                                    hintStyle: const TextStyle(
                                                        fontSize: 15.0,
                                                        color:
                                                            Color(0xff0e6324)),
                                                    errorStyle: const TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 12.0)),
                                                onSaved: (value) {
                                                  passwordController.text =
                                                      value!;
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      ////            CHAMP LOGIN   /////
                                      Pinned.fromPins(
                                        Pin(start: 0.0, end: 0.0),
                                        Pin(size: 50.0, start: 0.0),
                                        child: Stack(
                                          children: <Widget>[
                                            Stack(
                                              children: <Widget>[
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0x4df6ef76),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                  ),
                                                  child: TextFormField(
                                                    controller: emailController,
                                                    autofocus: false,
                                                    obscureText: false,
                                                    decoration:
                                                        const InputDecoration(
                                                            prefixIcon: Icon(
                                                                Icons.person),
                                                            hintText:
                                                                'Votre login',
                                                            border:
                                                                InputBorder
                                                                    .none,
                                                            hintStyle: TextStyle(
                                                                color: Color(
                                                                    0xff0e6324),
                                                                fontSize: 15.0),
                                                            errorStyle:
                                                                TextStyle(
                                                                    color:
                                                                        Colors
                                                                            .red,
                                                                    fontSize:
                                                                        12.0)),
                                                    onSaved: (value) {
                                                      emailController.text =
                                                          value!;
                                                    },
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
                                ////            MOT DE  PASSE OUBLIER    /////
                                Pinned.fromPins(
                                  Pin(size: 165.0, middle: 0.5300),
                                  Pin(size: 50.0, end: 15.0),
                                  child: Stack(
                                    children: <Widget>[
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pushReplacement(
                                                context,
                                                PageRouteBuilder(
                                                    pageBuilder: (context,
                                                            animation1,
                                                            animation2) =>
                                                        const motdepassoublier(),
                                                    transitionDuration:
                                                        const Duration(
                                                            seconds: 3)));
                                          },
                                          child: const Text(
                                            'Mot de passe oublié ?',
                                            style: TextStyle(
                                              fontFamily: 'Segoe UI',
                                              fontSize: 15,
                                              color: Color(0xff0e6324),
                                            ),
                                            softWrap: false,
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
