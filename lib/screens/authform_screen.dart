import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
// multiple package of google font are exist please put right package

class authForm extends StatefulWidget {
  const authForm({super.key});

  @override
  State<authForm> createState() => _authFormState();
}

class _authFormState extends State<authForm> {
  final _formKey = GlobalKey<FormState>(); //object
  //In Flutter, GlobalKey<FormState> is a class that represents a key object used to uniquely identify and manage the state of a Form widget. It is typically used when working with forms to perform various operations, such as form validation, form submission, or accessing and manipulating form fields.This helps ensure that the data entered by the user meets the specified criteria or constraints. //Form Submission: When the user submits a form, you can use the GlobalKey<FormState> to access the current state of the form through formKey.currentState. This allows you to retrieve the values entered by the user in each form field and perform further actions, such as submitting the data to a server or updating the application state.
  var _email = ''; // this is the email
  var _password = ''; //this is the password
  var _username = ''; // this is the username
  var _isLogin = true; //this is the login state

  startauthentication() async {
// The startAuthentication function might be responsible for triggering this auhtentication process.The specific implementation of startAuthentication would depend on the requirements of your application and the authentication mechanism you are using.
    final isValid = _formKey.currentState!.validate();
    // In the example above, submitForm() is a function that is called when you want to submit the form. It calls _formKey.currentState!.validate() to trigger the validation process of the form. If all the form fields pass validation (i.e., there are no validation errors), the expression validate() will return true, indicating that the form is valid. You can then proceed with further actions, such as submitting the form data to a server or performing some other operation.

    FocusScope.of(context).unfocus();
    // this is to close the keyboard
    if (isValid) {
      _formKey.currentState!.save();
      submitform(_email, _password, _username);
    }
  }

  submitform(String email, String password, String username) async {
    final auth = FirebaseAuth.instance;
    UserCredential authResult;

    try {
      if (_isLogin) {
        authResult = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        // String uid = authResult.user!.uid;
        // await FirebaseFirestore.instance.collection('users').doc(uid).set({
        //   'username': username,
        //   'email': email,
        // });
      }
    } catch (error) {
      print(error);
    }
  }

//The ! operator is the null assertion operator in Dart.
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: MediaQuery.of(context).size.width,
        // mediaquery is used to occupy overall screen,
        // means cover full screen
        width: MediaQuery.of(context).size.width,
        child: userInput(),
      ),
    );
  }

  ListView userInput() {
    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                userEmail(),
                SizedBox(
                  height: 10.0,
                ),
                if (!_isLogin)
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: userName(),
                  ),
                SizedBox(height: 10.0),
                userPassword(),
                SizedBox(height: 10.0),
                sumbitButton(),
                SizedBox(
                  height: 10.0,
                ),
                textButton()
              ],
            ),
          ),
        ),
      ],
    );
  }

  TextFormField userName() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a valid username';
        }
        return null;
      },
      onSaved: (value) {
        _username = value!;
      },
      keyboardType: TextInputType.emailAddress,
      key: ValueKey('username'),
      decoration: InputDecoration(
          labelText: 'Username',
          hintText: 'Aryan Gupta',
          labelStyle: GoogleFonts.roboto(),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
    );
  }

  Container textButton() {
    return Container(
        child: TextButton(
            onPressed: () {
              setState(() {
                _isLogin = !_isLogin;
              });
            },
            child: Text(
              _isLogin ? 'Create new Account' : 'I already have an account',
              style: GoogleFonts.roboto(
                color: Colors.blue,
                fontSize: 18.0,
              ),
            )));
  }

  Container sumbitButton() { 
    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.blue,
      ),
      child: ElevatedButton(
        onPressed: () {
          startauthentication();
        },
        child: Text(_isLogin ? 'Login' : 'Sign Up',
            style: GoogleFonts.roboto(color: Colors.white, fontSize: 20.0)),
      ),
    );
  }

  TextFormField userPassword() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty || value.length < 7) {
          return 'Please enter a valid password';
        }
        return null;
      },
      onSaved: (value) {
        _password = value!;
      },
      obscureText: true,
      keyboardType: TextInputType.number,
      key: ValueKey('password'),
      decoration: InputDecoration(
          labelText: 'Passwprd',
          hintText: 'Strong password',
          labelStyle: GoogleFonts.roboto(),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
    );
  }

  TextFormField userEmail() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty || !value.contains('@')) {
          return 'Please enter a valid email address';
        }
        return null;
      },
      onSaved: (value) {
        _email = value!;
      },
      keyboardType: TextInputType.emailAddress,
      key: ValueKey('email'),
      decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'arygalaxy@gmail.com',
          labelStyle: GoogleFonts.roboto(),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
    );
  }
}
