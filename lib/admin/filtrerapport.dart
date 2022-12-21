// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_unnecessary_containers, unused_import, must_be_immutable, no_logic_in_create_state

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logisoft_gsc/admin/carte.dart';
import 'package:logisoft_gsc/users/paderapport.dart';
import 'package:logisoft_gsc/users/pagedetailsrapport.dart';

class FiltreRapport extends StatefulWidget {
  String userId;
  FiltreRapport({Key? key, required this.userId}) : super(key: key);

  @override
  State<FiltreRapport> createState() => _FiltreRapportState(userId);
}

class _FiltreRapportState extends State<FiltreRapport> {
  final TextEditingController searchController = TextEditingController();
  QuerySnapshot? snapshotData;
  bool isExcecuted = false;

  final CollectionReference rapport =
      FirebaseFirestore.instance.collection('rapport');

  final controllerDatetime = TextEditingController();
  final controllerClient = TextEditingController();
  final controllerSociete = TextEditingController();
  final controllerRapport = TextEditingController();

  String userId;

  _FiltreRapportState(this.userId);

  Future<void> update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      controllerDatetime.text = documentSnapshot['datetime'].toString();
      controllerClient.text = documentSnapshot['client'];
      controllerSociete.text = documentSnapshot['societe'];
      controllerRapport.text = documentSnapshot['rapport'];
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget searchedData() {
      return ListTileTheme(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10))),
          tileColor: Colors.green,
          textColor: Colors.white,
          iconColor: Colors.white,
          child: StreamBuilder(
              stream: rapport.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  return ListView.builder(
                      itemCount: streamSnapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot documentSnapshot =
                            streamSnapshot.data!.docs[index];
                        return Card(
                          margin: const EdgeInsets.all(5),
                          child: Column(
                            children: [
                              ListTile(
                                leading: const CircleAvatar(
                                  backgroundColor: Color(0xff0e6324),
                                  child: Icon(
                                    Icons.note_alt,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(
                                    "Client : " + documentSnapshot['client'],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17)),
                                subtitle: Text(
                                    "Rep. Legal : ${documentSnapshot['societe']}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14)),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CurrentLocationScreen(
                                                        latLng: LatLng(
                                                            documentSnapshot[
                                                                'latitude'],
                                                            documentSnapshot[
                                                                'longitude']),
                                                      )));
                                        },
                                        icon: const Icon(Icons.location_on)),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PageDetails(
                                        docRapport:
                                            streamSnapshot.data!.docs[index],
                                        userId: userId,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Text(
                                      "Rapport du : ${documentSnapshot['datetime'].toDate().toString().substring(0, 10)}",
                                      // textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      "Créé le : ${documentSnapshot['dateajout'].toDate().toString().substring(0, 16)}",
                                      // textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Text(
                                    "Créé par : ${documentSnapshot['userId']}",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14)),
                              ),
                            ],
                          ),
                        );
                      });
                }
                return const Center(child: CircularProgressIndicator());
              }));
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          GetBuilder<DataController>(
            init: DataController(),
            builder: (val) {
              return IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  val.queryData(searchController.text).then((value) {
                    snapshotData = value;
                    setState(() {
                      isExcecuted = true;
                    });
                  });
                },
              );
            },
          ),
        ],
      ),
      body: isExcecuted
          ? searchedData()
          : Container(
              child: Center(
                child: Text('Search any users'),
              ),
            ),
    );
  }
}

class DataController extends GetxController {
  Future getData(String collection) async {
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot =
        await firebaseFirestore.collection(collection).get();
    return snapshot.docs;
  }

  Future queryData(String queryString) async {
    return FirebaseFirestore.instance
        .collection('rapport')
        .where('userId', isGreaterThanOrEqualTo: queryString)
        .get();
  }
}

Stream<List<Rapport>> readRapport() => FirebaseFirestore.instance
    .collection('rapport')
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => Rapport.fromJson(doc.data())).toList());
