import '../main.dart';
import 'item.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saguaro/user_data_container.dart';

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

