import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  factory SaveObject.fromDoc(DocumentSnapshot doc) {
    return SaveObject(
      name: doc.data['name'],
      cost: doc.data['cost'],
      frequency: doc.data['frequency'],
      dividedAmount: doc.data['dividedAmount'],
      savedAmount: doc.data['savedAmount'],
      startDate: doc.data['startDate'].toDate(),
      completeDate: doc.data['completeDate'].toDate(),
      icon: new Icon(IconData(doc.data['icon'], fontFamily: 'MaterialIcons')),
    );
  }
}

DateTime getNextPaymentDate(SaveObject saveObject) {
  double projectedSave = 0;
  DateTime nextPayment = saveObject.startDate;
  while(projectedSave < saveObject.savedAmount) {
    nextPayment = nextPayment.add(new Duration(days: saveObject.frequency));
    projectedSave += saveObject.dividedAmount;
  }
  return nextPayment;
}

String getNextPaymentDateFormatted(saveObject) {
  DateTime nextPayment = getNextPaymentDate(saveObject);
  return nextPayment.month.toString()+"/"+nextPayment.day.toString()+"/"+nextPayment.year.toString();
}

bool onTime(SaveObject saveObject) {
  DateTime nextPayment = getNextPaymentDate(saveObject);
  if(nextPayment.compareTo(DateTime.now()) < 0 && (nextPayment.day != DateTime.now().day || nextPayment.month != DateTime.now().month || nextPayment.year != DateTime.now().year))
    return false;
  else
    return true;
}