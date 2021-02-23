import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:punkmessenger/presentation/components/rounded_button.dart';
import 'package:punkmessenger/presentation/screens/chat_screen.dart';
import 'registration_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
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
  Widget _buildBody(BuildContext context) {
    if (loggedIn) {
      return _authResults;
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
          SizedBox(
            height: 48.0,
          ),
          const Text('You are not currently signed in.'),
          signInErrorMsg,
          RoundedButton(
            onPressed: () {
              auth
                  .signInWithGoogle()
                  .then((signIn) => signInFunc(signIn: signIn))
                  .catchError((Object err) {
                if (err is! Exception) {
                  err = err.toString();
                }
                errorMessage = auth.message;
              });
            },
            title: 'Sign In With Google',
            color: Colors.blueAccent,
          ),
          RaisedButton(
            onPressed: () async {
              final ep = await dialogBox(context: context);
              if (ep == null || ep.isEmpty) {
                return;
              }
              await auth
                  .signInWithEmailAndPassword(email: ep[0], password: ep[1])
                  .then((signIn) => signInFunc(signIn: signIn))
                  .catchError((Object err) {
                if (err is! Exception) {
                  err = err.toString();
                }
                errorMessage = auth.message;
              });
            },
            child: const Text('Sign in with Email & Password'),
          ),

          RoundedButton(
            title: 'Register',
            color: Colors.blueAccent,
            onPressed: () {
              Navigator.pushNamed(context, RegistrationScreen.id);
            },
          ),
          RoundedButton(
            title: 'Chat Screen',
            color: Colors.green,
            onPressed: () {
              Navigator.pushNamed(context, ChatScreen.id);
            },
          ),
          // SignInButton(Buttons.GoogleDark, text: "Sign up with Google",
          // onPressed: () {
          // _signInWithGoogle();
          // })
        ],
      );
    }
  }
}

// Creates an alertDialog for the user to enter their email
Future<List<String>> dialogBox({
  Key key,
  @required BuildContext context,
  bool barrierDismissible = false,
}) {
  return showDialog<List<String>>(
    context: context,
    barrierDismissible: barrierDismissible, // user must tap button!
    builder: (BuildContext context) {
      return CustomAlertDialog(
        key: key,
        title: 'Email & Password',
      );
    },
  );
}

class CustomAlertDialog extends StatefulWidget {
  const CustomAlertDialog({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _CustomAlertDialogState createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  final _resetKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _resetValidate = false;
  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      elevation: 20,
      content: SingleChildScrollView(
        child: Form(
          key: _resetKey,
          autovalidateMode: _resetValidate
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          child: ListBody(
            children: <Widget>[
              const Text(
                'Email Address & Password.',
                style: TextStyle(fontSize: 14),
              ),
              const Padding(
                padding: EdgeInsets.all(10),
              ),
              Column(
                children: <Widget>[
                  Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Icon(
                        Icons.email,
                        size: 20,
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      child: TextFormField(
                        validator: validateEmail,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        autofocus: true,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Email',
                            contentPadding: EdgeInsets.only(left: 70, top: 15),
                            hintStyle:
                                TextStyle(color: Colors.black, fontSize: 14)),
                        style: const TextStyle(color: Colors.black),
                      ),
                    )
                  ]),
                  SizedBox(
                    width: 200,
                    child: TextFormField(
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Password required.';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      controller: _passwordController,
                      obscureText:
                          _hidePassword, //This will obscure text dynamically
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        // Here is key idea
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _hidePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          onPressed: () {
                            // Update the state i.e. google the state of passwordVisible variable
                            setState(() {
                              _hidePassword = !_hidePassword;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'CANCEL',
            style: TextStyle(color: Colors.black),
          ),
        ),
        FlatButton(
          onPressed: () {
            _onPressed();
          },
          child: const Text(
            'SEND EMAIL',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  void _onPressed() {
    var valid = true;

    if (!_resetKey.currentState.validate()) {
      valid = false;
    }

    if (valid) {
      Navigator.of(context)
          .pop([_emailController.text, _passwordController.text]);
    } else {
      _resetValidate = true;
      setState(() {});
    }
  }
}

String validateEmail(String value) {
  const pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  final regExp = RegExp(pattern);
  if (value.isEmpty) {
    return 'Email is required';
  } else if (!regExp.hasMatch(value)) {
    return 'Invalid Email';
  } else {
    return null;
  }
}
