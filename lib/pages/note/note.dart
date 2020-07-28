import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:notes_app/constants/values.dart';
import 'package:notes_app/models/main.dart';
import 'package:notes_app/models/note.dart';
import 'package:share/share.dart';

class NotePage extends StatefulWidget {
  final MainModel model;
  final Note note;

  const NotePage({Key key, this.model, this.note}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _NotePageState();
  }
}

class _NotePageState extends State<NotePage> {
  Note note;
  TextEditingController titleController;
  TextEditingController contentController;
  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(
        text: widget.note != null ? widget.note.title : '');
    contentController = TextEditingController(
        text: widget.note != null ? widget.note.body : '');
    if (widget.note != null) {
      note = widget.note;
    } else {
      note = new Note(
        pinned: false,
        labels: [],
        color: "#FFFFFF",
        archived: false,
      );
    }
  }

  @override
  void dispose() {
    if (widget.note != null) {
      widget.model.updateNote(Note(
        id: note.id,
        color: note.color,
        title: titleController.text,
        body: contentController.text,
        labels: note.labels,
        archived: note.archived,
        createdAt: note.createdAt,
        modifiedAt: DateTime.now(),
        pinned: note.pinned,
      ));
    } else if (titleController.text.isNotEmpty ||
        contentController.text.isNotEmpty) {
      note.title = titleController.text;
      note.body = contentController.text;
      widget.model.createNote(note);
    }

    super.dispose();
  }

  void showLabelSelector() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            elevation: 8,
            contentPadding: EdgeInsets.all(0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: Text('Select labels'),
            actions: <Widget>[
              FlatButton(
                child:
                    Text('Close', style: TextStyle(color: Hexcolor('#191B27'))),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
            content: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                  itemCount: widget.model.user.labels.length,
                  itemBuilder: (context, index) {
                    bool val =
                        note.labels.contains(widget.model.user.labels[index]);

                    return StatefulBuilder(builder: (context, state) {
                      return CheckboxListTile(
                          title: Text(widget.model.user.labels[index],
                              style: TextStyle(color: Hexcolor('#191B27'))),
                          value: val,
                          onChanged: (value) {
                            state(() {
                              val = value;
                            });
                            setState(() {
                              if (value &&
                                  !note.labels.contains(
                                      widget.model.user.labels[index])) {
                                note.labels
                                    .add(widget.model.user.labels[index]);
                              } else if (!value &&
                                  note.labels.contains(
                                      widget.model.user.labels[index])) {
                                note.labels
                                    .remove(widget.model.user.labels[index]);
                              }
                            });
                          });
                    });
                  }),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Hexcolor(note.color),
        bottomSheet: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24), topRight: Radius.circular(24)),
          child: BottomAppBar(
              color: Hexcolor('#191B27'),
              elevation: 8,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                height: 64,
                child: Row(children: <Widget>[
                  IconButton(
                      icon: Icon(LineAwesomeIcons.plus_circle,
                          color: Colors.white),
                      onPressed: () {}),
                  Expanded(
                    child: Center(
                      child: Text(
                        DateFormat('EEE, d mm yyyy, h:mm a')
                            .format(DateTime.now()),
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                  IconButton(
                      icon: Icon(LineAwesomeIcons.ellipsis_h,
                          color: Colors.white),
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            barrierColor: Colors.white.withAlpha(0),
                            builder: (context) {
                              return StatefulBuilder(
                                  builder: (context, StateSetter state) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(24),
                                      topRight: Radius.circular(24)),
                                  child: SingleChildScrollView(
                                    child: Container(
                                      color: Hexcolor('#191B27'),
                                      margin: EdgeInsets.only(
                                          bottom: 42, left: 0, right: 0),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Wrap(
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                height: 42,
                                                child: ListView.builder(
                                                  itemCount: noteColors.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          note.color =
                                                              noteColors[index]
                                                                  .toLowerCase();
                                                        });
                                                        state(() {
                                                          note.color =
                                                              noteColors[index]
                                                                  .toLowerCase();
                                                        });
                                                      },
                                                      child: Stack(
                                                        alignment:
                                                            Alignment.center,
                                                        children: <Widget>[
                                                          Container(
                                                            height: 42,
                                                            width: 42,
                                                            alignment: Alignment
                                                                .center,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 8,
                                                                    right: 0),
                                                            decoration: (BoxDecoration(
                                                                gradient:
                                                                    RadialGradient(
                                                                        colors: [
                                                                      Hexcolor(
                                                                          noteColors[
                                                                              index]),
                                                                      Colors
                                                                          .white
                                                                          .withAlpha(
                                                                              20)
                                                                    ]),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100))),
                                                          ),
                                                          Container(
                                                            alignment: Alignment
                                                                .center,
                                                            height: 36,
                                                            width: 36,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 8,
                                                                    right: 0),
                                                            decoration: (BoxDecoration(
                                                                color: Hexcolor(
                                                                    noteColors[
                                                                        index]),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100))),
                                                          ),
                                                          noteColors[index]
                                                                      .toLowerCase() ==
                                                                  note.color
                                                                      .toLowerCase()
                                                              ? Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          8.0),
                                                                  child: Center(
                                                                      child: Icon(
                                                                          LineAwesomeIcons
                                                                              .check,
                                                                          size:
                                                                              20)),
                                                                )
                                                              : Container(),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                ),
                                              ),
                                            ),
                                            ListTile(
                                                onTap: () {
                                                  if (widget.note != null) {
                                                    widget.model.deleteNote(
                                                        widget.note);
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).pop();
                                                  }
                                                },
                                                leading: Icon(
                                                    LineAwesomeIcons.trash_o,
                                                    color: Colors.white),
                                                title: Text('Delete note',
                                                    style: TextStyle(
                                                        color: Colors.white))),
                                            ListTile(
                                                leading: Icon(
                                                    LineAwesomeIcons.copy,
                                                    color: Colors.white),
                                                title: Text('Make a copy',
                                                    style: TextStyle(
                                                        color: Colors.white))),
                                            ListTile(
                                                onTap: () {
                                                  Share.share(
                                                      contentController.text);
                                                },
                                                leading: Icon(
                                                    LineAwesomeIcons.share_alt,
                                                    color: Colors.white),
                                                title: Text('Share',
                                                    style: TextStyle(
                                                        color: Colors.white))),
                                            ListTile(
                                                onTap: showLabelSelector,
                                                leading: Icon(
                                                    LineAwesomeIcons.tags,
                                                    color: Colors.white),
                                                title: Text('Labels',
                                                    style: TextStyle(
                                                        color: Colors.white)))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              });
                            });
                      }),
                ]),
              )),
        ),
        appBar: AppBar(
          backgroundColor: Hexcolor(note.color),
          elevation: 0,
          actions: <Widget>[
            IconButton(
              icon: Icon(LineAwesomeIcons.map_pin,
                  color: note.pinned
                      ? Theme.of(context).accentColor
                      : Hexcolor('#191B27')),
              onPressed: () {
                setState(() {
                  note.pinned = !note.pinned;
                });
              },
            ),
            IconButton(
              icon: Icon(LineAwesomeIcons.archive,
                  color: note.archived
                      ? Theme.of(context).accentColor
                      : Hexcolor('#191B27')),
              onPressed: () {
                setState(() {
                  note.archived = !note.archived;
                });
              },
            ),
            SizedBox(width: 16),
          ],
          leading: IconButton(
            icon: Icon(LineAwesomeIcons.arrow_left),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Container(
          padding: EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 32),
          child: SingleChildScrollView(
              child: Column(
            children: <Widget>[
              TextFormField(
                controller: titleController,
                autofocus: false,
                keyboardType: TextInputType.text,
                autocorrect: true,
                style: Theme.of(context).textTheme.headline5.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Title',
                ),
              ),
              TextFormField(
                controller: contentController,
                autofocus: false,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                autocorrect: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Note',
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
