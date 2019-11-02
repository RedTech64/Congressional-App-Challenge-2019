import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'home.dart';
import 'user_data_container.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'welcome_page.dart';


void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StateContainer(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Color.fromRGBO(105,240,174,1.0),
          canvasColor: Color.fromRGBO(255,255,255,1.0),
          buttonColor: Color.fromRGBO(105,240,174,1.0),

          floatingActionButtonTheme: new FloatingActionButtonThemeData(
            backgroundColor: Color.fromRGBO(105,240,174,1.0),
          )

        ),
        home: MyHomePage(title: 'Home'),
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
  StreamSubscription<FirebaseUser> _listener;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();


  @override
  void initState() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print(message);
      },
    );

    _checkCurrentUser().then((user) {
      getUserData(user.uid).then((doc) {
        var container = StateContainer.of(context);
        container.updateUserInfo(uid: user.uid);
        if(!doc.exists) {
          setUpNewUser(user.uid).then((value) {
            Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) {
              return new WelcomePage();
            }));
            setState(() {
              _ready = true;
            });
          });
        } else {
          setState(() {
            _ready = true;
          });
        }
      });
    });
    super.initState();
  }

  Future<void> onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: <Widget>[],
      ),
    );
  }

  Future<void> onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  }

  Future setUpNewUser(uid) {
    return _firebaseMessaging.getToken().then((String token) {
      Firestore.instance.collection('users').document(uid).setData({
        'id': uid,
        'fcmToken': token,
        'totalSaved': 0,
      });
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
    FirebaseUser _user;
    _listener = _auth.onAuthStateChanged.listen((FirebaseUser user) async {
      if(user == null) {
        await signInAnonymously();
      }
      setState(() {
        _user = user;
      });
      print("SIGNED IN");
    });
    _user = await _auth.currentUser();
    _user?.getIdToken(refresh: true);
    if(_user == null || _user.uid == null)
      await signInAnonymously();
    return _user;
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
