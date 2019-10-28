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
  List<SaveData> saveData;

  SaveObject({
    this.name,
    this.cost,
    this.frequency,
    this.dividedAmount,
    this.savedAmount,
    this.startDate,
    this.completeDate,
    this.icon,
    this.saveData,
  });

  factory SaveObject.fromDoc(DocumentSnapshot doc) {
    List<SaveData> saveData = [];
    if(doc.data != null && doc.data['saveData'] != null)
      doc.data['saveData'].forEach((data) {
        saveData.add(new SaveData(amount: data['amount'], date: data['date'].toDate(), saveDay: data['saveDay'], total: data['total']));
      });
    return SaveObject(
      name: doc.data['name'],
      cost: doc.data['cost'],
      frequency: doc.data['frequency'],
      dividedAmount: doc.data['dividedAmount'],
      savedAmount: doc.data['savedAmount'],
      startDate: doc.data['startDate'].toDate(),
      completeDate: doc.data['completeDate'].toDate(),
      icon: new Icon(IconData(doc.data['icon'], fontFamily: 'MaterialIcons')),
      saveData: saveData,
    );
  }
}

class SaveData {
  DateTime date;
  num amount;
  num total;
  bool saveDay;

  SaveData({
    this.date,
    this.amount,
    this.total,
    this.saveDay
  });
}

DateTime getNextPaymentDate(SaveObject saveObject) {
  double projectedSave = 0;
  DateTime nextPayment = saveObject.startDate;
  while(projectedSave < saveObject.savedAmount) {
    nextPayment = nextPayment.add(new Duration(days: saveObject.frequency));
    projectedSave += saveObject.dividedAmount;
  }
  print(saveObject.startDate.toString());
  return nextPayment;
}

double getProjectedSave(SaveObject saveObject, DateTime date) {
  int days = date.difference(saveObject.startDate).inDays;
  return (saveObject.dividedAmount+(days/saveObject.frequency)*saveObject.dividedAmount);
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

double getSuggestedSave(SaveObject save,DateTime date) {
  Duration difference = date.difference(save.startDate);
  if(save.savedAmount == 0 && save.startDate.day == DateTime.now().day && save.startDate.month == DateTime.now().month && save.startDate.year == DateTime.now().year)
    return save.dividedAmount;
  int days = difference.inDays;
  int saveTimes = (days/save.frequency).floor();
  print(saveTimes);
  double projectedAmount = saveTimes*save.dividedAmount;
  double autoFillAmount = projectedAmount - save.savedAmount;
  if(autoFillAmount < 0) autoFillAmount = 0;
  return autoFillAmount;
}