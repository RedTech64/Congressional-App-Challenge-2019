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
            SaveObject saveObject = new SaveObject.fromDoc(snapshot.data.documents[docIndex]);
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
                        if(result) {
                          snapshot.data.documents[docIndex].reference.delete();
                          var newIndex = 0;
                          if(docIndex == 0)
                            newIndex = docIndex+1;
                          userSnapshot.data.reference.updateData({
                            'selectedSave': snapshot.data.documents[newIndex].documentID,
                          });
                        }
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
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      new Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Card(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: new Text(
                                  saveObject.name,
                                  style: new TextStyle(
                                    color: Color.fromRGBO(105,240,174,1.0),
                                    fontSize: 32.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
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
                                              saveObject.savedAmount.toString(),
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
                                              saveObject.cost.toString(),
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
                                              saveObject.dividedAmount.toString(),
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
                                                saveObject.frequency.toString(),
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
                                  _getSuggestedSave(saveObject);
                                  _openSaveDialog(context,saveObject,snapshot.data.documents[docIndex].documentID);
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

  double _getSuggestedSave(SaveObject save) {
    Duration difference = DateTime.now().difference(save.startDate);
    int days = difference.inDays;
    int saveTimes = (days/save.frequency).floor();
    double projectedAmount = saveTimes*save.dividedAmount;
    double autoFillAmount = projectedAmount - save.savedAmount;
    if(autoFillAmount < 0) autoFillAmount = 0;
    return autoFillAmount;
  }

  void _openSaveDialog(context,SaveObject save,docID) async {
    MoneyMaskedTextController controller = new MoneyMaskedTextController(decimalSeparator: ".", thousandSeparator: ",", leftSymbol: "\$");
    double amount = _getSuggestedSave(save);
    controller.updateValue(amount);
    double result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text("Save Amount"),
          actions: <Widget>[
            FlatButton(
              child: new Text("CANCEL"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: new Text("SAVE"),
              onPressed: () {
                Navigator.of(context).pop(amount);
              },
            ),
          ],
          content: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new ThemeTextField(
                controller: controller,
                width: 200,
                label: "Amount",
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  print(value);
                  amount = double.parse(value.substring(1))*10;
                },
              ),
            ],
          ),
        );
      }
    );
    print(amount);
    var container = StateContainer.of(context);
    Firestore.instance.collection('users').document(container.user.uid).collection('saves').document(docID).updateData({
      'savedAmount': save.savedAmount+amount,
    });
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