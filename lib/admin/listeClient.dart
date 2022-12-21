// ignore_for_file: file_names, unused_import, prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logisoft_gsc/admin/carte.dart';
import 'package:logisoft_gsc/admin/pageclient.dart';
import 'package:logisoft_gsc/listesdesentretiens.dart';
import 'package:logisoft_gsc/users/pagedetailsclient.dart';
import 'package:logisoft_gsc/utils/clientModel.dart';

import '../utils/auth_helper.dart';

class ListeClient extends StatefulWidget {
  String userId;
  ListeClient({Key? key, required this.userId}) : super(key: key);

  @override
  State<ListeClient> createState() => _ListeClientState(userId);
}

class _ListeClientState extends State<ListeClient> {
  CollectionReference client = FirebaseFirestore.instance.collection('client');

  final clientControler = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  String _searchValue = "";
  List? filterClient = [];
  String userId;
  _ListeClientState(this.userId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeaeae8),
      appBar: AppBar(
        backgroundColor: const Color(0xff0e6324),
        toolbarHeight: 80,
        toolbarOpacity: 0.5,
        title: const Text('LISTE DES CLIENTS'),
        titleTextStyle: const TextStyle(
          fontFamily: 'Ubuntu',
          fontSize: 20,
          letterSpacing: -0.24,
          fontWeight: FontWeight.w700,
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => listesdesentretiens(
                            userId: userId,
                          )));
            },
            icon: Icon(Icons.arrow_back_rounded)),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => listesdesentretiens(
                        userId: userId,
                      )));
          return true;
        },
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Rechercher....',
                    hintStyle: GoogleFonts.ubuntu(
                      textStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 16),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.yellow),
                    )),
                onChanged: (value) {
                  setState(() {
                    _searchValue = value;
                    filterClient = filterClient
                        ?.where((element) =>
                            element['nomClt'].contains(_searchValue))
                        .toList();
                  });
                },
              ),
            ),
            ListTileTheme(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(0),
                      bottomLeft: Radius.circular(0))),
              tileColor: const Color(0xff0e6324),
              textColor: Colors.white,
              iconColor: Colors.white,
              child: StreamBuilder(
                  stream: client.snapshots(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot?> streamSnapshot) {
                    // if (streamSnapshot.hasData) {
                    //   List? data = streamSnapshot.data?.docs;
                    return (streamSnapshot.connectionState ==
                            ConnectionState.waiting)
                        ? const Center(child: CircularProgressIndicator())
                        : Expanded(
                            child: ListView.builder(
                                itemCount: streamSnapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  List? data = streamSnapshot.data!.docs;
                                  filterClient = data;
                                  if (filterClient?[index]["nomClt"]
                                      .contains(_searchValue)) {
                                    return Card(
                                      margin: const EdgeInsets.all(5),
                                      child: Column(
                                        children: [
                                          ListTile(
                                            leading: const CircleAvatar(
                                              backgroundColor:
                                                  Color.fromARGB(255, 8, 8, 8),
                                              child: Icon(
                                                Icons.note_alt,
                                                color: Colors.white,
                                              ),
                                            ),
                                            title: Text(
                                                "Client : " +
                                                    filterClient?[index]
                                                        ['nomClt'],
                                                style: GoogleFonts.ubuntu(
                                                  textStyle: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15),
                                                )),
                                            subtitle: Text(
                                                "Rep. Légal : ${filterClient?[index]['representant']}",
                                                style: GoogleFonts.ubuntu(
                                                  textStyle: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13),
                                                )),
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
                                                                        filterClient?[index]
                                                                            [
                                                                            'latitude'],
                                                                        filterClient?[index]
                                                                            [
                                                                            'longitude']),
                                                                  )));
                                                    },
                                                    icon: const Icon(
                                                        Icons.location_on,
                                                        size: 35.0)),
                                              ],
                                            ),
                                            onTap: () {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      PageDetailsClient(
                                                    docClient: streamSnapshot
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text("Téléphone : ",
                                                        style:
                                                            GoogleFonts.ubuntu(
                                                          textStyle: TextStyle(
                                                              color: Colors
                                                                  .grey[800],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: 15),
                                                        )),
                                                    Text(
                                                        "${filterClient?[index]['telephone']}",
                                                        style:
                                                            GoogleFonts.ubuntu(
                                                          textStyle: TextStyle(
                                                              color: Colors
                                                                  .grey[800],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15),
                                                        )),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  return Container();
                                }),
                          );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

Stream<List<Clients>> readClient() => FirebaseFirestore.instance
    .collection('clients')
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => Clients.fromJson(doc.data())).toList());
