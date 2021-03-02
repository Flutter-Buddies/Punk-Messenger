import 'package:flutter/material.dart';
import 'package:auth/auth.dart';
import 'package:punkmessenger/presentation/screens/chat_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final messageTextController = TextEditingController();
  // final _auth = FirebaseAuth.instance;

  String messageText;
  bool loggedIn = false;
  Auth auth;

  Widget get _authResults => Container(
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Text("uid: ${auth.uid}"),
              ],
            ),
            Row(
              children: [
                Text("name: ${auth.displayName}"),
              ],
            ),
            Row(
              children: [
                Text("photo: ${auth.photoUrl}"),
              ],
            ),
            Row(
              children: [
                Text("new login: ${auth.isNewUser}"),
              ],
            ),
            Row(
              children: [
                Text("user name: ${auth.username}"),
              ],
            ),
            Row(
              children: [
                Text("email: ${auth.email}"),
              ],
            ),
            Row(
              children: [
                Text("email verified: ${auth.isEmailVerified}"),
              ],
            ),
            Row(
              children: [
                Text("anonymous login: ${auth.isAnonymous}"),
              ],
            ),
            /* Row(
              children: [
                Expanded(
                  child: Wrap(
                    children: [
                      Text("id token: ${auth.idToken}"),
                    ],
                  ),
                ),
              ],
            ), */
            Row(
              children: [
                Text("access token: ${auth.accessToken}"),
              ],
            ),
            Row(
              children: [
                Text("information provider: ${auth.providerId}"),
              ],
            ),
            Row(
              children: [
                Text("expire time: ${auth.expirationTime}"),
              ],
            ),
            Row(
              children: [
                Text("auth time: ${auth.authTime}"),
              ],
            ),
            Row(
              children: [
                Text("issued at: ${auth.issuedAtTime}"),
              ],
            ),
            Row(
              children: [
                Text("signin provider: ${auth.signInProvider}"),
              ],
            ),
          ], // <Widget>[]
        ),
      );

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() async {
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
  }

  @override
  void dispose() {
    auth.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: 250,
              child: SingleChildScrollView(
                child: _authResults,
              ),
            ),
            RaisedButton(
              child: Text('Go to ChatScreen'),
              onPressed: () {
                Navigator.pushNamed(context, ChatScreen.id);
              }
            )
          ],
        ),
      ),
    );
  }
}