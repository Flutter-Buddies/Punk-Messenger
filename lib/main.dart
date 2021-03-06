import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:punkmessenger/bloc/login_bloc.dart';
import 'package:punkmessenger/screens/welcome_screen.dart';
import 'package:punkmessenger/screens/login_screen.dart';
import 'package:punkmessenger/screens/registration_screen.dart';
import 'package:punkmessenger/screens/home_screen.dart';
import 'package:punkmessenger/screens/chat_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  await DotEnv.load();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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
      home: MultiBlocProvider(
        providers: [
          BlocProvider<LoginBloc>(
            create: (BuildContext context) => LoginBloc(),
          ),
        ],
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return (state is HasUser)
                ? HomeScreen()
                : WelcomeScreen();
          },
        ),
      ),
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
        HomeScreen.id: (context) => HomeScreen(),
      },
    );
  }
}
