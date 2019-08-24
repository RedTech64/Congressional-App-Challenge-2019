import 'package:cac_2019/user_data_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'create flow/selection_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var container = StateContainer.of(context);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Home'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('users').document(container.user.uid).collection('saves').getDocuments().asStream(),
        builder: (context, snapshot) {
          return new PageView(
            children: _getSavePages(snapshot.data.documents),
          );
        }
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (BuildContext context) {
                return new TypeSelectionPage();
              }
            ),
          );
        },
      ),
    );
  }
  List<Widget> _getSavePages(List<DocumentSnapshot> saves) {
    List<Widget> list = [];
    saves.forEach((save) {
      list.add(new Container());
    });
  }
}