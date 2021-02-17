import 'package:auth/auth.dart';

@override
void initState() {
  super.initState();

  auth = Auth.init(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
      listener: (user) {
        loggedIn = user != null;
        setState(() {});
      });

  auth.signInSilently(
    listen: (account) {
      loggedIn = account != null;
      setState(() {});
    },
  );
}
