import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:notes_app/constants/theme.dart';
import 'package:notes_app/constants/values.dart';
import 'package:notes_app/models/user.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'auth.dart';
import 'note.dart';

mixin ConnectedModel on Model {
  User _authenticatedUser;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  ThemeData _currentTheme;
  int _selectedThemeIndex;
  bool _isDarkTheme;
  bool _bright = false;
  String prefThemeType;
  String _baseUrl = 'https://jsarthak-task-manager.herokuapp.com';
  int _selectedLabel = -1;

  List<Note> _notes = [
    new Note(
        title: 'Lorem Ipsum',
        body:
            "There is no one who loves pain itself, who seeks after it and wants to have it, simply because it is pain...",
        createdAt: DateTime.now(),
        archived: false,
        pinned: false,
        labels: ['Label1', 'Label2'],
        color: noteColors[0],
        id: "1",
        modifiedAt: DateTime.now()),
    new Note(
        title: 'What is Lorem Ipsum?',
        body:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
        createdAt: DateTime.now(),
        archived: false,
        pinned: false,
        color: "#ffffff",
        id: "2",
        labels: [
          'Label1',
        ],
        modifiedAt: DateTime.now()),
    new Note(
        id: "3",
        title: 'What is Lorem Ipsum?',
        body:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
        createdAt: DateTime.now(),
        archived: false,
        pinned: false,
        labels: [],
        color: "#ffffff",
        modifiedAt: DateTime.now()),
    new Note(
        id: "4",
        title: 'What is Lorem Ipsum?',
        body:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
        createdAt: DateTime.now(),
        labels: [],
        archived: false,
        pinned: false,
        color: noteColors[1],
        modifiedAt: DateTime.now()),
    new Note(
        title: 'What is Lorem Ipsum?',
        labels: [],
        id: "5",
        body:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
        createdAt: DateTime.now(),
        archived: false,
        pinned: false,
        color: "#ffffff",
        modifiedAt: DateTime.now()),
    new Note(
        title: 'Lorem Ipsum',
        id: "6",
        body:
            "There is no one who loves pain itself, who seeks after it and wants to have it, simply because it is pain...",
        createdAt: DateTime.now(),
        archived: false,
        pinned: false,
        color: "#ffffff",
        labels: [],
        modifiedAt: DateTime.now()),
    new Note(
        title: 'Lorem Ipsum',
        id: "7",
        body:
            "There is no one who loves pain itself, who seeks after it and wants to have it, simply because it is pain...",
        createdAt: DateTime.now(),
        archived: false,
        pinned: false,
        color: "#ffffff",
        labels: [],
        modifiedAt: DateTime.now()),
    new Note(
        id: "8",
        title: 'Lorem Ipsum',
        labels: [],
        color: "#ffffff",
        body:
            " who seeks after it and wants to have it, simply because it is pain...",
        createdAt: DateTime.now(),
        archived: false,
        pinned: false,
        modifiedAt: DateTime.now()),
  ];

  int get selectedLabel {
    return _selectedLabel;
  }

  void setSelectedLabel(int value) {
    _selectedLabel = value;
    notifyListeners();
  }

  bool get isLoading {
    return _isLoading;
  }

  bool get isAuthenticated {
    return _isAuthenticated;
  }
}

mixin NoteModel on ConnectedModel {
  List<Note> get notes {
    return _notes;
  }

  createNote(Note note) async {
    note.createdAt = DateTime.now();
    note.modifiedAt = DateTime.now();
    _notes.insert(0, note);
    notifyListeners();
  }

  updateNote(Note note) async {
    int index = notes.indexWhere((element) => element.id == note.id);
    if (index >= 0) {
      _notes.removeAt(index);
      _notes.insert(index, note);
      notifyListeners();
    }
  }

  deleteNote(Note note) async {
    int index = notes.indexWhere((element) => element.id == note.id);
    if (index >= 0) {
      _notes.removeAt(index);
      notifyListeners();
    }
  }
}

