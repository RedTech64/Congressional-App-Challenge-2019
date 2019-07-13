import 'package:flutter/material.dart';
import 'common_widgets.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  TextEditingController nameController;
  String name;

  @override
  void initState() {
    nameController = new TextEditingController(text: name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Spacer(flex: 4),
              new Placeholder(
                fallbackWidth: 100,
                fallbackHeight: 200,
              ),
              new Spacer(flex: 2,),
              new SimpleText('Welcome',size: 24.0, bold: true,),
              new Text(
                'In the 1960s, the U.S. savings rate was well above 10%'
              ),
              new Text(
                'Today it is 6%'
              ),
              new Text(
                'Our goal is to help you save more to build yourself a stronger financial foundation.',
                textAlign: TextAlign.center,
              ),
              new Spacer(flex: 1,),
              new ThemeButton(
                text: 'GET STARTED ',
                icon: new Icon(Icons.arrow_forward_ios),
                size: 36.0,
                onPressed: () {},
              ),
              new Spacer(flex: 5,),
            ],
          ),
        ),
      ),
    );
  }
}