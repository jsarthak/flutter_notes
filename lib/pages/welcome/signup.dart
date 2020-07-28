import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:notes_app/models/auth.dart';
import 'package:notes_app/models/main.dart';
import 'package:notes_app/pages/home/home.dart';

import 'auth.dart';

class SignUpPage extends StatefulWidget {
  final MainModel model;

  const SignUpPage({Key key, this.model}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SignUpPageState();
  }
}

class _SignUpPageState extends State<SignUpPage> {
  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
    'acceptTerms': false
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AuthMode _authMode = AuthMode.Signup;

  void _submitForm(Function authenticate) async {
    if (!_formKey.currentState.validate() || !_formData['acceptTerms']) {
      return;
    }
    _formKey.currentState.save();
    Map<String, dynamic> successInformation;
    successInformation = await authenticate(_formData, _authMode);
    if (successInformation['success']) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                    model: widget.model,
                  )));
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: Text('An Error Occurred!'),
            content: Text(successInformation['message']),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay',
                    style: TextStyle(color: Theme.of(context).accentColor)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    }
  }

  InputDecoration textFieldDecoration(String label, IconData icon) {
    return InputDecoration(
        filled: false,
        focusedErrorBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).accentColor, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).accentColor, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).accentColor, width: 1.0),
        ),
        border: InputBorder.none,
        errorBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).accentColor, width: 1.0),
        ),
        labelText: label,
        errorStyle: TextStyle(color: Hexcolor('FB7546')),
        labelStyle: TextStyle(color: Theme.of(context).accentColor),
        icon: new Icon(
          icon,
          color: Hexcolor('#191B27'),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          title: Text('Signup'),
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: Center(
            child: SingleChildScrollView(
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          autofocus: false,
                          onSaved: (String value) {
                            _formData['name'] = value;
                          },
                          decoration: textFieldDecoration(
                              'Full name', LineAwesomeIcons.user_plus),
                          validator: (value) =>
                              value.isEmpty ? 'Name can\'t be empty' : null,
                          //onSaved: (value) => _password = value.trim(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                            maxLines: 1,
                            keyboardType: TextInputType.emailAddress,
                            autofocus: false,
                            validator: (value) {
                              if (value.isEmpty ||
                                  !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                      .hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                            onSaved: (String value) {
                              _formData['email'] = value;
                            },
                            decoration: textFieldDecoration(
                                'E-mail', LineAwesomeIcons.user)),
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          maxLines: 1,
                          obscureText: true,
                          autofocus: false,
                          onSaved: (String value) {
                            _formData['password'] = value;
                          },
                          decoration: textFieldDecoration(
                              'Password', LineAwesomeIcons.lock),
                          validator: (value) => value.isEmpty
                              ? 'Password can\'t be empty'
                              : value.length < 8
                                  ? 'Password must be atlease 8 characters'
                                  : null,
                          //onSaved: (value) => _password = value.trim(),
                        ),
                      ),
                      SizedBox(height: 12),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _formData['acceptTerms'] =
                                !_formData['acceptTerms'];
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Checkbox(
                                value: _formData['acceptTerms'],
                                onChanged: (val) {
                                  setState(() {
                                    setState(() {
                                      _formData['acceptTerms'] = val;
                                    });
                                  });
                                }),
                            Text('I ageree to Terms & Contitions')
                          ],
                        ),
                      ),
                      widget.model.isLoading
                          ? CircularProgressIndicator()
                          : Hero(
                              tag: 'sign-btn',
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: RaisedButton(
                                  onPressed: () {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    _submitForm(widget.model.authenticate);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width /
                                                5,
                                        vertical: 18),
                                    child: Text('Signup'.toUpperCase(),
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
                        tag: 'login_btn',
                        child: FlatButton(
                            onPressed: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return LoginPage(model: widget.model);
                              }));
                            },
                            hoverColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            color: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text('Already have an account? ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w400)),
                                SizedBox(width: 2),
                                Text('Login',
                                    style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                    ))
                              ],
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
