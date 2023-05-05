import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/pages/add_page.dart';
import 'package:todo_list/screens/authform_screen.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  String uid = ' ';

  void initState() {
    super.initState();
    getuid();
  }

  getuid() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    setState(() {
      uid = user!.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[200],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(),
            ),
            Text('Todo'),
            Text(
              'List',
              style: TextStyle(color: Colors.blue),
            ),
            Expanded(
              child: Container(),
            ),
            GestureDetector(
                //In Flutter, GestureDetector is a widget that provides gesture recognition functionality. It allows you to detect and respond to various user gestures, such as taps, swipes, drags, and more. GestureDetector is a versatile widget that can wrap around other widgets and enable gesture-based interactions with those widgets
                onTap: () {
                  FirebaseAuth.instance.signOut();
                },
                child: Container(child: Icon(Icons.exit_to_app)))
          ],
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('tasks')
              .doc(uid)
              .collection('userTasks')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(
                          snapshot.data!.docs[index]['title'],
                        ),
                        subtitle: Text(
                          snapshot.data!.docs[index]['description'],
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('tasks')
                                  .doc(uid)
                                  .collection('userTasks')
                                  .doc(snapshot.data!.docs[index].id)
                                  .delete();
                            },
                            icon: Icon(Icons.delete)),
                      ),
                    );
                  });
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => addTodo()),
            );
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.green.shade300),
    );
  }
}
