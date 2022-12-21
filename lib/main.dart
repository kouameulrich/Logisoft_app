// ignore_for_file: prefer_const_constructors, unused_import, depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logisoft_gsc/admin/listeAdmin.dart';
import 'package:logisoft_gsc/admin/pageclient.dart';
import 'package:logisoft_gsc/listesdesentretiens.dart';
import 'package:logisoft_gsc/pagedeconnexion.dart';
import 'package:logisoft_gsc/utils/auth_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            UserHelper.saveUser(snapshot.data!);
            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(snapshot.data!.uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  final userDoc = snapshot.data;
                  final user = userDoc?.data() as Map<String, dynamic>;
                  if (user['role'] == 'admin') {
                    return ListesAdmin(
                      userId: user["email"],
                    );
                  } else {
                    return listesdesentretiens(
                      userId: user["email"],
                    );
                  }
                } else {
                  return const Material(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            );
          }
          return pagedeconnexion();
        });
  }
}
