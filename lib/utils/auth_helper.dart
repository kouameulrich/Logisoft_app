import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AuthHelper {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static signInWithEmail(
      {required String email, required String password}) async {
    final res = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    final User? user = res.user;
    return user;
  }

  static signupWithEmail(
      {required String email, required String password}) async {
    final res = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    final User? user = res.user;
    return user;
  }

  static signInWithGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    final acc = await googleSignIn.signIn();
    final auth = await acc?.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: auth?.accessToken, idToken: auth?.idToken);
    final res = await _auth.signInWithCredential(credential);
    return res.user;
  }

  static logOut() {
    GoogleSignIn().signOut();
    return _auth.signOut();
  }
}

class UserHelper {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static saveUser(User user) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    int buildNumber = int.parse(packageInfo.buildNumber);

    Map<String, dynamic> userData = {
      "name": user.displayName,
      "email": user.email,
      "last_login": user.metadata.lastSignInTime?.millisecondsSinceEpoch,
      "created_at": user.metadata.creationTime?.millisecondsSinceEpoch,
      "role": "user",
      "build_number": buildNumber,
    };
    final userRef = _db.collection("users").doc(user.uid);
    if ((await userRef.get()).exists) {
      await userRef.update({
        "last_login": user.metadata.lastSignInTime?.millisecondsSinceEpoch,
        "build_number": buildNumber,
      });
    } else {
      await _db.collection("users").doc(user.uid).set(userData);
    }
    // await _saveDevice(user);
  }

  // static _saveDevice(User user) async {
  //   DeviceInfoPlugin devicePlugin = DeviceInfoPlugin();
  //   String? deviceId;
  //   Map<String, dynamic> deviceData;
  //   if (Platform.isAndroid) {
  //     final deviceInfo = await devicePlugin.androidInfo;
  //     deviceId = deviceInfo.isPhysicalDevice as String?;
  //     deviceData = {
  //       "os_version": deviceInfo.version.sdkInt.toString(),
  //       "platform": 'android',
  //       "model": deviceInfo.model,
  //       "device": deviceInfo.device,
  //     };
  //   }
  //   if (Platform.isIOS) {
  //     final deviceInfo = await devicePlugin.iosInfo;
  //     deviceId = deviceInfo.identifierForVendor;
  //     deviceData = {
  //       "os_version": deviceInfo.systemVersion,
  //       "device": deviceInfo.name,
  //       "model": deviceInfo.utsname.machine,
  //       "platform": 'ios',
  //     };
  //   }
  //   final nowMS = DateTime.now().toUtc().millisecondsSinceEpoch;
  //   final deviceRef = _db
  //       .collection("users")
  //       .doc(user.uid)
  //       .collection("devices")
  //       .doc(deviceId);
  //   if ((await deviceRef.get()).exists) {
  //     await deviceRef.update({
  //       "updated_at": nowMS,
  //       "uninstalled": false,
  //     });
  //   } else {
  //     await deviceRef.set({
  //       "updated_at": nowMS,
  //       "uninstalled": false,
  //       "id": deviceId,
  //       "created_at": nowMS,
  //       // "device_info": deviceData,
  //     });
  //   }
  // }
}
