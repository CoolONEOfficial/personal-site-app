import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:personal_site_app/components.dart';
import 'package:personal_site_app/screens/Control.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);

  return 'signInWithGoogle succeeded: $user';
}

class ScreenAuth extends StatefulWidget {
  static const route = '/screens/auth';

  @override
  _ScreenAuthState createState() => _ScreenAuthState();
}

class _ScreenAuthState extends State<ScreenAuth> {
  Widget _signInButton() => OutlineButton(
        splashColor: Colors.grey,
        onPressed: () {
          signInWithGoogle().whenComplete(() {
            Navigator.pushNamedAndRemoveUntil(
                context, ScreenControl.route, (Route<dynamic> route) => false);
          });
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        highlightElevation: 0,
        borderSide: BorderSide(color: Colors.grey),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Sign in with Google',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext ctx) {
    return buildFutureBuilder(googleSignIn.isSignedIn(), (signed) {
      if (signed)
        Future(() {
          Navigator.pushNamedAndRemoveUntil(
              context, ScreenControl.route, (Route<dynamic> route) => false);
        });

      return Scaffold(
        appBar: AppBar(
          title: Text(''),
        ),
        body: Center(
          child: _signInButton(),
        ),
      );
    });
  }
}
