import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'home.dart';
import 'user_data_container.dart';

import 'welcome_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StateContainer(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Color.fromRGBO(105,240,174,1.0),
          canvasColor: Color.fromRGBO(255,255,255,1.0),
          buttonColor: Color.fromRGBO(105,240,174,1.0),

        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _ready = false;
  FirebaseUser _user;
  StreamSubscription<FirebaseUser> _listener;

  @override
  void initState() {
    _checkCurrentUser().then((value) {
      getUserData(_user.uid).then((doc) {
        var container = StateContainer.of(context);
        container.updateUserInfo(uid: _user.uid);
        if(!doc.exists) {
          setUpNewUser(_user.uid).then((value) {
            Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) {
              return new WelcomePage();
            }));
            setState(() {
              _ready = true;
            });
          });
        } else {

          //TODO: REMOVE
          Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) {
            return new WelcomePage();
          }));
          setState(() {
            _ready = true;
          });
        }
      });
    });
    super.initState();
  }

  Future setUpNewUser(uid) {
    return Firestore.instance.collection('users').document(uid).setData({
      'id': uid,
    });
  }

  Future<DocumentSnapshot> getUserData(uid) {
    return Firestore.instance.collection('users').document(uid).get();
  }

  Future<FirebaseUser> signInAnonymously() async {
    FirebaseUser user;
    try {
      AuthResult result = await _auth.signInAnonymously();
      user = result.user;
    } catch(error) {
      return null;
    }
    return user;
  }

  Future _checkCurrentUser() async {
    _user = await _auth.currentUser();
    _user?.getIdToken(refresh: true);
    _listener = _auth.onAuthStateChanged.listen((FirebaseUser user) async {
      if(user == null) {
        await signInAnonymously();
      }
      setState(() {
        _user = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if(!_ready) {
      return new Scaffold(
        backgroundColor: Color.fromRGBO(105,240,174,1.0),
        body: Center(
          child: CircularProgressIndicator(
            backgroundColor: Color.fromRGBO(105,240,174,1.0),
          ),
        ),
      );
    }
    return new HomePage();
  }
}

enum Frequency {
  daily,
  weekly,
  biweekly,
  monthly,
  bimonthly,
}
