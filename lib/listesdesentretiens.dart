// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_const_constructors, no_logic_in_create_state, use_build_context_synchronously, camel_case_types, await_only_futures, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logisoft_gsc/pagedeconnexion.dart';
import 'package:logisoft_gsc/users/pagedetailsrapport.dart';
import 'package:logisoft_gsc/utils/auth_helper.dart';

import 'admin/listeClient.dart';
import 'admin/pageclient.dart';
import 'users/paderapport.dart';

class listesdesentretiens extends StatefulWidget {
  String userId;
  listesdesentretiens({Key? key, required this.userId}) : super(key: key);

  @override
  State<listesdesentretiens> createState() => _listesdesentretiensState(userId);
}

class _listesdesentretiensState extends State<listesdesentretiens> {
  final CollectionReference rapport =
      FirebaseFirestore.instance.collection('rapport');

  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  String userId;

  _listesdesentretiensState(this.userId);

  final controllerDatetime = TextEditingController();
  final controllerClient = TextEditingController();
  final controllerSociete = TextEditingController();
  final controllerRapport = TextEditingController();

  Future<void> update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      controllerDatetime.text = documentSnapshot['datetime'].toString();
      controllerClient.text = documentSnapshot['client'];
      controllerSociete.text = documentSnapshot['societe'];
      controllerRapport.text = documentSnapshot['rapport'];
    }
  }

  DateTime timeBackPressed = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xffeaeae8),
        appBar: AppBar(
          backgroundColor: const Color(0xff0e6324),
          toolbarHeight: 80,
          toolbarOpacity: 0.5,
          title: const Text('LISTES DES RAPPORTS'),
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
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
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
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
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
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ListeClient(
                            userId: userId,
                          ))),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
                          AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                        if (streamSnapshot.hasData) {
                          return ListView.builder(
                              itemCount: streamSnapshot.data?.docs.length,
                              // physics: ScrollPhysics(),
                              itemBuilder: (context, index) {
                                final DocumentSnapshot documentSnapshot =
                                    streamSnapshot.data!.docs[index];
                                if (documentSnapshot['userId'] == userId) {
                                  return Card(
                                    margin: const EdgeInsets.all(5),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          leading: const CircleAvatar(
                                            backgroundColor: Colors.black,
                                            child: Icon(
                                              Icons.note_alt,
                                              color: Colors.white,
                                            ),
                                          ),
                                          title: Row(
                                            children: [
                                              Text("Client: ",
                                                  style: GoogleFonts.ubuntu(
                                                    textStyle: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15),
                                                  )),
                                              Text(documentSnapshot['client'],
                                                  style: GoogleFonts.ubuntu(
                                                    textStyle: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15),
                                                  )),
                                            ],
                                          ),
                                          subtitle: Row(
                                            children: [
                                              Text("Rep. Légal: ",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13)),
                                              Text(
                                                  "${documentSnapshot['societe']}",
                                                  style: GoogleFonts.ubuntu(
                                                    textStyle: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13),
                                                  )),
                                            ],
                                          ),
                                          onTap: () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => PageDetails(
                                                  docRapport: streamSnapshot
                                                      .data!.docs[index],
                                                  userId: userId,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Rapport du :",
                                                  style: GoogleFonts.ubuntu(
                                                    textStyle: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 14),
                                                  )),
                                              Text(
                                                  documentSnapshot['datetime']
                                                      .toDate()
                                                      .toString()
                                                      .substring(0, 10),
                                                  style: GoogleFonts.ubuntu(
                                                    textStyle: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14),
                                                  )),
                                              Text("Créé le :",
                                                  style: GoogleFonts.ubuntu(
                                                    textStyle: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 14),
                                                  )),
                                              Text(
                                                  documentSnapshot['dateajout']
                                                      .toDate()
                                                      .toString()
                                                      .substring(0, 16),
                                                  style: GoogleFonts.ubuntu(
                                                    textStyle: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 14),
                                                  )),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text("Créé par : ",
                                                  textAlign: TextAlign.left,
                                                  style: GoogleFonts.ubuntu(
                                                    textStyle: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 14),
                                                  )),
                                              Text(userId,
                                                  textAlign: TextAlign.left,
                                                  style: GoogleFonts.ubuntu(
                                                    textStyle: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14),
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return Text('');
                                }
                              });
                        }
                        return const Center(child: CircularProgressIndicator());
                      }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

  Future<String?> getUserEmail() async {
    return (await _auth.currentUser!.email);
  }
}

Stream<List<Rapport>> readRapport() => FirebaseFirestore.instance
    .collection('rapport')
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => Rapport.fromJson(doc.data())).toList());
