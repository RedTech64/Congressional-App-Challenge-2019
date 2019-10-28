import 'package:saguaro/user_data_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'create flow/item.dart';
import 'create flow/selection_page.dart';
import 'common_widgets.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'save_page.dart';
import 'save_object.dart';

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
        return new StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('users').document(container.user.uid).collection('saves').snapshots(),
          builder: (context, saveDocs) {
            if(saveDocs.connectionState == ConnectionState.waiting) {
              return new Scaffold();
            } else {
              return new Scaffold(
                body: new NestedScrollView(
                  headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget> [
                      SliverAppBar(
                        elevation: 5,
                        pinned: true,
                        expandedHeight: 100,
                        flexibleSpace: FlexibleSpaceBar(
                          centerTitle: true,
                          background: new Image(
                            image: AssetImage(("assets/saguaro-logo2.png")),
                            fit: BoxFit.contain,
                            height: 200,
                            width: 200,
                          ),
                          title: new Text(
                              'Saguaro',
                              style: new TextStyle(
                                color: Colors.black,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Comfortaa',
                              )
                          ),
                        ),
                      ),
                    ];
                  },
                  body: new ListView.builder(
                    shrinkWrap: true,
                    itemCount: saveDocs.data.documents.length+1,
                    itemBuilder: (context,index) {
                      if(index == 0) {
                        return new Card(
                          elevation: 5,
                          child: new Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: new SimpleText("Hello, Cole!", size: 24.0, bold: true,),
                              ),
                              new Divider(height: 0,),
                              new SimpleText("Due Today: \$${_getDueToday(saveDocs).toStringAsFixed(2)}", size: 16, bold: false,),
                              Center(child: new SimpleText("Total Saved: \$${userSnapshot.data['totalSaved'].toStringAsFixed(2)}", size: 16, bold: false,)),
                            ],
                          ),
                        );
                      }
                      SaveObject saveObject = new SaveObject.fromDoc(saveDocs.data.documents[index-1]);
                      return new Card(
                        elevation: 5,
                        child: new InkWell(
                          onTap: () {
                            Navigator.push(context, new MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return new SavePage(saveDocs.data.documents[index-1].reference);
                                }
                            ));
                          },
                          child: new Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: saveObject.icon,
                              ),
                              Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                    child: new Text(
                                      saveObject.name,
                                      style: new TextStyle(
                                        fontSize: 24,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                                    child: new Text(
                                      "Next Payment: "+getNextPaymentDateFormatted(saveObject),
                                      style: new TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(flex: 1,),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: new Text(
                                  ((saveObject.savedAmount/saveObject.cost)*100).toStringAsFixed(0)+"% saved",
                                  style: new TextStyle(
                                    fontSize: 24
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: _getTimeIndicator(saveObject),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
          },
        );
      },
    );
  }

  double _getDueToday(saveDocs) {
    double total = 0;
    saveDocs.data.documents.forEach((doc) {
      SaveObject saveObject = new SaveObject.fromDoc(doc);
      total += getSuggestedSave(saveObject, DateTime.now());
    });
    return total;
  }

  Widget _getTimeIndicator(SaveObject saveObject) {
    if(onTime(saveObject)) {
      return new Container(
        color: Color.fromRGBO(105,240,174,1.0),
        child: new Icon(Icons.check),
      );
    } else {
      return new Container(
        color: Color.fromRGBO(255,0,0,1.0),
        child: new Icon(Icons.clear),
      );
    }
  }
}