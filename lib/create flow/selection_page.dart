import '../main.dart';
import 'item.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TypeSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new LineItem(
                        icon: new Icon(Icons.person),
                        text: 'Retirement',
                        nextPage: null,
                      ),
                      new Divider(),
                      new LineItem(
                        icon: new Icon(Icons.directions_car),
                        text: 'Car',
                        nextPage: null,
                      ),
                      new Divider(),
                      new LineItem(
                        icon: new Icon(Icons.add),
                        text: 'Item',
                        nextPage: new ItemPage(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class LineItem extends StatelessWidget {
  final Widget nextPage;
  final Icon icon;
  final String text;

  LineItem({
    this.nextPage,
    this.icon,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      child: new Row(
        children: <Widget>[
          this.icon,
          new Text(this.text),
        ],
      ),
      onTap: () async {
        SaveObject result = await Navigator.push(context, new MaterialPageRoute(
          builder: (BuildContext context) {
            return nextPage;
          }
        ));
      },
    );
  }

  addSaveObject(SaveObject saveObject) {
    Firestore.instance.collection('users').document(userID).collection('saves').add({
      'name': saveObject.name,
      'cost': saveObject.cost,
      'frequency': saveObject.frequency,
      'amount': saveObject.amount,
      'startDate': Timestamp.fromDate(saveObject.startDate),
      'completeDate': Timestamp.fromDate(saveObject.completeDate),
    });
  }
}

class SaveObject {
  String name;
  num cost;
  int frequency;
  num amount;
  DateTime startDate;
  DateTime completeDate;
}