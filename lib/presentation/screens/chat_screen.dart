import 'package:flutter/material.dart';
import 'package:punkmessenger/data/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:auth/auth.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    children: [
                      Text("id token: ${auth.idToken}"),
                    ],
                  ),
                ),
              ],
            ),
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
              icon: Icon(Icons.close),
              onPressed: () {
                // _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
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
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageTextController.clear();
                      // _firestore.collection('messages').add({
                      //   'text': messageText,
                      //   'sender': loggedInUser.email,
                      // });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      // stream: _firestore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 250.0),
                child: CircularProgressIndicator(
                  backgroundColor: Colors.lightBlueAccent,
                ),
              ),
            ],
          );
        }
        final messages = snapshot.data.docs.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          // final messageText = message.data['text'];
          // final messageSender = message.data['sender'];

          // final currentUser = loggedInUser.email;

          final messageBubble = MessageBubble(
              // sender: messageSender,
              // text: messageText,
              // isMe: currentUser == messageSender,
              );

          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text, this.isMe});

  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))
                : BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
            elevation: 5.0,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black54,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
