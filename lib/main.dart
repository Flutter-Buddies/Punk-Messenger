import 'package:flutter/material.dart';
import 'presentation/screens/welcome_screen.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/registration_screen.dart';
import 'presentation/screens/chat_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  await DotEnv.load();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // final FirebaseApp app = await Firebase.initializeApp(
  //   name: 'db2',
  //   options: new FirebaseOptions(
  //     projectId: 'punkmessenger', // ? Is this correct?
  //     appId: DotEnv.env['googleAppID'],
  //     apiKey: DotEnv.env['apiKey'],
  //     // databaseURL: DotEnv.env['databaseURL'],
  //   ),
  // );

  // TODO: Implement firestore https://firebase.flutter.dev/docs/firestore/usage/
  // FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      },
    );
  }
}
