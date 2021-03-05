import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:punkmessenger/bloc/login_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash_screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  Auth auth;
  bool loggedIn = false;
  String errorMessage = "";

  Widget get signInErrorMsg => Container(
        padding: EdgeInsets.all(10),
        child: Center(
          child: RichText(
            text: TextSpan(
              text: errorMessage,
              style: TextStyle(color: Colors.red),
            ),
          ),
        ),
      );

  @override
  void initState() {
    super.initState();
    auth = Auth(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
      listener: (user) {
        loggedIn = user != null;
        setState(() {});
      },
      listen: (account) {
        loggedIn = account != null;
        setState(() {});
      },
    );

    auth.signInSilently();

    controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);
    controller.forward();
    controller.addListener(
      () {
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    auth.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: _buildBody(context),
      ),
    );
  }

  Column _buildBody(BuildContext context) {
    if (loggedIn) {
      context.read<LoginBloc>().add(
            SetUser(user: auth),
          );
      return Column();
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  child: Image.asset('images/logo.png'),
                  height: 120.0,
                ),
              ),
              Text(
                "Punk Messenger",
                style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      );
    }
  }
}
