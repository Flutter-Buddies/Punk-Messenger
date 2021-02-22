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

  Widget get _authResults => ListView(
        // padding: const EdgeInserts.all(30.0),
        itemExtent: 80.0,
        children: <Widget>[
          Text("uid: ${auth.uid}"),
          Text("name: ${auth.displayName}"),
          Text("photo: ${auth.photoUrl}"),
          Text("new login: ${auth.isNewUser}"),
          Text("user name: ${auth.username}"),
          Text("email: ${auth.email}"),
          Text("email verified: ${auth.isEmailVerified}"),
          Text("anonymous login: ${auth.isAnonymous}"),
          Text("id token: ${auth.idToken}"),
          Text("access token: ${auth.accessToken}"),
          Text("information provider: ${auth.providerId}"),
          Text("expire time: ${auth.expirationTime}"),
          Text("auth time: ${auth.authTime}"),
          Text("issued at: ${auth.issuedAtTime}"),
          Text("signin provider: ${auth.signInProvider}"),
        ], // <Widget>[]
      );
  //
  Column _buildBody(BuildContext context) {
    if (loggedIn) {
      context.read<LoginBloc>().add(
        SetUser(user: auth),
      );

    } else {
      // This function is called by every RaisedButton widget.
      void signInFunc({bool signIn}) {
        if (signIn) {
          errorMessage = '';
        } else {
          errorMessage = auth.message;
        }
        setState(() {});
      }

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