mixin UserModel on ConnectedModel {
  PublishSubject<bool> _userSubject = PublishSubject();
  User get user {
    return User(
      email: "jsarthak@outlook.com",
      id: '123',
      labels: [],
      name: 'Sarthak',
    );
  }

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

  Future<Map<String, dynamic>> authenticate(Map<String, dynamic> authData,
      [AuthMode mode = AuthMode.Login]) async {
    _isLoading = true;
    notifyListeners();

    http.Response response;

    if (mode == AuthMode.Login) {
      response = await http.post(
        '$_baseUrl/users/login',
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
      );
    } else {
      response = await http.post(
        '$_baseUrl/users',
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
      );
    }
    bool hasError = true;
    String message = 'Something went wrong.';
    print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey('token')) {
        hasError = false;
        message = 'Authentication succeeded!';
        _authenticatedUser = User(
            id: responseData['user']['_id'],
            email: responseData['user']['email'],
            name: responseData['user']['name'],
            labels: [],
            token: responseData['token']);
        //setAuthTimeout(int.parse(responseData['expiresIn']));
        _userSubject.add(true);
        // final DateTime now = DateTime.now();
        // final DateTime expiryTime =
        //     now.add(Duration(seconds: int.parse(responseData['expiresIn'])));
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', responseData['token']);
        prefs.setString('email', responseData['user']['email']);
        prefs.setString('name', responseData['user']['name']);
        prefs.setStringList('labels', []);
        prefs.setString('id', responseData['user']['id']);
        _isAuthenticated = true;
        notifyListeners();
      }
    } else {
      message = 'Unable to login with the email and password.';
    }
    _isAuthenticated = false;
    _isLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }

  void autoAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    if (token != null) {
      _authenticatedUser = User(
          id: prefs.getString('id'),
          email: prefs.getString('email'),
          token: token,
          name: prefs.getString('name'),
          labels: prefs.getStringList('labels'));
      _userSubject.add(true);
      _isAuthenticated = true;
      notifyListeners();
    }
  }

  void createLabel(String label) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _authenticatedUser.labels.add(label);
    notifyListeners();
    prefs.setStringList('labels', _authenticatedUser.labels);
  }

  void updateLabel(String label, int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _authenticatedUser.labels.removeAt(index);
    _authenticatedUser.labels.insert(index, label);
    notifyListeners();
    prefs.setStringList('labels', _authenticatedUser.labels);
  }

  void logout() async {
    _authenticatedUser = null;
    _isAuthenticated = false;
    _userSubject.add(false);
    notifyListeners();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}

mixin ThemeModel on ConnectedModel {
  ThemeData get theme {
    return _currentTheme;
  }

  setBright(bool val) {
    _bright = val;
    notifyListeners();
  }

  get bright {
    return _bright;
  }

  int get selectedThemeIndex {
    return _selectedThemeIndex;
  }

  bool get isDarkTheme {
    return _isDarkTheme;
  }

  setSelectedTheme(int value) {
    _selectedThemeIndex = value;
    notifyListeners();
  }

  get selectedThemeSystem {
    return prefThemeType;
  }

  void setPreftype(String val) async {
    prefThemeType = val;
    notifyListeners();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('theme_system', val);
  }

  void handleThemeChange(int value, bool dark) {
    if (value == 1) {
      setTheme(dark, false);
    } else if (value == 0) {
      setTheme(dark, false);
    } else {
      setTheme(dark, true);
    }
    notifyListeners();
  }

  void setTheme(bool setdarkTheme, bool auto) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _isDarkTheme = setdarkTheme;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Hexcolor('#191B27'),
        systemNavigationBarIconBrightness: Brightness.light));

    if (auto) {
      if (setdarkTheme) {
        _currentTheme = darkTheme;
        sharedPreferences.setString('current_theme', 'dark');
        setPreftype('auto');
        _selectedThemeIndex = 2;
      } else {
        _currentTheme = lightTheme;
        _selectedThemeIndex = 2;
        sharedPreferences.setString('current_theme', 'light');
        setPreftype('auto');
      }
    } else {
      if (setdarkTheme) {
        _currentTheme = darkTheme;
        sharedPreferences.setString('current_theme', 'dark');
        setPreftype('manual');
        _selectedThemeIndex = 1;
      } else {
        _currentTheme = lightTheme;
        _selectedThemeIndex = 0;
        sharedPreferences.setString('current_theme', 'light');
        setPreftype('manual');
      }
    }
    notifyListeners();
  }

  void autoTheme() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    if (sharedPreferences.containsKey("theme_system")) {
      prefThemeType = sharedPreferences.getString('theme_system');
      notifyListeners();
      if (sharedPreferences.getString("theme_system") == 'manual') {
        if (sharedPreferences.containsKey('current_theme')) {
          if (sharedPreferences.getString('current_theme') == 'light') {
            setTheme(false, false);
          } else {
            setTheme(true, false);
          }
        } else {
          setTheme(_bright, false);
        }
      } else {
        setTheme(_bright, true);
      }
    } else {
      prefThemeType = 'auto';
      setTheme(_bright, true);
    }

    notifyListeners();
  }
}
