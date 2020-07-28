import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:notes_app/models/main.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/pages/welcome/welcome.dart';
import '../../utils/fab-location.dart';
import '../note/note.dart';
import 'edit-label.dart';
import 'note-widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  final MainModel model;

  const HomePage({Key key, this.model}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  int crossAxisCount = 1;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
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

  List<Widget> buildLabelList() {
    List<Widget> labelList = [];
    for (String label in widget.model.user.labels) {
      labelList.add(ListTile(
        title: Text(label),
        leading: Icon(LineAwesomeIcons.tag, color: Hexcolor('#191B27')),
      ));
    }
    return labelList;
  }

  void showLabelOptions(bool newLabel) {
    Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) {
          return EditLabelPage(
            newLabel: newLabel,
            model: widget.model,
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
          key: scaffoldKey,
          extendBody: true,
          floatingActionButtonLocation: FABLocation.endDocked,
          backgroundColor: Theme.of(context).primaryColorLight,
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).accentColor,
            elevation: 8,
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              Navigator.of(context).push(MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => NotePage(
                        model: widget.model,
                      )));
            },
            child: Icon(Icons.add),
          ),
          drawer: Drawer(
            child: Container(
              padding: EdgeInsets.only(top: 24),
              color: Theme.of(context).primaryColor,
              child: SingleChildScrollView(
                child: Container(
                  padding:
                      EdgeInsets.only(left: 16, right: 16, bottom: 64, top: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text('Flutter', style: TextStyle(fontSize: 24)),
                          Text('Keep',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Hexcolor('#191B27'))),
                        ],
                      ),
                      SizedBox(height: 24),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text('Labels',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Hexcolor('#191B27'))),
                          ),
                          GestureDetector(
                            onTap: () {
                              showLabelOptions(false);
                            },
                            child: Text('Edit',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Hexcolor('#191B27'))),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Wrap(children: buildLabelList()),
                      ListTile(
                          onTap: () {
                            showLabelOptions(true);
                          },
                          title: Text('Create new label'),
                          leading: Icon(LineAwesomeIcons.plus,
                              color: Hexcolor('#191B27'))),
                      Divider(),
                      ListTile(
                          title: Text('Archived'),
                          leading: Icon(LineAwesomeIcons.archive,
                              color: Hexcolor('#191B27'))),
                      Divider(),
                      ListTile(
                          title: Text('Settings'),
                          leading: Icon(LineAwesomeIcons.gear,
                              color: Hexcolor('#191B27'))),
                      ListTile(
                          title: Text('Help & feedback'),
                          leading: Icon(LineAwesomeIcons.info_circle,
                              color: Hexcolor('#191B27'))),
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            child: BottomAppBar(
              color: Hexcolor('#191B27'),
              elevation: 8,
              notchMargin: 8.0,
              shape: CircularNotchedRectangle(),
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  height: 56,
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(LineAwesomeIcons.check_circle_o,
                            color: Colors.white),
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                      ),
                      IconButton(
                        icon: Icon(LineAwesomeIcons.microphone,
                            color: Colors.white),
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                      ),
                      IconButton(
                        icon: Icon(LineAwesomeIcons.camera_retro,
                            color: Colors.white),
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                      ),
                      IconButton(
                        icon: Icon(LineAwesomeIcons.paint_brush,
                            color: Colors.white),
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                      )
                    ],
                  )),
            ),
          ),
          body: CustomScrollView(
            scrollDirection: Axis.vertical,
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                automaticallyImplyLeading: false,
                floating: true,
                snap: true,
                title: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                  shadowColor: Theme.of(context).accentColor.withAlpha(50),
                  margin: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(200),
                            child: IconButton(
                              onPressed: () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                scaffoldKey.currentState.openDrawer();
                              },
                              icon: Icon(LineAwesomeIcons.outdent),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                  hintText: 'Search Notes',
                                  border: InputBorder.none),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              setState(() {
                                crossAxisCount == 2
                                    ? crossAxisCount = 1
                                    : crossAxisCount = 2;
                              });
                            },
                            icon: Icon(crossAxisCount == 1
                                ? LineAwesomeIcons.th_list
                                : LineAwesomeIcons.th_large),
                          ),
                          IconButton(
                            onPressed: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(24)),
                                      content: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Wrap(
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Card(
                                                    elevation: 8,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              1000),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Icon(
                                                          LineAwesomeIcons.user,
                                                          size: 42),
                                                    ),
                                                  ),
                                                  SizedBox(width: 16),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                          widget
                                                              .model.user.name,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      Text(
                                                          widget
                                                              .model.user.email,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                          )),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              ListTile(
                                                  leading: Icon(LineAwesomeIcons
                                                      .sign_out),
                                                  title: Text('Logout'),
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                    widget.model.logout();
                                                  })
                                            ],
                                          )),
                                    );
                                  });
                            },
                            icon: Container(child: Icon(LineAwesomeIcons.user)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.only(
                    top: 8,
                    bottom: 84,
                    left: MediaQuery.of(context).size.width > 600
                        ? MediaQuery.of(context).size.width * 0.1
                        : 8,
                    right: MediaQuery.of(context).size.width > 600
                        ? MediaQuery.of(context).size.width * 0.1
                        : 8),
                sliver: crossAxisCount == 2
                    ? SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                        return NoteListWidget(
                            model: widget.model,
                            note: widget.model.notes[index]);
                      }, childCount: widget.model.notes.length))
                    : SliverStaggeredGrid.countBuilder(
                        crossAxisCount: MediaQuery.of(context).size.width < 400
                            ? 2
                            : MediaQuery.of(context).size.width < 800 ? 3 : 4,
                        staggeredTileBuilder: (index) => StaggeredTile.fit(1),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 0,
                        itemCount: widget.model.notes.length,
                        itemBuilder: (context, index) {
                          return NoteListWidget(
                              model: widget.model,
                              note: widget.model.notes[index]);
                        }),
              )
            ],
          )),
    );
  }
}
