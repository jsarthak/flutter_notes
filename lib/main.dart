import 'package:flutter/material.dart';
import 'package:notes_app/constants/theme.dart';
import 'package:notes_app/pages/home/home.dart';
import 'package:notes_app/pages/welcome/welcome.dart';
import 'package:scoped_model/scoped_model.dart';

import 'models/main.dart';

void main() => runApp(NotesApp());

class NotesApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NotesAppState();
  }
}

class _NotesAppState extends State<NotesApp> {
  final MainModel _model = MainModel();
  bool _isAuthenticated = false;

  @override
  void initState() {
    _model.autoTheme();
    _model.autoAuthenticate();
    _model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel _model) {
          return MaterialApp(
            theme: lightTheme,
            // home: !_isAuthenticated
            //     ? WelcomePage(
            //         model: _model,
            //       )
            //     :
            home: HomePage(
              model: _model,
            ),
          );
        },
      ),
    );
  }
}
