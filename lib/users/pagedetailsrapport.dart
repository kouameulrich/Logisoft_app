// ignore_for_file: no_logic_in_create_state, must_be_immutable, unnecessary_string_escapes, unnecessary_null_comparison, avoid_print

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:location/location.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:logisoft_gsc/admin/listeAdmin.dart';
import 'package:logisoft_gsc/admin/listeClient.dart';
import 'package:logisoft_gsc/listesdesentretiens.dart';
import 'package:logisoft_gsc/utils/button_widget.dart';
import 'package:logisoft_gsc/utils/firebase_api.dart';
import 'package:signature/signature.dart';
import 'package:path/path.dart' as p;

class PageDetails extends StatefulWidget {
  DocumentSnapshot docRapport;
  String userId;
  PageDetails({Key? key, required this.docRapport, required this.userId})
      : super(key: key);

  @override
  State<PageDetails> createState() => _PageDetailsState(userId);
}

class _PageDetailsState extends State<PageDetails> {
  TextEditingController controllerDatetime = TextEditingController();
  TextEditingController controllerClient = TextEditingController();
  TextEditingController controllerSociete = TextEditingController();
  TextEditingController controllerRapport = TextEditingController();

  CollectionReference docRapport =
      FirebaseFirestore.instance.collection('rapport');

  Location location = Location();

  Uint8List? uint8list;
  UploadTask? task;
  Uint8List? exportedImage;
  File? file;

  SignatureController controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.yellowAccent,
  );

  final format = DateFormat("yyyy-MM-dd HH:mm");
  DateTime dateTime = DateTime.now();

  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  String userId;

  _PageDetailsState(this.userId);

  @override
  void initState() {
    controllerDatetime = TextEditingController(
        text: widget.docRapport
            .get('datetime')
            .toDate()
            .toString()
            .substring(0, 16));
    controllerClient =
        TextEditingController(text: widget.docRapport.get('client'));
    controllerSociete =
        TextEditingController(text: widget.docRapport.get('societe'));
    controllerRapport =
        TextEditingController(text: widget.docRapport.get('rapport'));
    super.initState();
  }

  Future<bool?> showWarning(BuildContext context) async => showDialog<bool?>(
      context: context,
      builder: (context) => AlertDialog(
            title: Text('Voulez-vous annulez les modifications ?'),
            actions: [
              ElevatedButton(
                onPressed: (() => Navigator.pop(context)),
                child: Text('Non'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0e6324),
                ),
              ),
              ElevatedButton(
                onPressed: (() => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => listesdesentretiens(
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
    final fileName =
        file != null ? p.basename(file!.path) : 'Pas de fichier sélectionné';
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showWarning(context);
        return shouldPop ?? true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xffeaeae8),
        appBar: AppBar(
          backgroundColor: const Color(0xff0e6324),
          toolbarHeight: 80,
          toolbarOpacity: 0.5,
          title: const Text('RAPPORT'),
          titleTextStyle: const TextStyle(
            fontFamily: 'Ubuntu',
            fontSize: 20,
            letterSpacing: -0.24,
            fontWeight: FontWeight.w700,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: formKey,
            child: ListView(
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
                TextFormField(
                  textAlign: TextAlign.center,
                  controller: controllerClient,
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
                  textAlign: TextAlign.center,
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
                        if (controller.isEmpty) {
                          final Uint8List data =
                              (controller.toString()) as Uint8List;
                          if (data != null) {
                            //final base64 = base64Encode(data);
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: Image.memory(data),
                              ),
                            );
                          }
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
                        setState(() => controller.clear());
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

                    widget.docRapport.reference.update({
                      'datetime': DateTime.parse(controllerDatetime.text),
                      'client': controllerClient.text,
                      'societe': controllerSociete.text,
                      'rapport': controllerRapport.text,
                      'signature': controller.toString(),
                      'latitude': double.parse(lt),
                      'longitude': double.parse(lg),
                    }).whenComplete(() {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => listesdesentretiens(
                                    userId: userId,
                                  )));
                    });
                    signature();
                    uploadFile();
                  },
                  icon: const Icon(Icons.system_update_alt_outlined),
                  label: const Text(
                    'Mettre à jour rapport',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ],
            ),
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
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path!;
    setState(() => file = File(path));
  }

  signature() async {
    exportedImage = (controller.toString()) as Uint8List?;
    setState(() {});
  }

  Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
}
