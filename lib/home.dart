import 'package:cac_2019/user_data_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'create flow/item.dart';
import 'create flow/selection_page.dart';
import 'common_widgets.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var container = StateContainer.of(context);
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection('users').document(container.user.uid).snapshots(),
      builder: (context, userSnapshot) {
        return StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('users').document(container.user.uid).collection('saves').snapshots(),
          builder: (context, snapshot) {
            if(snapshot == null || snapshot.data == null || snapshot.data.documents == null)
              return new Scaffold(
                body: new Container(),
              );
            int docIndex = -1;
            for(int i = 0; i < snapshot.data.documents.length; i++) {
              if(snapshot.data.documents[i].documentID == userSnapshot.data['selectedSave']) {
                docIndex = i;
              }
            }
            return new Scaffold(
              drawer: new Drawer(
                child: new ListView(
                  children: <Widget>[
                    DrawerHeader(
                      child: new Text('Save Items'),
                    ),
                    ..._getDrawerItems(snapshot.data.documents,container.user.uid),
                  ],
                ),
              ),
              appBar: new AppBar(
                actions: <Widget>[
                  Builder(builder: (context) {
                    return new IconButton(
                      color: Colors.white,
                      icon: new Icon(Icons.delete),
                      onPressed: () async {
                        bool result = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Are you sure you want to delete this save?'),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () { Navigator.pop(context, false); },
                                  child: const Text('CANCEL'),
                                ),
                                FlatButton(
                                  onPressed: () { Navigator.pop(context, true); },
                                  child: const Text('DELETE'),
                                ),
                              ],
                            );
                          },
                        );
                        if(result)
                          snapshot.data.documents[DefaultTabController.of(context).index].reference.delete();
                      },
                    );
                  }),
                ],
                title: new Text(
                    'Home',
                  style: new TextStyle(
                    color: Colors.white,
                  )
                ),
              ),
              body: new SingleChildScrollView(
                child: new Center(
                  child: new Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      new Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Card(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: new Text(
                                    snapshot.data.documents[docIndex]['name'],
                                    style: new TextStyle(
                                      color: Color.fromRGBO(105,240,174,1.0),
                                      fontSize: 32.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),

                                ),
                                /*Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: new Divider(
                                  color: Color.fromRGBO(105,240,174,1.0),
                                ),

                              ),*/
                                new Divider(
                                  color: Color.fromRGBO(105,240,174,1.0),
                                ),
                                Center(
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10.0),
                                        child: Container(
                                          width: 100,
                                          height: 75,
                                          color: Color.fromRGBO(105,240,174,1.0),
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: FittedBox(
                                              child: new Text(
                                                snapshot.data.documents[docIndex]['savedAmount'].toString(),
                                                style: new TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 32.0,
                                                  fontWeight: FontWeight.bold,
                                                ),


                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      Container(
                                        color: Color.fromRGBO(255, 255, 255, 1.0),

                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: new Text(
                                            "/",
                                            style: new TextStyle(
                                              color: Color.fromRGBO(105,240,174,1.0),
                                              fontSize: 48.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),

                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10.0),
                                        child: Container(
                                          width:100,
                                          height: 75,
                                          color: Color.fromRGBO(105,240,174,1.0),
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: FittedBox(
                                              child: new Text(
                                                snapshot.data.documents[docIndex]['cost'].toString(),
                                                style: new TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 32.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),


                                    ],

                                  ),
                                ),
                                new Divider(
                                  color: Color.fromRGBO(105,240,174,1.0),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: new Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[

                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10.0),
                                          child: Container(
                                            width: 100,
                                            height: 75,

                                            color: Color.fromRGBO(105,240,174,1.0),
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                              child: new Text(
                                                snapshot.data.documents[docIndex]['dividedAmount'].toString(),
                                                style: new TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 32.0,
                                                  fontWeight: FontWeight.bold,
                                                ),


                                              ),
                                            ),
                                          ),
                                        ),

                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10.0),
                                          child: Container(
                                            width: 100,
                                            height: 75,
                                            color: Color.fromRGBO(105,240,174,1.0),
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                              child: FittedBox(
                                                child: new Text(
                                                  snapshot.data.documents[docIndex]['frequency'].toString(),
                                                  style: new TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 32.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                new Divider(
                                  color: Color.fromRGBO(105,240,174,1.0),
                                ),
                                new RaisedButton(
                                  child: new Text("ADD AMOUNT SAVED"),
                                  onPressed: () {
                                    _openSaveDialog(context);
                                  },
                                ),
                                new Placeholder(
                                  fallbackWidth: 100,
                                  fallbackHeight: 200,
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              floatingActionButton: new FloatingActionButton(
                child: new Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).push(
                    new MaterialPageRoute(
                      builder: (BuildContext context) {
                        return new ItemPage();
                      }
                    ),
                  );
                },
              ),
            );
          }
        );
    },
    );
  }


  List<Widget> _getDrawerItems(List<DocumentSnapshot> saves,userID) {
    var container = StateContainer.of(context);
    List<Widget> list = [];
    for(int i = 0; i < saves.length; i++) {
      if(saves[i].data['icon'] == null)
        saves[i].data['icon'] = 0xe145;
      if(saves[i].data['name'] == "")
        saves[i].data['name'] = "Untitled";
      list.add(
        new ListTile(
          title: new Text(saves[i].data['name']),
          onTap: () {
            Firestore.instance.collection('users').document(userID).updateData({
                'selectedSave': saves[i].documentID,
            });
            Navigator.pop(context);
          },
        ),
      );
    }
    return list;
  }
}