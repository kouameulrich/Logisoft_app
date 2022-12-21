import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:location/location.dart';
import 'package:logisoft_gsc/admin/listeClient.dart';

import '../listesdesentretiens.dart';

class PageDetailsClient extends StatefulWidget {
  DocumentSnapshot docClient;
  String userId;
  PageDetailsClient({Key? key, required this.docClient, required this.userId})
      : super(key: key);

  @override
  State<PageDetailsClient> createState() => _PageDetailsClientState(userId);
}

class _PageDetailsClientState extends State<PageDetailsClient> {
  CollectionReference docRapport =
      FirebaseFirestore.instance.collection('client');

  TextEditingController nomcltController = TextEditingController();
  TextEditingController representantController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  String userId;
  double? lati;
  double? longi;

  Location location = Location();
  getPosition() async {
    final currentPosition = await location.getLocation();
    var lt = currentPosition.latitude.toString().replaceAll(RegExp(","), ".");
    var lg = currentPosition.longitude.toString().replaceAll(RegExp(","), ".");
  }

  _PageDetailsClientState(this.userId);

  @override
  void initState() {
    nomcltController =
        TextEditingController(text: widget.docClient.get('nomClt'));
    representantController =
        TextEditingController(text: widget.docClient.get('representant'));
    telephoneController =
        TextEditingController(text: widget.docClient.get('telephone'));
    latitudeController = TextEditingController(
        text: widget.docClient.get('latitude').toString());
    longitudeController = TextEditingController(
        text: widget.docClient.get('longitude').toString());

    // TODO: implement initState
    super.initState();
  }

  Future<bool?> showWarning(BuildContext context) async => showDialog<bool?>(
      context: context,
      builder: (context) => AlertDialog(
            title: Text('Voulez-vous annulez les modifications ?'),
            actions: [
              ElevatedButton(
                onPressed: (() => Navigator.of(context).pop()),
                child: Text('Non'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0e6324),
                ),
              ),
              ElevatedButton(
                onPressed: (() => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ListeClient(
                              userId: userId,
                            )))),
                child: Text('Oui'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0e6324),
                ),
              ),
            ],
          ));

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showWarning(context);
        return shouldPop ?? false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xffeaeae8),
        appBar: AppBar(
          backgroundColor: const Color(0xff0e6324),
          toolbarHeight: 80,
          toolbarOpacity: 0.5,
          title: const Text('CLIENT'),
          titleTextStyle: const TextStyle(
            fontFamily: 'Ubuntu',
            fontSize: 20,
            letterSpacing: -0.24,
            fontWeight: FontWeight.w700,
          ),
          centerTitle: true,
        ),
        // ignore: prefer_const_constructors
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
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
                            enabled: false,
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
                            enabled: false,
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
                        widget.docClient.reference.update({
                          'nomClt': nomcltController.text,
                          'representant': representantController.text,
                          'telephone': telephoneController.text,
                        }).whenComplete(() {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ListeClient(
                                        userId: userId,
                                      )));
                        });
                      },
                      icon: const Icon(Icons.save_alt),
                      label: const Text(
                        'Metter à jour client',
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
      ),
    );
  }
}
