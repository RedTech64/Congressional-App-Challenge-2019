import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_data_container.dart';
import 'create flow/item.dart';
import 'common_widgets.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'save_object.dart';

class SavePage extends StatefulWidget {
  DocumentReference saveDocRef;
  SavePage(this.saveDocRef);
  @override
  _SavePageState createState() => _SavePageState(saveDocRef);
}

class _SavePageState extends State<SavePage> {
  DocumentReference saveDocRef;
  int futureShown = 3;
  _SavePageState(this.saveDocRef);

  @override
  Widget build(BuildContext context) {
    var container = StateContainer.of(context);
    return StreamBuilder<DocumentSnapshot>(
        stream: saveDocRef.snapshots(),
        builder: (context, snapshot) {
          if(snapshot == null || snapshot.data == null || snapshot.data.data == null)
            return new Scaffold(
              body: new Container(),
            );
          print(snapshot.data.data);
          SaveObject saveObject = new SaveObject.fromDoc(snapshot.data);
          return new Scaffold(
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
                        Navigator.pop(context);
                        snapshot.data.reference.delete();
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
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 5,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Text(
                              saveObject.name,
                              style: new TextStyle(
                                fontSize: 32.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          new Divider(height: 0,),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Text(
                              ((saveObject.savedAmount/saveObject.cost)*100).toStringAsFixed(0)+"%",
                              style: new TextStyle(
                                fontSize: 36,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            child: Container(
                              height: 10,
                              child: new ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: new LinearProgressIndicator(
                                  backgroundColor: Colors.grey[300],
                                  valueColor: new AlwaysStoppedAnimation(new Color.fromRGBO(105,240,174,1.0)),
                                  value: saveObject.savedAmount/saveObject.cost,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Text(
                              moneyFormat(saveObject.savedAmount)+" out of "+moneyFormat(saveObject.cost),
                              style: new TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Card(
                      elevation: 5,
                      child: new Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new SimpleText("Info", size: 16, bold: true,),
                          ),
                          new Divider(height: 0,),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                new Text("Start Date: ${saveObject.startDate.month}/${saveObject.startDate.day}/${saveObject.startDate.year}"),
                                new Text("Complete Date: ${saveObject.completeDate.month}/${saveObject.completeDate.day}/${saveObject.completeDate.year}"),
                                new Text("Plan: Save \$${saveObject.dividedAmount}, every ${saveObject.frequency} days."),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Card(
                      elevation: 5,
                      child: new Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new SimpleText("Saves", size: 16, bold: true,),
                          ),
                          new Divider(height: 0,),
                          new DataTable(
                            columns: [
                              new DataColumn(label: new Text('Date')),
                              new DataColumn(label: new Text('Saved')),
                              new DataColumn(label: new Text('Total'))
                            ],
                            rows: _getDataRows(saveObject),
                          ),
                          new IconButton(
                            icon: new Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                futureShown = futureShown+3;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: new FloatingActionButton.extended(
              label: new Text("Save"),
              icon: new Icon(Icons.attach_money),
              onPressed: () {
                _openSaveDialog(context,saveObject);
              },
            ),
          );
        }
    );
  }

  List<DataRow> _getDataRows(SaveObject saveObject) {
    List<DataRow> list = [];
    List<SaveData> saveData = saveObject.saveData;
    saveData.forEach((data) {
      list.add(
        new DataRow(
          cells: [
            new DataCell(new Text("${data.date.month}/${data.date.day}/${data.date.year}")),
            new DataCell(new Text("\$"+data.amount.toStringAsFixed(2))),
            new DataCell(new Text("\$"+data.total.toStringAsFixed(2))),
          ],
        )
      );
    });
    List<DateTime> futureSaveDays = _getFutureSaveDays(saveObject);
    if(futureShown > futureSaveDays.length)
      futureShown = futureSaveDays.length;
    List<DateTime> futureSaveData = futureSaveDays.getRange(0, futureShown).toList();
    int savedSize = list.length;
    for(DateTime date in futureSaveData) {
      
      list.add(
        new DataRow(
          cells: [
            new DataCell(new Text("${date.month}/${date.day}/${date.year}")),
            if(list.length == savedSize)
              new DataCell(new Text("\$"+_getSuggestedSave(saveObject, date).toStringAsFixed(2))),
            if(list.length != savedSize)
              new DataCell(new Text("\$"+saveObject.dividedAmount.toStringAsFixed(2))),
            new DataCell(new Text("\$"+getProjectedSave(saveObject, date).toStringAsFixed(2))),
          ],
        ),
      );
    }
    return list;
  }

  List<DateTime> _getFutureSaveDays(SaveObject saveObject) {
    List<DateTime> saveDays = [];
    DateTime date = getNextPaymentDate(saveObject);
    print(saveObject.completeDate.toString());
    print(date.compareTo(saveObject.completeDate));
    while(date.compareTo(saveObject.completeDate) < 0) {
      saveDays.add(date);
      date = date.add(new Duration(days: saveObject.frequency));
    }
    return saveDays;
  }

  String moneyFormat(num) {
    return "\$"+num.toStringAsFixed(2);
  }

  double _getSuggestedSave(SaveObject save,DateTime date) {
    Duration difference = date.difference(save.startDate);
    int days = difference.inDays;
    if(days == 0 && date.day == save.startDate.day)
      days = 1;
    int saveTimes = (days/save.frequency).floor();
    print(days/save.frequency);
    double projectedAmount = saveTimes*save.dividedAmount;
    double autoFillAmount = projectedAmount - save.savedAmount;
    if(autoFillAmount < 0) autoFillAmount = 0;
    return autoFillAmount;
  }

  void _openSaveDialog(context,SaveObject saveObject) async {
    MoneyMaskedTextController controller = new MoneyMaskedTextController(decimalSeparator: ".", thousandSeparator: ",", leftSymbol: "\$");
    double amount = _getSuggestedSave(saveObject,new DateTime.now());
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
                    amount = double.parse(value.substring(1))*10;
                  },
                ),
              ],
            ),
          );
        }
    );
    if(result != null && result != 0) {
      DateTime nextPayment = getNextPaymentDate(saveObject);
      saveDocRef.updateData({
        'saveData': FieldValue.arrayUnion([{
          'date': Timestamp.fromDate(DateTime.now()),
          'amount': amount,
          'total': saveObject.savedAmount+amount,
          //TODO: Save day bool
        }]),
        'nextPayment': Timestamp.fromDate(nextPayment),
        'savedAmount': saveObject.savedAmount+amount,
      });
    }
  }
}