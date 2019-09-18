import 'package:flutter/material.dart';
import 'package:cac_2019/common_widgets.dart';
import 'package:cac_2019/main.dart';
import 'selection_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cac_2019/user_data_container.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class ItemPage extends StatefulWidget {
  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  var itemNameController;
  var itemCostController;
  var saveAmountController;
  String itemName = "";
  double itemCost = 100.0;
  double dividedAmount = 1.0;
  int radioValue = 2;
  DateTime _dueDate = new DateTime.now();
  DateTime _startDate = new DateTime.now();
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
    if(radioValue == 1)
      saveAmountController.updateValue(_getSaveAmount());
    if(radioValue == 2)
      _dueDate = _getCompleteDate();
    var container = StateContainer.of(context);
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Column(
                    children: <Widget>[
                      new SimpleText(
                        'Item Information',
                        size: 18.0,
                        bold: true,
                      ),
                      new ThemeTextField(
                        controller: itemNameController,
                        label: 'Item Name',
                        width: 300.0,
                        onChanged: (value) {
                          setState(() {
                            itemName = value;
                          });
                        },
                      ),
                      Container(height: 10,),
                      new ThemeTextField(
                        controller: itemCostController,
                        keyboardType: TextInputType.number,
                        label: 'Item Cost',
                        width: 200.0,
                        onChanged: (value) {
                          setState(() {
                            itemCost = double.parse(value.substring(1));
                          });
                        },
                      ),
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
                      new Row(
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
                                  _startDate = result;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      new Row(
                        children: <Widget>[
                          new SimpleText("Icon: ", bold: true, size: 20,),
                          icon,
                          new IconButton(
                            icon: new Icon(Icons.edit),
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  List icons = [Icons.add,Icons.card_giftcard,Icons.category,Icons.description,Icons.phone];
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
                    ],
                  ),
                ),
              ),
              new Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Column(
                    children: <Widget>[
                      new SimpleText(
                        'Saving Information',
                        size: 18.0,
                        bold: true,
                      ),
                      new Row(
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
                      new Row(
                        children: <Widget>[
                          new SimpleText("Save by: ", bold: true, size: 20,),
                          new SimpleText("${_dueDate.month}/${_dueDate.day}/${_dueDate.year}", bold: false, size: 20,),
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
                                  _dueDate = result;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      Container(height: 10,),
                      new Row(
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
                      Container(height: 10,),
                      new Row(
                        children: <Widget>[
                          new ThemeTextField(
                            keyboardType: TextInputType.number,
                            label: "Amount",
                            controller: saveAmountController,
                            width: 200,
                            onChanged: (value) {
                              setState(() {
                                dividedAmount = double.parse(value);
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
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
    Firestore.instance.collection('users').document(uid).collection('saves').add({
      'name': saveObject.name,
      'cost': saveObject.cost,
      'frequency': saveObject.frequency,
      'dividedAmount': saveObject.dividedAmount,
      'savedAmount': saveObject.savedAmount,
      'startDate': Timestamp.fromDate(saveObject.startDate),
      'completeDate': Timestamp.fromDate(saveObject.completeDate),
      'icon': saveObject.icon.icon.codePoint,
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
    int times = savingTime.inDays~/gap.inDays;
    return itemCost/times;
  }

  DateTime _getCompleteDate() {
    int saveTimes = 1;
    if(dividedAmount > 0)
      saveTimes = itemCost~/dividedAmount;
    Duration gap = new Duration(days: frequency);
    return new DateTime.now().add(new Duration(days: gap.inDays*saveTimes));
  }
}


class SaveObject {
  String name;
  num cost;
  int frequency;
  num dividedAmount;
  num savedAmount;
  DateTime startDate;
  DateTime completeDate;
  Icon icon;

  SaveObject({
    this.name,
    this.cost,
    this.frequency,
    this.dividedAmount,
    this.savedAmount,
    this.startDate,
    this.completeDate,
    this.icon,
  });
}