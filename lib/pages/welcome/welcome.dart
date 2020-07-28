import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:notes_app/constants/values.dart';
import 'package:notes_app/models/main.dart';
import 'package:notes_app/pages/welcome/signup.dart';

import 'auth.dart';

class WelcomePage extends StatefulWidget {
  final MainModel model;

  const WelcomePage({Key key, this.model}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WelcomePageState();
  }
}

class _WelcomePageState extends State<WelcomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final Brightness brightness =
        WidgetsBinding.instance.window.platformBrightness;
    widget.model.setBright(brightness != Brightness.light);
  }

  @override
  void didChangePlatformBrightness() {
    final Brightness brightness =
        WidgetsBinding.instance.window.platformBrightness;
    widget.model.setBright(brightness != Brightness.light);
    print(brightness);
    if (widget.model.prefThemeType == 'auto') {
      if (brightness == Brightness.dark) {
        widget.model.setTheme(true, true);
      } else {
        widget.model.setTheme(false, true);
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(child: Icon(Icons.ac_unit, size: 120))),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24))),
                color: Hexcolor('#191B27'),
                margin: EdgeInsets.all(0),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16, top: 48, bottom: 24),
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: <Widget>[
                          Text('FlutterKeep',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              )),
                          SizedBox(height: 8),
                          Text('The only notes app you will ever need!',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              )),
                          SizedBox(height: 32),
                          Hero(
                            tag: 'login_btn',
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: RaisedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return LoginPage(model: widget.model);
                                  }));
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.width / 5,
                                      vertical: 18),
                                  child: Text('Login'.toUpperCase(),
                                      style: TextStyle(color: Colors.white)),
                                ),
                                elevation: 8,
                                color: Theme.of(context).accentColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100)),
                              ),
                            ),
                          ),
                          Hero(
                            tag: 'sign-btn',
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16, top: 8, bottom: 24),
                              child: RaisedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return SignUpPage(model: widget.model);
                                  }));
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.width / 5,
                                      vertical: 18),
                                  child: Text('Signup'.toUpperCase(),
                                      style: TextStyle(color: Colors.black)),
                                ),
                                elevation: 8,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100)),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
