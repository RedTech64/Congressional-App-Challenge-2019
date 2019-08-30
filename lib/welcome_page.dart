import 'package:flutter/material.dart';
import 'common_widgets.dart';
import 'create flow/selection_page.dart';
import 'main.dart';
import 'user_data_container.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'create flow/item.dart';

class WelcomePage extends StatefulWidget {

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  TextEditingController nameController;
  String name;

  _WelcomePageState();

  @override
  void initState() {
    nameController = new TextEditingController(text: name);
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    var container = StateContainer.of(context);
    return new Scaffold(


      backgroundColor: Color.fromRGBO(105,240,174,1.0),
      
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragEnd: (details) {


          Navigator.pushReplacement(context,

            new MaterialPageRoute(
                builder: (BuildContext context) {
                  return new ItemPage();
                }
            )
          );
        },
        child: Padding(
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
                new Text(
                  'Welcome',
                  style: new TextStyle(
                    color: Color.fromRGBO(255,255,255, 1.0),
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                new Text(
                  'In the 1960s, the U.S. savings rate was well above 10%',
                  style: new TextStyle(
                    color: Color.fromRGBO(255,255,255, 1.0),
                  ),
                ),
                new Text(
                  'Today it is 6%',
                  style: new TextStyle(
                    color: Color.fromRGBO(255,255,255, 1.0),
                  ),
                ),
                new Text(
                  'Our goal is to help you save more to build yourself a stronger financial foundation.',
                  style: new TextStyle(
                    color: Color.fromRGBO(255,255,255, 1.0),
                  ),
                  textAlign: TextAlign.center,
                ),
                new Spacer(flex: 1,),

                new Spacer(flex: 5,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}