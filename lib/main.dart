import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'home.dart';
import 'user_data_container.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'welcome_page.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  runApp(MyApp());
}

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


          floatingActionButtonTheme: new FloatingActionButtonThemeData(
            backgroundColor: Color.fromRGBO(105,240,174,1.0),
          )

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

  Future<void> _scheduleNotification() async {
    var scheduledNotificationDateTime =
    DateTime.now().add(Duration(seconds: 2));

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your other channel id',
        'your other channel name',
        'your other channel description',
        icon: 'app_icon',
        largeIconBitmapSource: BitmapSource.Drawable,
        enableLights: true,
        color: const Color.fromARGB(255, 255, 0, 0),
        ledColor: const Color.fromARGB(255, 255, 0, 0),
        ledOnMs: 1000,
        ledOffMs: 500);
    var iOSPlatformChannelSpecifics =
    IOSNotificationDetails(sound: "slow_spring_board.aiff");
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        'scheduled title',
        'scheduled body',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }

  @override
  void initState() {
    var initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification).then((value) {
          _scheduleNotification();
    });

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
