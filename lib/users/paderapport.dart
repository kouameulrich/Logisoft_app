// ignore_for_file: depend_on_referenced_packages, unused_import, unnecessary_string_interpolations, prefer_const_constructors, use_build_context_synchronously, must_be_immutable

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:find_dropdown/find_dropdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logisoft_gsc/model/data.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:location/location.dart';
import 'package:location/location.dart' as loc;
import 'package:logisoft_gsc/utils/button_widget.dart';
import 'package:logisoft_gsc/utils/clientModel.dart';
import 'package:logisoft_gsc/utils/firebase_api.dart';
import 'package:signature/signature.dart';
import '../listesdesentretiens.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;

class PageRapport extends StatefulWidget {
  String userId;
  PageRapport({Key? key, required this.userId}) : super(key: key);

  @override
  State<PageRapport> createState() => _PageRapportState(userId);
}

class _PageRapportState extends State<PageRapport> {
  CollectionReference docRapport =
      FirebaseFirestore.instance.collection('rapport');

  final controllerDatetime = TextEditingController();
  final controllerClient = TextEditingController();
  final controllerSociete = TextEditingController();
  final controllerRapport = TextEditingController();

  List<DropdownMenuItem<String>> currencyItems = [];
  List currencyClient = [];

  String _searchValue = "";
  List? filterClient = [];

  Uint8List? exportedImage;
  File? file;
  String userId;

