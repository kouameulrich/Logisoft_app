// ignore_for_file: depend_on_referenced_packages, unused_import, prefer_const_constructors, unused_label, unnecessary_import, unused_local_variable, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:location/location.dart';
import 'package:location/location.dart' as loc;
import 'package:logisoft_gsc/admin/listeClient.dart';
import 'package:logisoft_gsc/utils/button_widget.dart';
import 'package:logisoft_gsc/utils/firebase_api.dart';
import 'package:signature/signature.dart';
import '../listesdesentretiens.dart';
import 'package:path/path.dart' as p;

class PageClient extends StatefulWidget {
  String userId;
  PageClient({Key? key, required this.userId}) : super(key: key);

  @override
  State<PageClient> createState() => _PageClientState(userId);
}

class _PageClientState extends State<PageClient> {
  CollectionReference docClient =
      FirebaseFirestore.instance.collection('client');

  final nomcltController = TextEditingController();
  final representantController = TextEditingController();
  final telephoneController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();

  double? lati;
  double? longi;

  String userId;

  Location location = Location();

  _PageClientState(this.userId);
  getPosition() async {
    final loc.LocationData currentPosition = await location.getLocation();
    var lt = currentPosition.latitude.toString().replaceAll(RegExp(","), ".");
    var lg = currentPosition.longitude.toString().replaceAll(RegExp(","), ".");
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: const Color(0xff0e6324),
          toolbarHeight: 80,
          toolbarOpacity: 0.5,
          title: const Text('Enregistrement de Client'),
          titleTextStyle: const TextStyle(
            fontFamily: 'Ubuntu',
            fontSize: 20,
            letterSpacing: -0.24,
            fontWeight: FontWeight.w700,
          ),
          centerTitle: true,
        ),
      ),
      backgroundColor: const Color(0xffffffff),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              ListView(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                padding: const EdgeInsets.all(15),
                children: [
                  ////               NOM CLIENT            ////
                  const Text(
                    'Client',
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      fontSize: 17,
                      color: Color(0xff050505),
                    ),
                    softWrap: false,
                  ),
                  TextFormField(
                    textAlign: TextAlign.center,
                    controller: nomcltController,
                    autofocus: false,
                    obscureText: false,
                    decoration: const InputDecoration(
                      hintText: 'Nom du client',
                      hintStyle: TextStyle(color: Color(0xff0e6324)),
                      filled: true,
                      fillColor: Color(0x4a94b913),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(12),
                      labelStyle: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontSize: 15,
                        color: Color(0xff0e0d0d),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: Color(0x4a94b913),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 5,
                  ),

                  ////               REPRESENTANT            ////
                  const Text(
                    'Représentant',
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      fontSize: 17,
                      color: Color(0xff050505),
                    ),
                    softWrap: false,
                  ),
                  TextFormField(
                    textAlign: TextAlign.center,
                    controller: representantController,
                    autofocus: false,
                    obscureText: false,
                    decoration: const InputDecoration(
                      hintText: 'Nom du représentant',
                      hintStyle: TextStyle(color: Color(0xff0e6324)),
                      filled: true,
                      fillColor: Color(0x4a94b913),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(12),
                      labelStyle: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontSize: 15,
                        color: Color(0xff0e0d0d),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: Color(0x4a94b913),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 5,
                  ),

                  ////               TELEPHONE            ////
                  const Text(
                    'Téléphone',
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      fontSize: 17,
                      color: Color(0xff050505),
                    ),
                    softWrap: false,
                  ),
                  TextFormField(
                    textAlign: TextAlign.center,
                    controller: telephoneController,
                    autofocus: false,
                    obscureText: false,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                    ],
                    decoration: const InputDecoration(
                      hintText: 'Numéro client',
                      hintStyle: TextStyle(color: Color(0xff0e6324)),
                      filled: true,
                      fillColor: Color(0x4a94b913),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(12),
                      labelStyle: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontSize: 15,
                        color: Color(0xff0e0d0d),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: Color(0x4a94b913),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 5,
                  ),

                  const Text(
                    'Localisation',
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      fontSize: 17,
                      color: Color(0xff050505),
                    ),
                    softWrap: false,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          controller: latitudeController,
                          autofocus: false,
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[-.-0-9]'))
                          ],
                          decoration: const InputDecoration(
                            hintText: 'Latitude',
                            hintStyle: TextStyle(color: Color(0xff0e6324)),
                            filled: true,
                            fillColor: Color(0x4a94b913),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(12),
                            labelStyle: TextStyle(
                              fontFamily: 'Ubuntu',
                              fontSize: 15,
                              color: Color(0xff0e0d0d),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Color(0x4a94b913),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      Expanded(
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          controller: longitudeController,
                          autofocus: false,
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[-.-0-9]'))
                          ],
                          decoration: const InputDecoration(
                            hintText: 'Longitude',
                            hintStyle: TextStyle(color: Color(0xff0e6324)),
                            filled: true,
                            fillColor: Color(0x4a94b913),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(12),
                            labelStyle: TextStyle(
                              fontFamily: 'Ubuntu',
                              fontSize: 15,
                              color: Color(0xff0e0d0d),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Color(0x4a94b913),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          onPressed: () async {
                            final loc.LocationData currentPosition =
                                await location.getLocation();
                            var lg = currentPosition.longitude
                                .toString()
                                .replaceAll(RegExp(","), ".");
                            var lt = currentPosition.latitude
                                .toString()
                                .replaceAll(RegExp(","), ".");
                            latitudeController:
                            double.parse(lt);
                            longitudeController:
                            double.parse(lg);
                            lati = double.parse(lt);
                            longi = double.parse(lg);
                            longitudeController.text = lg;
                            latitudeController.text = lt;
                          },
                          icon: Icon(
                            Icons.location_on,
                            size: 40,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  ////               ENREGISTRER            ////
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff0e6324),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                    onPressed: () async {
                      final loc.LocationData currentPosition =
                          await location.getLocation();
                      var lg = currentPosition.longitude
                          .toString()
                          .replaceAll(RegExp(","), ".");
                      var lt = currentPosition.latitude
                          .toString()
                          .replaceAll(RegExp(","), ".");
                      final clients = Clients(
                        nomClt: nomcltController.text,
                        representant: representantController.text,
                        telephone: telephoneController.text,
                        latitude: double.parse(lt),
                        longitude: double.parse(lg),
                      );
                      createClient(clients);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListeClient(
                                    userId: userId,
                                  )));
                    },
                    icon: const Icon(Icons.save_alt),
                    label: const Text(
                      'Enregistrer client',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future createClient(Clients clients) async {
    final docClient = FirebaseFirestore.instance.collection('client').doc();
    clients.id = docClient.id;
    final json = clients.toJson();
    await docClient.set(json);
    Fluttertoast.showToast(
        msg: "Enregistrement de client éffectué avec succès !!!");
  }
}

class Clients {
  String id;
  final String nomClt;
  final String representant;
  final String telephone;
  final double latitude;
  final double longitude;

  Clients({
    this.id = '',
    required this.nomClt,
    required this.representant,
    required this.telephone,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'nomClt': nomClt,
        'representant': representant,
        'telephone': telephone,
        'latitude': latitude,
        'longitude': longitude,
      };

  static Clients fromJson(Map<String, dynamic> json) => Clients(
        nomClt: json['nomClt'],
        representant: json['representant'],
        telephone: json['telephone'],
        latitude: json['latitude'],
        longitude: json['longitude'],
      );
}
