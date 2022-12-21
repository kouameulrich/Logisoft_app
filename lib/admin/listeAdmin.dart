// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_const_constructors, non_constant_identifier_names, duplicate_ignore, body_might_complete_normally_nullable, prefer_adjacent_string_concatenation, unused_import, prefer_typing_uninitialized_variables, unused_local_variable, must_be_immutable, unused_element, no_logic_in_create_state, unnecessary_import, file_names, depend_on_referenced_packages, sort_child_properties_last, avoid_print, prefer_final_fields, use_build_context_synchronously

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logisoft_gsc/admin/carte.dart';
import 'package:logisoft_gsc/admin/filtrerapport.dart';
import 'package:logisoft_gsc/admin/listeClient.dart';
import 'package:logisoft_gsc/admin/pageclient.dart';
import 'package:logisoft_gsc/listesdesentretiens.dart';
import 'package:logisoft_gsc/pagedeconnexion.dart';
import 'package:logisoft_gsc/users/pagedetailsrapport.dart';
import 'package:logisoft_gsc/utils/auth_helper.dart';
import 'package:logisoft_gsc/utils/clientModel.dart';
import '../users/paderapport.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:intl/intl.dart';
import 'package:dropdown_search/dropdown_search.dart';

class ListesAdmin extends StatefulWidget {
  String userId;
  ListesAdmin({Key? key, required this.userId}) : super(key: key);

  @override
  State<ListesAdmin> createState() => _ListesAdmin(userId);
}

class _ListesAdmin extends State<ListesAdmin> {
  final CollectionReference rapport =
      FirebaseFirestore.instance.collection('rapport');

  final CollectionReference client =
      FirebaseFirestore.instance.collection('client');

  final CollectionReference parametre =
      FirebaseFirestore.instance.collection('parametre');

  final controllerDatetime = TextEditingController();
  final controllerClient = TextEditingController();
  final controllerSociete = TextEditingController();
  final controllerRapport = TextEditingController();

  TextEditingController? _searchController = TextEditingController();
  String _searchValue = "";
  List clients = [];
  List rapports = [];
  List? filterClient = [];
  List? filterParam = [];
  bool donneok = false;
  bool _isDeleting = false;

  var clientrapport, Param;

  String userId;

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  _ListesAdmin(this.userId);

