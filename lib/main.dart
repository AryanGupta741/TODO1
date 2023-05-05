import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/pages/home_page.dart';
import 'package:todo_list/screens/authform_screen.dart';
import 'screens/authscreen.dart';
import 'package:firebase_core/firebase_core.dart';

//flutterfire configure

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(todo());
}

class todo extends StatelessWidget {
  const todo({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, userSnapshot) {
            if (userSnapshot.hasData) {
              return const homePage();
            } else {
              return const authForm();
            }
          }),
    );
  }
}
