import 'package:cac_2019/user_data_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'create flow/item.dart';
import 'create flow/selection_page.dart';

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
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('users').document(container.user.uid).collection('saves').snapshots(),
      builder: (context, snapshot) {
        if(snapshot == null || snapshot.data == null || snapshot.data.documents == null)
          return new Scaffold(
            body: new Container(),
          );
        return DefaultTabController(
          length: snapshot.data.documents.length,
          
          child: new Scaffold(
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
                                onPressed: () { Navigator.pop(context, true); },
                                child: const Text('DELETE'),
                              ),
                              FlatButton(
                                onPressed: () { Navigator.pop(context, false); },
                                child: const Text('CANCEL'),
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
              bottom: TabBar(
                onTap: (index) {
                  print(index);
                  setState(() {
                    this.tabIndex = index;
                  });
                },
                tabs: _getTabIcons(snapshot.data.documents),
                labelColor: Colors.white,
              ),
              title: new Text(
                  'Home',
                style: new TextStyle(
                  color: Colors.white,
                )

              ),
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
                      return new ItemPage();
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
      if(save.data['icon'] == null)
        save.data['icon'] = 0xe145;
      list.add(
        new GestureDetector(
          child: new Tab(icon: new Icon(new IconData(save.data['icon'], fontFamily: 'MaterialIcons'))),
          onLongPress: () {
            //TODO: ADD LONG PRESS ACTION ()
          },
        ),
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
                            save.data['name'],
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

                              Container(
                                width: 125,
                                height: 75,
                                color: Color.fromRGBO(105,240,174,1.0),
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: new Text(
                                    save.data['savedAmount'].toString(),
                                    style: new TextStyle(
                                      color: Colors.white,
                                      fontSize: 32.0,
                                      fontWeight: FontWeight.bold,
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

                              Container(
                                width: 125,
                                height: 75,
                                color: Color.fromRGBO(105,240,174,1.0),
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: new Text(
                                    save.data['cost'].toString(),
                                    style: new TextStyle(
                                      color: Colors.white,
                                      fontSize: 32.0,
                                      fontWeight: FontWeight.bold,
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

                                Container(

                                  color: Color.fromRGBO(105,240,174,1.0),
                                  padding: const EdgeInsets.all(8.0),
                                  child: new Text(
                                    save.data['dividedAmount'].toString(),
                                    style: new TextStyle(
                                      color: Colors.white,
                                      fontSize: 32.0,
                                      fontWeight: FontWeight.bold,
                                    ),


                                  ),
                                ),

                                Container(
                                  color: Color.fromRGBO(105,240,174,1.0),
                                  padding: const EdgeInsets.all(8.0),
                                  child: new Text(
                                    save.data['frequency'].toString(),
                                    style: new TextStyle(
                                      color: Colors.white,
                                      fontSize: 32.0,
                                      fontWeight: FontWeight.bold,
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
      );
    });
    return list;
  }
}