  Future<void> update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      controllerDatetime.text = documentSnapshot['datetime'].toString();
      controllerClient.text = documentSnapshot['client'];
      controllerSociete.text = documentSnapshot['societe'];
      controllerRapport.text = documentSnapshot['rapport'];
    }
  }

  String value = "";
  int? distancealerte;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    //
  }

  ///CALCUL DE DISTANCE
  @override
  Widget build(BuildContext context) {
    double distance = 0.0;
    calculateDistance(
        latitudeClient, longitudeClient, latitudeRapport, longitudeRapport) {
      var p = 0.017453292519943295;
      var c = cos;
      var d;
      var a = 0.5 -
          c((latitudeRapport - latitudeClient) * p) / 2 +
          c(latitudeClient * p) *
              c(latitudeRapport * p) *
              (1 - c((longitudeRapport - longitudeClient) * p)) /
              2;
      d = 12742 * asin(sqrt(a));
      int i = d.toInt();
      return i;
    }

    recherchedate() {}

    return Scaffold(
      backgroundColor: const Color(0xffeaeae8),
      appBar: AppBar(
        backgroundColor: const Color(0xff0e6324),
        toolbarHeight: 80,
        toolbarOpacity: 0.5,
        title: const Text('LISTE DES RAPPORTS'),
        titleTextStyle: const TextStyle(
          fontFamily: 'Ubuntu',
          fontSize: 20,
          letterSpacing: -0.24,
          fontWeight: FontWeight.w700,
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () => AuthHelper.logOut(),
            icon: Image.asset('assets/images/deconnection.png')),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.black,
        overlayColor: Colors.black,
        overlayOpacity: 0.4,
        children: [
          SpeedDialChild(
            // ignore: deprecated_member_use
            child: Icon(FontAwesomeIcons.edit),
            backgroundColor: Colors.lightGreen,
            label: 'Ajout de Rapport',
            labelStyle: GoogleFonts.ubuntu(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PageRapport(
                          userId: userId,
                        ))),
          ),
          SpeedDialChild(
            child: Icon(FontAwesomeIcons.person),
            backgroundColor: Colors.yellow,
            labelStyle: GoogleFonts.ubuntu(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
            label: 'Ajout de Client',
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PageClient(
                          userId: userId,
                        ))),
          ),
          SpeedDialChild(
            child: Icon(FontAwesomeIcons.tableList),
            backgroundColor: Colors.green,
            label: 'Liste des Clients',
            labelStyle: GoogleFonts.ubuntu(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ListeClient(
                          userId: userId,
                        ))),
          ),
          SpeedDialChild(
            child: Icon(FontAwesomeIcons.noteSticky),
            backgroundColor: Colors.green,
            label: 'Liste des Rapports',
            labelStyle: GoogleFonts.ubuntu(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => listesdesentretiens(
                          userId: userId,
                        ))),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12),
            alignment: Alignment.centerLeft,
            child: TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Rechercher....',
                  hintStyle: GoogleFonts.ubuntu(
                    textStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 16),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.yellow),
                  )),
              onChanged: (value) {
                print(value);
                setState(() {
                  _searchValue = value;
                  filterClient = filterClient
                      ?.where(
                          (element) => element['userId'].contains(_searchValue))
                      .toList();
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Text("Du",
                          style: GoogleFonts.ubuntu(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        // ignore: sort_child_properties_last
                        child: Text(
                            '${startDate.year}/${startDate.month}/${startDate.day}'),
                        onPressed: () async {
                          DateTime? newDate = await showDatePicker(
                            context: context,
                            initialDate: startDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (newDate == null) return;
                          setState(() {
                            startDate = newDate;
                          });
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green),
                            padding:
                                MaterialStateProperty.all(EdgeInsets.all(10)),
                            textStyle: MaterialStateProperty.all(
                                TextStyle(fontSize: 15))),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Text("Au",
                          style: GoogleFonts.ubuntu(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        child: Text(
                            '${endDate.year}/${endDate.month}/${endDate.day}'),
                        onPressed: () async {
                          DateTime? newDate = await showDatePicker(
                            context: context,
                            initialDate: endDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (newDate == null) return;
                          setState(() {
                            endDate = newDate;
                          });
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green),
                            padding:
                                MaterialStateProperty.all(EdgeInsets.all(10)),
                            textStyle: MaterialStateProperty.all(
                                TextStyle(fontSize: 15))),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ListTileTheme(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(0),
                        bottomLeft: Radius.circular(0))),
                tileColor: Color(0xff0e6324),
                textColor: Colors.white,
                iconColor: Colors.white,
                child: StreamBuilder(
                    stream: rapport.snapshots(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot> streamSnapshot1) {
                      if (streamSnapshot1.hasData) {
                        ///POUR RECHERHCE///
                        List? data = streamSnapshot1.data?.docs;
                        filterClient = data ?? [];
                        // print('data1: $data');
                        return StreamBuilder(
                            stream: parametre.snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot3) {
                              List? data3 = snapshot3.data?.docs;
                              filterParam = data3 ?? [];
                              distancealerte =
                                  filterParam?[0]['distancealerte'];
                              // print(distancealerte);
                              return StreamBuilder(
                                stream: client.snapshots(),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot> snapshot2) {
                                  List? data2 = snapshot2.data?.docs;
                                  if (filterClient!.isEmpty) {
                                    return const Text('Pas de donnée');
                                  } else {
                                    return ListView.builder(
                                      itemCount: filterClient!.length,
                                      itemBuilder: (context, index) {
                                        var clt =
                                            filterClient?[index]['client'];
                                        // print('clt: $clt');
                                        if (data2 != null) {
                                          try {
                                            clientrapport = data2.firstWhere(
                                                (client) =>
                                                    client['nomClt'] == clt);
                                          } catch (e) {
                                            print(e);
                                          }
                                        }
                                        donneok = false;
                                        if (filterClient?[index]["userId"]
                                            .contains(_searchValue)) {
                                          if ((filterClient?[index]['datetime'])
                                                  .toDate()
                                                  .isAfter(startDate) &&
                                              (filterClient?[index]['datetime'])
                                                  .toDate()
                                                  .isBefore(endDate)) {
                                            donneok = true;
                                            return Card(
                                              margin: const EdgeInsets.all(5),
                                              child: Column(
                                                children: [
                                                  ListTile(
                                                    leading: const CircleAvatar(
                                                      backgroundColor:
                                                          Color.fromARGB(
                                                              255, 8, 8, 8),
                                                      child: Icon(
                                                        Icons.note_alt,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    title: Text(
                                                        "Client : " +
                                                            filterClient?[index]
                                                                ['client'],
                                                        // ignore: prefer_const_constructors
                                                        style:
                                                            GoogleFonts.ubuntu(
                                                          textStyle: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15),
                                                        )),
                                                    subtitle: Text(
                                                        "Rep. Légal : ${filterClient?[index]['societe']}",
                                                        style:
                                                            GoogleFonts.ubuntu(
                                                          textStyle: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 13),
                                                        )),
                                                    trailing: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        IconButton(
                                                            onPressed: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          CurrentLocationScreen(
                                                                            latLng:
                                                                                LatLng(filterClient?[index]['latitude'], filterClient?[index]['longitude']),
                                                                          )));
                                                            },
                                                            icon: const Icon(
                                                              Icons.location_on,
                                                              size: 35.0,
                                                            )),

                                                        /////ALERTE//////
                                                        Container(
                                                          child: calculateDistance(
                                                                      filterClient?[
                                                                              index]
                                                                          [
                                                                          'latitude'],
                                                                      filterClient?[
                                                                              index]
                                                                          [
                                                                          'longitude'],
                                                                      clientrapport[
                                                                          'latitude'],
                                                                      clientrapport[
                                                                          'longitude']) <=
                                                                  distancealerte!
                                                              ? Text('')
                                                              : Icon(
                                                                  Icons
                                                                      .warning_amber_rounded,
                                                                  size: 35.0,
                                                                  color: Colors
                                                                      .yellow),
                                                        ),
                                                        IconButton(
                                                            onPressed:
                                                                () async {
                                                              showDialog<bool?>(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) =>
                                                                          AlertDialog(
                                                                            title:
                                                                                Text('Voulez-vous supprimer ce rapport ?'),
                                                                            actions: [
                                                                              ElevatedButton(
                                                                                onPressed: (() => Navigator.of(context).pop()),
                                                                                child: Text('Non'),
                                                                                style: ElevatedButton.styleFrom(
                                                                                  backgroundColor: const Color(0xff0e6324),
                                                                                ),
                                                                              ),
                                                                              ElevatedButton(
                                                                                onPressed: () {
                                                                                  deleteRapport(streamSnapshot1.data?.docs[index].id);
                                                                                  return Navigator.of(context).pop();
                                                                                },
                                                                                child: Text('Oui'),
                                                                                style: ElevatedButton.styleFrom(
                                                                                  backgroundColor: const Color(0xff0e6324),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ));
                                                            },
                                                            icon: Icon(
                                                              Icons
                                                                  .delete_outline,
                                                              size: 35.0,
                                                            )),
                                                      ],
                                                    ),
                                                    onTap: () {
                                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (_) =>
                                                              PageDetails(
                                                            docRapport:
                                                                streamSnapshot1
                                                                        .data!
                                                                        .docs[
                                                                    index],
                                                            userId: userId,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                                "Rapport du : ",
                                                                style:
                                                                    GoogleFonts
                                                                        .ubuntu(
                                                                  textStyle: TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          800],
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize:
                                                                          14),
                                                                )),
                                                            Text(
                                                                "${filterClient?[index]['datetime'].toDate().toString().substring(0, 10)}",
                                                                style:
                                                                    GoogleFonts
                                                                        .ubuntu(
                                                                  textStyle: TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          800],
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          14),
                                                                )),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text("Créé le : ",
                                                                style:
                                                                    GoogleFonts
                                                                        .ubuntu(
                                                                  textStyle: TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          800],
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize:
                                                                          14),
                                                                )),
                                                            Text(
                                                                "${filterClient?[index]['dateajout'].toDate().toString().substring(0, 16)}",
                                                                style:
                                                                    GoogleFonts
                                                                        .ubuntu(
                                                                  textStyle: TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          800],
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          14),
                                                                )),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                                "Distance rapport - client : ",
                                                                style:
                                                                    GoogleFonts
                                                                        .ubuntu(
                                                                  textStyle: TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          800],
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize:
                                                                          14),
                                                                )),
                                                            Text(
                                                                "${calculateDistance(filterClient?[index]['latitude'], filterClient?[index]['longitude'], clientrapport['latitude'], clientrapport['longitude'])}" +
                                                                    " m",
                                                                style:
                                                                    GoogleFonts
                                                                        .ubuntu(
                                                                  textStyle: TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          800],
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          14),
                                                                )),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8.0,
                                                            bottom: 8.0),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text("Créé par : ",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: GoogleFonts
                                                                  .ubuntu(
                                                                textStyle: TextStyle(
                                                                    color: Colors
                                                                            .grey[
                                                                        800],
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize:
                                                                        14),
                                                              )),
                                                          Text(
                                                              "${filterClient?[index]['userId']}",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: GoogleFonts
                                                                  .ubuntu(
                                                                textStyle: TextStyle(
                                                                    color: Colors
                                                                            .grey[
                                                                        800],
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        14),
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  )
                                                ],
                                              ),
                                            );
                                          }
                                        }
                                        return Container(
                                            // child: Text('Pas de donnée'),
                                            );
                                      },
                                    );
                                  }
                                },
                              );
                            });
                      }
                      return const Center(child: CircularProgressIndicator());
                    }),
              ),
            ),
          ),
          donneok == false
              ? Text("Pas de donnée",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.ubuntu(
                    textStyle: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ))
              : Container(),
        ],
      ),
    );
  }

  void deleteRapport(id) {
    FirebaseFirestore.instance.collection('rapport').doc(id).delete();
    Fluttertoast.showToast(msg: "Rapport supprimer avec succès !!!");
  }

  Future showToast(String message) async {
    await Fluttertoast.cancel();

    Fluttertoast.showToast(msg: message, fontSize: 18);
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => pagedeconnexion(),
        ),
        (route) => false);
    return;
  }

  Future<DateTime?> pickDate() async {
    showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
  }

  Future<DateTime?> firstDate() async {
    showDatePicker(
        context: context,
        initialDate: startDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
  }
}

Stream<List<Rapport>> readRapport() => FirebaseFirestore.instance
    .collection('rapport')
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => Rapport.fromJson(doc.data())).toList());
