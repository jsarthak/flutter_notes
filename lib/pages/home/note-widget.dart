import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/constants/values.dart';
import 'package:notes_app/models/main.dart';
import 'package:notes_app/models/note.dart';
import '../note/note.dart';

class NoteListWidget extends StatefulWidget {
  final Note note;
  final MainModel model;
  const NoteListWidget({Key key, @required this.note, @required this.model})
      : super(key: key);

  @override
  _NoteListWidgetState createState() => _NoteListWidgetState();
}

class _NoteListWidgetState extends State<NoteListWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      color: Hexcolor(widget.note.color),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 12,
      shadowColor: widget.note.color == "#ffffff"
          ? Theme.of(context).accentColor.withAlpha(30)
          : Hexcolor(widget.note.color).withAlpha(30),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NotePage(
                      model: widget.model,
                      note: widget.note,
                    )));
          },
          child: Container(
              padding: EdgeInsets.all(contentPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.note.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context)
                            .textTheme
                            .headline1
                            .color
                            .withAlpha(200),
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    widget.note.body,
                    maxLines: 24,
                    overflow: TextOverflow.ellipsis,
                  ),
                  widget.note.labels.length > 0
                      ? Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Wrap(
                              runSpacing: 8,
                              spacing: 8,
                              children: <Widget>[
                                ...buildLabels(widget.note, context)
                              ]),
                        )
                      : Container(),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      DateFormat('EEE, d MMM yyyy')
                          .format(widget.note.modifiedAt),
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}

List<Widget> buildLabels(Note note, BuildContext context) {
  List<Widget> labels = [];
  if (note.labels != null) {
    if (note.labels.length > 0) {
      for (String label in note.labels) {
        labels.add(Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).dividerColor,
                ),
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                label,
                style: TextStyle(fontSize: 12),
              ),
            )));
      }
      return labels;
    } else {
      return [Container()];
    }
  } else {
    return [Container()];
  }
}
