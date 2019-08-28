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
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('users').document(container.user.uid).collection('saves').snapshots(),
      builder: (context, snapshot) {
        return DefaultTabController(
          length: snapshot.data.documents.length,
          child: new Scaffold(
            appBar: new AppBar(
              bottom: TabBar(
                tabs: _getTabIcons(snapshot.data.documents),
              ),
              title: new Text('Home'),
            ),
            body: TabBarView(
              children: _getSavePages(snapshot.data.documents),
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
          ),
        );
      }
    );
  }

  List<Widget> _getTabIcons(List<DocumentSnapshot> saves) {
    List<Widget> list = [];
    saves.forEach((save) {
      list.add(
        new Tab(icon: new Icon(Icons.add)),
      );
    });
    return list;
  }

  List<Widget> _getSavePages(List<DocumentSnapshot> saves) {
    List<Widget> list = [];
    saves.forEach((save) {
      list.add(
        new Center(
          child: new Column(
            children: <Widget>[
              new Text(save.data['name']),
            ],
          ),
        ),
      );
    });
    return list;
  }
}