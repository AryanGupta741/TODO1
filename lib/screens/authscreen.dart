import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/screens/authform_screen.dart';

class authscreen extends StatelessWidget {
  const authscreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Todo',
        ),
        centerTitle: true,
      ),
       body: authForm(),
    );
  }
}
