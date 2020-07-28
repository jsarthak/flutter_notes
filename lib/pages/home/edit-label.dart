import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:notes_app/models/main.dart';

class EditLabelPage extends StatefulWidget {
  final MainModel model;
  final bool newLabel;

  const EditLabelPage({Key key, this.model, this.newLabel}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _EditLabelPageState();
  }
}

class _EditLabelPageState extends State<EditLabelPage> {
  TextEditingController textEditingController = TextEditingController();
  String labelText = '';
  @override
  void initState() {
    super.initState();

    if (widget.newLabel) {
      widget.model.setSelectedLabel(0);
    } else {
      widget.model.setSelectedLabel(-1);
    }

    textEditingController.addListener(() {
      setState(() {
        labelText = textEditingController.text;
      });
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    widget.model.setSelectedLabel(-1);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        widget.model.setSelectedLabel(-1);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          title: Text('Edit Labels'),
          elevation: 0,
        ),
        body: Container(
          child: ListView.builder(
              itemCount: widget.model.user.labels.length + 1,
              itemBuilder: (context, index) {
                return index == 0
                    ? TextFormField(
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Enter a label name';
                          } else {
                            return null;
                          }
                        },
                        onTap: () {
                          widget.model.setSelectedLabel(index);
                        },
                        controller: textEditingController,
                        autofocus: widget.model.selectedLabel == index,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Create label',
                          hintMaxLines: 1,
                          prefixIcon: GestureDetector(
                            child: textEditingController.text.isEmpty
                                ? Icon(
                                    LineAwesomeIcons.plus,
                                    color: Hexcolor('#191B27'),
                                  )
                                : Icon(LineAwesomeIcons.close,
                                    color: Hexcolor('#191B27')),
                            onTap: () {
                              if (textEditingController.text.isNotEmpty) {
                                textEditingController.text = '';
                              }
                            },
                          ),
                          filled: false,
                          suffixIcon: GestureDetector(
                            child: textEditingController.text.isEmpty
                                ? Icon(LineAwesomeIcons.check,
                                    color: Colors.transparent)
                                : Icon(LineAwesomeIcons.check,
                                    color: Hexcolor('#191B27')),
                            onTap: () {
                              if (textEditingController.text.isNotEmpty) {
                                if (!widget.model.user.labels.contains(
                                    textEditingController.text.trim())) {
                                  widget.model
                                      .createLabel(textEditingController.text);
                                  textEditingController.clear();
                                }
                                print(textEditingController.text);
                              }
                            },
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor,
                                width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.transparent, width: 1.0),
                          ),
                        ),
                      )
                    : LabelEditor(
                        label: widget.model.user.labels[index - 1],
                        index: index,
                        model: widget.model,
                      );
              }),
        ),
      ),
    );
  }
}

class LabelEditor extends StatefulWidget {
  final String label;
  final int index;
  final MainModel model;
  const LabelEditor({Key key, this.label, this.index, this.model})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _LabelEditorState();
  }
}

class _LabelEditorState extends State<LabelEditor> {
  TextEditingController t1 = new TextEditingController();
  FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    if (widget.model.selectedLabel == widget.index) {
      _focusNode.requestFocus();
    }
    t1.text = widget.label;
  }

  @override
  void dispose() {
    t1.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: () {
        widget.model.setSelectedLabel(widget.index);
        _focusNode.requestFocus();
      },
      controller: t1,
      focusNode: _focusNode,
      validator: (val) {
        if (val.isEmpty) {
          return 'Enter a label name';
        } else {
          return null;
        }
      },
      autofocus: widget.model.selectedLabel == widget.index,
      decoration: InputDecoration(
        border: InputBorder.none,
        prefixIcon: GestureDetector(
          child: widget.model.selectedLabel == widget.index
              ? Icon(
                  LineAwesomeIcons.trash_o,
                  color: Hexcolor('#191B27'),
                )
              : Icon(LineAwesomeIcons.tag, color: Hexcolor('#191B27')),
          onTap: () {
            if (widget.model.selectedLabel == widget.index) {
              print('delete' + t1.text);
            }
          },
        ),
        suffixIcon: GestureDetector(
          child: widget.model.selectedLabel == widget.index
              ? Icon(LineAwesomeIcons.check, color: Hexcolor('#191B27'))
              : Icon(LineAwesomeIcons.pencil, color: Hexcolor('#191B27')),
          onTap: () {
            if (widget.model.selectedLabel == widget.index) {
              widget.model.updateLabel(t1.text, widget.index);
              print(t1.text);
            }
          },
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).accentColor, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 1.0),
        ),
      ),
    );
  }
}
