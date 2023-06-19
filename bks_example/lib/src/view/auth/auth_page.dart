import 'package:bks_example/src/view/auth/login_page.dart';
import 'package:bks_example/src/view/home/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      value: FirebaseAuth.instance.authStateChanges(),
      initialData: null,
      child: Scaffold(
        body: Consumer<User?>(
          builder: (context, user, _) {
            // User is logged in
            if (user != null) {
              return HomePage();
            }
            // User is not logged in
            else {
              return LoginPage();
            }
          },
        ),
      ),
    );
  }
}