  SignatureController controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.yellowAccent,
  );

  Location location = Location();

  final format = DateFormat("yyyy-MM-dd HH:mm");
  DateTime dateTime = DateTime.now();

  PlatformFile? pickedFile;
  Uint8List? uint8list;
  UploadTask? task;
  String? userSelected;

  _PageRapportState(this.userId);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKeyValue = GlobalKey<FormState>();
    String? _SelectedType;
    var selectedCurrency, selectedType;
    final fileName =
        file != null ? p.basename(file!.path) : 'Pas de fichier sélectionné';

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: const Color(0xff0e6324),
          toolbarHeight: 80,
          toolbarOpacity: 0.5,
          title: const Text('Redaction de rapport'),
          titleTextStyle: const TextStyle(
            fontFamily: 'Ubuntu',
            fontSize: 20,
            letterSpacing: -0.24,
            fontWeight: FontWeight.w700,
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => listesdesentretiens(
                          userId: userId,
                        ))),
            icon: const Icon(Icons.arrow_back),
          ),
        ),
      ),
      backgroundColor: const Color(0xffffffff),
      body: SingleChildScrollView(
        child: Form(
          key: _formKeyValue,
          child: Column(
            children: [
              ListView(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                padding: const EdgeInsets.all(15),
                children: [
                  ////               DATE            ////
                  const Text(
                    'Date et Heure',
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      fontSize: 17,
                      color: Color(0xff050505),
                    ),
                    softWrap: false,
                  ),
                  DateTimeField(
                    controller: controllerDatetime,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: "Entrer la date et l'\heure",
                      hintStyle: TextStyle(color: Color(0xff0e6324)),
                      filled: true,
                      fillColor: Color(0x4a94b913),
                      suffixIcon: Icon(Icons.event_note),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: Color(0x4a94b913),
                        ),
                      ),
                    ),
                    format: format,
                    onShowPicker: (context, currentValue) async {
                      final date = await showDatePicker(
                          context: context,
                          initialDate: currentValue ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100));
                      if (date != null) {
                        final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                                currentValue ?? DateTime.now()));
                        return DateTimeField.combine(date, time);
                      } else {
                        return currentValue;
                      }
                    },
                  ),

                  const SizedBox(
                    height: 5,
                  ),

                  ////               CLIENT            ////
                  const Text(
                    'Client',
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      fontSize: 17,
                      color: Color(0xff050505),
                    ),
                    softWrap: false,
                  ),

                  // TypeAheadField(
                  //   noItemsFoundBuilder: (context) => const SizedBox(
                  //     height: 50,
                  //     child: Center(
                  //       child: Text('No Item Found'),
                  //     ),
                  //   ),
                  //   suggestionsBoxDecoration: const SuggestionsBoxDecoration(
                  //       color: Colors.white,
                  //       elevation: 4.0,
                  //       borderRadius: BorderRadius.only(
                  //         bottomLeft: Radius.circular(10),
                  //         bottomRight: Radius.circular(10),
                  //       )),
                  //   debounceDuration: const Duration(milliseconds: 400),
                  //   textFieldConfiguration: TextFieldConfiguration(
                  //       controller: controllerClient,
                  //       decoration: InputDecoration(
                  //           focusedBorder: const OutlineInputBorder(
                  //             borderSide: BorderSide(color: Colors.black),
                  //           ),
                  //           border: OutlineInputBorder(
                  //               borderRadius: BorderRadius.circular(
                  //             15.0,
                  //           )),
                  //           enabledBorder: const OutlineInputBorder(
                  //               borderRadius: BorderRadius.all(
                  //                 Radius.circular(5.0),
                  //               ),
                  //               borderSide: BorderSide(color: Colors.black)),
                  //           hintText: "Search",
                  //           contentPadding:
                  //               const EdgeInsets.only(top: 4, left: 10),
                  //           hintStyle: const TextStyle(
                  //               color: Colors.grey, fontSize: 14),
                  //           suffixIcon: IconButton(
                  //               onPressed: () {},
                  //               icon: const Icon(Icons.arrow_drop_down,
                  //                   color: Colors.grey)),
                  //           fillColor: Colors.white,
                  //           filled: true)),
                  //   suggestionsCallback: (value) {
                  //     return currencyClient.toList();
                  //   },
                  //   itemBuilder: (context, suggestion) {
                  //     return Row(
                  //       children: [
                  //         const SizedBox(
                  //           width: 10,
                  //         ),
                  //         const Icon(
                  //           Icons.refresh,
                  //           color: Colors.grey,
                  //         ),
                  //         const SizedBox(
                  //           width: 10,
                  //         ),
                  //         Flexible(
                  //           child: Padding(
                  //             padding: const EdgeInsets.all(6.0),
                  //             child: Text(
                  //               suggestion.toString(),
                  //               maxLines: 1,
                  //               overflow: TextOverflow.ellipsis,
                  //             ),
                  //           ),
                  //         )
                  //       ],
                  //     );
                  //   },
                  //   onSuggestionSelected: (suggestion) {
                  //     controllerClient.text = suggestion.toString();
                  //   },
                  // ),

                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("client")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) const Text("Loading.....");
                        Object test = snapshot.data ?? "";
                        for (int i = 0; i < snapshot.data!.docs.length; i++) {
                          DocumentSnapshot snap = snapshot.data!.docs[i];
                          currencyItems.add(
                            DropdownMenuItem(
                              value: "${snap.get('nomClt')}",
                              child: Text(
                                snap.get('nomClt'),
                                style: TextStyle(color: Color(0xff0e6324)),
                              ),
                            ),
                          );
                        }
                        return StatefulBuilder(
                          builder: (BuildContext context,
                              void Function(void Function()) setState) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Icon(FontAwesomeIcons.peopleGroup,
                                    size: 25.0, color: Colors.black),
                                SizedBox(width: 50.0),
                                Expanded(
                                  child: DropdownButton(
                                    items: currencyItems.toList(),
                                    onChanged: (currencyValue) {
                                      final snackBar = SnackBar(
                                        content: Text(
                                          'Le client selectionné est $currencyValue',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                      setState(() {
                                        selectedCurrency = currencyValue;
                                      });
                                    },
                                    value: selectedCurrency,
                                    isExpanded: true,
                                    hint: Text(
                                      "Selectioné un client",
                                      style:
                                          TextStyle(color: Color(0xff0e6324)),
                                    ),
                                    icon: Padding(
                                        //Icon at tail, arrow bottom is default icon
                                        padding: EdgeInsets.only(left: 20),
                                        child: Icon(
                                            Icons.arrow_circle_down_sharp)),
                                    iconEnabledColor:
                                        Color(0xff0e6324), //Icon color
                                    style: TextStyle(
                                        //te
                                        color: Colors.white, //Font color
                                        fontSize:
                                            20 //font size on dropdown button
                                        ),
                                    // underline: Container(), //remove underline
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }),

                  const SizedBox(
                    height: 5,
                  ),

                  ////               PERSONNE VISITEE            ////
                  const Text(
                    'Personne rencontrée',
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      fontSize: 17,
                      color: Color(0xff050505),
                    ),
                    softWrap: false,
                  ),
                  TextFormField(
                    textAlign: TextAlign.center,
                    controller: controllerSociete,
                    autofocus: false,
                    obscureText: false,
                    decoration: const InputDecoration(
                      hintText: 'Personne rencontrée',
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

                  ////               RAPPORT            ////
                  const Text(
                    'Rapport',
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      fontSize: 17,
                      color: Color(0xff050505),
                    ),
                    softWrap: false,
                  ),
                  TextField(
                    minLines: 5,
                    maxLines: 500,
                    keyboardType: TextInputType.multiline,
                    textAlign: TextAlign.left,
                    controller: controllerRapport,
                    autofocus: false,
                    obscureText: false,
                    decoration: const InputDecoration(
                      hintText: 'Votre rapport',
                      hintStyle: TextStyle(color: Color(0xff0e6324)),
                      filled: true,
                      fillColor: Color(0x4a94b913),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(10),
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
                    height: 10,
                  ),

                  ////               SIGNATURE            ////
                  const Text(
                    'Signature',
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      fontSize: 17,
                      color: Color(0xff050505),
                    ),
                    softWrap: false,
                  ),
                  Signature(
                    height: 125.0,
                    controller: controller,
                    backgroundColor: const Color(0x4a94b913),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.check_circle_outline,
                          size: 40,
                        ),
                        color: Colors.green,
                        onPressed: () async {
                          if (controller.isNotEmpty) {
                            final Uint8List? data =
                                await controller.toPngBytes();
                            print(data);
                          }
                        },
                      ),
                      const SizedBox(
                        width: 100,
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.clear,
                          size: 40,
                        ),
                        color: Colors.red,
                        onPressed: () {
                          controller!.clear();
                        },
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  ////               FICHIER            ////
                  Column(
                    children: [
                      ButtonWidget(
                        text: 'Joindre un fichier',
                        icon: Icons.attach_file,
                        onClicked: selectFile,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        fileName,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 15,
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
                      final rapport = Rapport(
                        datetime: DateTime.parse(controllerDatetime.text),
                        client: selectedCurrency,
                        societe: controllerSociete.text,
                        rapport: controllerRapport.text,
                        dateajout: DateTime.now(),
                        signature: controller.toString(),
                        latitude: double.parse(lt),
                        longitude: double.parse(lg),
                        userId: userId,
                      );

                      signature();
                      uploadFile();
                      createRapport(rapport);
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.save_alt),
                    label: const Text(
                      'Enregistrer rapport',
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

  Future uploadFile() async {
    if (file == null) return;
    final fileName = p.basename(file!.path);
    final destination = 'files/$fileName';
    task = FirebaseApi.uploadFile(destination, file!);

    if (task == null) return;
    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print('Download-Link: $urlDownload');
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path!;
    file = File(path);
  }

  signature() async {
    exportedImage = (controller.toString()) as Uint8List?;
    setState(() {});
  }

  Future createRapport(Rapport rapport) async {
    final docRapport = FirebaseFirestore.instance.collection('rapport').doc();
    rapport.id = docRapport.id;
    final json = rapport.toJson();
    await docRapport.set(json);
    Fluttertoast.showToast(
        msg: "Enregistrement de rapport éffectué avec succès !!!");
  }

  Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
}

class Rapport {
  String id;
  final DateTime datetime;
  final DateTime dateajout;
  final String client;
  final String societe;
  final String rapport;
  final String signature;
  final double latitude;
  final double longitude;
  final String userId;

  Rapport({
    this.id = '',
    required this.datetime,
    required this.dateajout,
    required this.client,
    required this.societe,
    required this.rapport,
    required this.signature,
    required this.latitude,
    required this.longitude,
    required this.userId,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'datetime': datetime,
        'dateajout': dateajout,
        'client': client,
        'societe': societe,
        'rapport': rapport,
        'signature': signature,
        'latitude': latitude,
        'longitude': longitude,
        'userId': userId,
      };

  static Rapport fromJson(Map<String, dynamic> json) => Rapport(
        datetime: (json['datetime'] as Timestamp).toDate(),
        dateajout: (json['dateajout'] as Timestamp).toDate(),
        client: json['client'],
        societe: json['societe'],
        rapport: json['rapport'],
        signature: json['signature'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        userId: json['userId'],
      );
}
