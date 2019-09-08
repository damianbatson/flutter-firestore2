import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prototypedeus/auth.dart';
import 'package:prototypedeus/auth_provider.dart';
import 'package:prototypedeus/detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key, this.title, this.uid}) : super(key: key);
  final String title;
  final String uid;

  @override
  _HomePageState createState() => _HomePageState();
}

Future<void> _signOut(BuildContext context) async {
  try {
    final BaseAuth auth = AuthProvider.of(context).auth;
    await auth.signOut();
  } catch (e) {
    print(e);
  }
}

class _HomePageState extends State<HomePage> {
  TextEditingController taskTitleInputController;
  TextEditingController taskDescripInputController;
  FirebaseUser user;
  FirebaseUser currentUser;
  String uid;

  @override
  void initState() {
    taskTitleInputController = new TextEditingController();
    taskDescripInputController = new TextEditingController();
    this.getCurrentUser();
    // this.setUser();
    super.initState();
  }

  Future<void> getCurrentUser() async {
    // final BaseAuth auth = AuthProvider.of(context).auth;
    // await auth.currentUser();
    currentUser = await FirebaseAuth.instance.currentUser();
    setState(() {
      this.uid = currentUser.uid;
    });
  }

  Future<void> setUser() async {
    this.uid = "";
    currentUser = await FirebaseAuth.instance.currentUser();
    setState(() {
      this.uid = currentUser.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
        actions: <Widget>[
          FlatButton(
            child: Text('Logout',
                style: TextStyle(fontSize: 17.0, color: Colors.white)),
            onPressed: () => _signOut(context),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        // future: FirebaseAuth.instance.currentUser(),
        stream: Firestore.instance            .collection('items')            .document(this.uid)            .collection('items')            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return new ListView.builder(
              itemCount: snapshot.data.documents.length,
              padding: const EdgeInsets.only(top: 10.0, bottom: 0.0),
              // itemExtent: 25.0,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.documents[index];
                // return new Text(" ${ds['itemid']} ${ds['description']}");
                return ListTile(
                  // Access the fields as defined in FireStore
                  title: Text("${ds['itemid']} ${ds['description']}"),
                  // subtitle: Text("${ds['description']}"),
                  trailing: Icon(Icons.home),
                  contentPadding: EdgeInsets.all(5.0),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Detail(ds: ds),
                      ),
                    );
                  },
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showDialog,
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }

  _showDialog() async {
    await showDialog<String>(
      context: context,
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: Column(
          children: <Widget>[
            Text("Please fill all fields to create a new task"),
            Expanded(
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(labelText: 'Task Title*'),
                controller: taskTitleInputController,
              ),
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(labelText: 'Task Description*'),
                controller: taskDescripInputController,
              ),
            )
          ],
        ),
        actions: <Widget>[
          FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                taskTitleInputController.clear();
                taskDescripInputController.clear();
                Navigator.pop(context);
              }),
          FlatButton(
              child: Text('Add'),
              onPressed: () {
                if (taskDescripInputController.text.isNotEmpty &&
                    taskTitleInputController.text.isNotEmpty) {
                  Firestore.instance
                      .collection('items')
                      .document(this.currentUser.uid)
                      .collection('items')
                      .add({
                        "itemid": taskTitleInputController.text,
                        "description": taskDescripInputController.text
                      })
                      .then((result) => {
                            Navigator.pop(context),
                            taskTitleInputController.clear(),
                            taskDescripInputController.clear(),
                          })
                      .catchError((err) => print(err));
                }
              })
        ],
      ),
    );
  }
}
