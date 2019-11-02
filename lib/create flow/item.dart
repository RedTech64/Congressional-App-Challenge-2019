import 'package:flutter/material.dart';
import 'package:saguaro/common_widgets.dart';
import 'package:saguaro/main.dart';
import 'selection_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saguaro/user_data_container.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:saguaro/save_object.dart';

class ItemPage extends StatefulWidget {
  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  var itemNameController;
  var itemCostController;
  var saveAmountController;
  String itemName = "";
  double itemCost = 0.0;
  double dividedAmount = 1.0;
  int radioValue = 2;
  DateTime _dueDate = new DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
  DateTime _startDate = new DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
  int frequency = 7;
  Icon icon = new Icon(Icons.add);

  @override
  void initState() {
    itemNameController = new TextEditingController(text: itemName);
    itemCostController = new MoneyMaskedTextController(leftSymbol: "\$", initialValue: itemCost, decimalSeparator: ".", thousandSeparator: ",");
    saveAmountController = new MoneyMaskedTextController(leftSymbol: "\$", initialValue: dividedAmount, decimalSeparator: ".", thousandSeparator: ",");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(radioValue == 1) {
      saveAmountController.updateValue(_getSaveAmount());
      dividedAmount = double.parse(_getSaveAmount().toStringAsFixed(2));
    }
    if(radioValue == 2)
      _dueDate = _getCompleteDate();
    var container = StateContainer.of(context);
    print(container.user.uid);
    return Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(
        color: Colors.white,
        ),//change your color here
        backgroundColor: Color.fromRGBO(105,240,174,1.0),
        title: new Text(
            'Save for an Item',
            style: new TextStyle(
              color: Color.fromRGBO(255,255,255, 1.0),
            ),
        ),
      ),
      body: new SingleChildScrollView(
        child: new Center(
          child: new Column(
            children: <Widget>[
              new Card(
                elevation: 5,
                child: new Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new SimpleText(
                        'Item Information',
                        size: 20.0,
                        bold: true,
                      ),
                    ),
                    new Divider(height: 0,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new ThemeTextField(
                        controller: itemNameController,
                        label: 'Item Name',
                        width: 300.0,
                        onChanged: (value) {
                          setState(() {
                            itemName = value;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new ThemeTextField(
                        controller: itemCostController,
                        keyboardType: TextInputType.number,
                        label: 'Item Cost',
                        width: 200.0,
                        onChanged: (value) {
                          print(value);
                          setState(() {
                            itemCost = double.parse(value.substring(1))*10;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: <Widget>[
                          new SimpleText("Frequency: ", bold: true, size: 20,),
                          new Container(width: 8,),
                          new DropdownButton(
                            value: frequency,
                            items: <DropdownMenuItem>[
                              new DropdownMenuItem(
                                child: new Text("Daily"),
                                value: 1,
                              ),
                              new DropdownMenuItem(
                                child: new Text("Weekly"),
                                value: 7,
                              ),
                              new DropdownMenuItem(
                                child: new Text("Bi-weekly"),
                                value: 14,
                              ),
                              new DropdownMenuItem(
                                child: new Text("Monthly"),
                                value: 30,
                              ),
                              new DropdownMenuItem(
                                child: new Text("Bi-monthly"),
                                value: 60,
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                frequency = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: new Row(
                        children: <Widget>[
                          new SimpleText("Start Date: ", bold: true, size: 20,),
                          new SimpleText("${_startDate.month}/${_startDate.day}/${_startDate.year}", bold: false, size: 20,),
                          new IconButton(
                            icon: new Icon(Icons.edit),
                            onPressed: () async {
                              DateTime result = await showDatePicker(
                                initialDate: _startDate,
                                firstDate: DateTime.utc(_startDate.year, _startDate.month, _startDate.day),
                                lastDate: DateTime(2200),
                                context: context,
                              );
                              if(result != null) {
                                setState(() {
                                  _startDate = new DateTime(result.year,result.month,result.day);
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: new Row(
                        children: <Widget>[
                          new SimpleText("Icon: ", bold: true, size: 20,),
                          icon,
                          new IconButton(
                            icon: new Icon(Icons.edit),
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  List icons = [Icons.add,Icons.card_giftcard,Icons.category,Icons.description,Icons.phone,Icons.laptop,Icons.ac_unit,Icons.print,Icons.adjust,Icons.star,Icons.edit,Icons.map,Icons.airport_shuttle,Icons.assistant_photo,Icons.audiotrack,Icons.child_friendly,Icons.local_play,Icons.fitness_center,Icons.camera_alt,Icons.import_contacts,Icons.weekend];
                                  Icon newIcon = icon;
                                  return new AlertDialog(
                                    title: new Text("Select Icon"),
                                    content: Container(
                                      height: 400,
                                      width: 100,
                                      child: new GridView.builder(
                                        itemCount: icons.length,
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
                                        itemBuilder: (BuildContext context, int index) {
                                          return new Container(
                                            height: 10,
                                            width: 10,
                                            child: new IconButton(icon: new Icon(icons[index]), onPressed: () {setState(() {icon = new Icon(icons[index]);});Navigator.pop(context);},),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                }
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              new Card(
                elevation: 5,
                child: new Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new SimpleText(
                        'Saving Information',
                        size: 20.0,
                        bold: true,
                      ),
                    ),
                    new Divider(height: 0,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: new Row(
                        children: <Widget>[
                          new Radio(
                            value: 1,
                            activeColor: Color.fromRGBO(105,240,174,1.0),
                            onChanged: _saveTypeChanged,
                            groupValue: radioValue,
                          ),
                          new SimpleText('Save by Date', bold: false, size: 20,),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                      child: new Row(
                        children: <Widget>[
                          new SimpleText("Save by: ", bold: true, size: 20,),
                          new SimpleText("${_dueDate.month}/${_dueDate.day}/${_dueDate.year}", bold: false, size: 20,),
                          if(radioValue == 2)
                            new IconButton(icon: new Icon(Icons.edit), disabledColor: Colors.white,),
                          if(radioValue == 1)
                            new IconButton(
                              icon: new Icon(Icons.edit),
                              onPressed: () async {
                                DateTime result = await showDatePicker(
                                  initialDate: _dueDate,
                                  firstDate: DateTime.utc(_startDate.year, _startDate.month, _startDate.day),
                                  lastDate: DateTime(2200),
                                  context: context,
                                );
                              if(result != null) {
                                setState(() {
                                  _dueDate = new DateTime(result.year,result.month,result.day);
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    new Divider(height: 0,),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: new Row(
                        children: <Widget>[
                          new Radio(
                            value: 2,
                            activeColor: Color.fromRGBO(105,240,174,1.0),
                            onChanged: _saveTypeChanged,
                            groupValue: radioValue,
                          ),
                          new SimpleText('Save by Amount', bold: false, size: 20,),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                      child: new Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new ThemeTextField(
                              keyboardType: TextInputType.number,
                              label: "Amount",
                              controller: saveAmountController,
                              width: 200,
                              onChanged: (value) {
                                setState(() {
                                  dividedAmount = double.parse(value.substring(1))*10;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              new RaisedButton(
                color: Color.fromRGBO(105,240,174,1.0),
                child: Text(
                  "DONE",
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                textColor: Color.fromRGBO(255,255,255,1.0),
                onPressed: () {
                  var saveObject = new SaveObject(
                    name: itemName,
                    cost: itemCost,
                    frequency: frequency,
                    dividedAmount: dividedAmount,
                    savedAmount: 0.0,
                    startDate: _startDate,
                    completeDate: _dueDate,
                    icon: icon,
                  );
                  addSaveObject(saveObject, container.user.uid);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  addSaveObject(SaveObject saveObject,uid) {
    DateTime nextPayment = getNextPaymentDate(saveObject);
    Firestore.instance.collection('users').document(uid).collection('saves').add({
      'name': saveObject.name,
      'cost': saveObject.cost,
      'frequency': saveObject.frequency,
      'dividedAmount': saveObject.dividedAmount,
      'savedAmount': saveObject.savedAmount,
      'startDate': Timestamp.fromDate(saveObject.startDate),
      'completeDate': Timestamp.fromDate(saveObject.completeDate),
      'icon': saveObject.icon.icon.codePoint,
      'nextReminder': Timestamp.fromDate(nextPayment),
      'saveData': [],
    });
  }

  void _saveTypeChanged(int value) {
    setState(() {
      radioValue = value;
    });
  }

  double _getSaveAmount() {
    Duration savingTime = _dueDate.difference(_startDate);
    Duration gap = new Duration(days: frequency);
    int times = (savingTime.inDays/gap.inDays).ceil()+1;
    return itemCost/times;
  }

  DateTime _getCompleteDate() {
    int saveTimes = 1;
    if(dividedAmount > 0)
      saveTimes = itemCost~/dividedAmount;
    Duration gap = new Duration(days: frequency);
    DateTime withTime = DateTime.now().add(new Duration(days: gap.inDays*(saveTimes-1)));
    return new DateTime(withTime.year,withTime.month,withTime.day);
  }
}