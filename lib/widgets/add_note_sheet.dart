import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:visual_notes/providers/notes_data.dart';
import 'package:visual_notes/models/note.dart';
import 'package:visual_notes/screens/camera_screen.dart';

class AddNoteSheet extends StatefulWidget {
  const AddNoteSheet({Key? key}) : super(key: key);

  @override
  _AddNoteSheetState createState() => _AddNoteSheetState();
}

class _AddNoteSheetState extends State<AddNoteSheet> {
  String id = '';
  String title = '';
  String description = '';
  NoteState noteState = NoteState.open;
  String picturePath = '';

  @override
  void dispose() {
    id = '';
    title = '';
    description = '';
    picturePath = '';
    super.dispose();
  }

  void addNote(NotesData notesData) async {
    if (id.isEmpty && title.isEmpty && description.isEmpty && picturePath.isEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Note information cannot be empty, please fill needed fields.'),
              actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Ok'))],
            );
          });
    } else {
      try {
        int tempId = int.parse(id);
        if (tempId.isNegative || tempId.isNaN || tempId == 0) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content: const Text('Please provide proper id.'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          id = '';
                          Navigator.pop(context);
                        },
                        child: const Text('Ok'))
                  ],
                );
              });
        } else if (title.isEmpty) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content: const Text('Please provide proper title.'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          title = '';
                          Navigator.pop(context);
                        },
                        child: const Text('Ok'))
                  ],
                );
              });
        } else if (description.isEmpty) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content: const Text('Please provide proper description.'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          description = '';
                          Navigator.pop(context);
                        },
                        child: const Text('Ok'))
                  ],
                );
              });
        } else if (description.isEmpty) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content: const Text('Please provide a picture.'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          picturePath = '';
                          Navigator.pop(context);
                        },
                        child: const Text('Ok'))
                  ],
                );
              });
        } else {
          Note vn = Note(
            id: id,
            title: title,
            description: description,
            picturePath: picturePath,
            date: DateFormat('MM/DD/yyyy hh:mm a').format(DateTime.now()),
            status: noteState.name,
          );
          notesData.addNote(vn);
          Navigator.pop(context);
        }
      } catch (e) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content: const Text('Please provide proper id.'),
                actions: [
                  TextButton(
                      onPressed: () {
                        id = '';
                        Navigator.pop(context);
                      },
                      child: const Text('Ok'))
                ],
              );
            });
      }
    }
  }

  void clear(NotesData notesData) {
    notesData.clear();
  }

  void readyCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.last;
    final result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) => CameraScreen(camera: camera)));
    setState(() {
      picturePath = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotesData>(builder: (context, notesData, child) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.black,
                elevation: 0,
                title: const Text('Add Note'),
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                ),
                actions: [
                  IconButton(
                    onPressed: () => addNote(notesData),
                    icon: const Icon(Icons.check),
                  )
                ],
              ),
              Container(
                alignment: Alignment.topCenter,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.left,
                          maxLines: null,
                          cursorColor: Colors.teal,
                          decoration: const InputDecoration(
                            hintText: 'ID',
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.teal),
                            ),
                          ),
                          textInputAction: TextInputAction.next,
                          onChanged: (newText) {
                            setState(() {
                              id = newText;
                            });
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          textAlign: TextAlign.left,
                          maxLines: null,
                          cursorColor: Colors.teal,
                          decoration: const InputDecoration(
                            hintText: 'Title',
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.teal),
                            ),
                          ),
                          textInputAction: TextInputAction.next,
                          onChanged: (newText) {
                            setState(() {
                              title = newText;
                            });
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          textAlign: TextAlign.left,
                          maxLines: null,
                          cursorColor: Colors.teal,
                          decoration: const InputDecoration(
                            hintText: 'Description',
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.teal),
                            ),
                          ),
                          textInputAction: TextInputAction.next,
                          onChanged: (newText) {
                            setState(() {
                              description = newText;
                            });
                          },
                        ),
                        Row(
                          children: [
                            Row(
                              children: [
                                Radio(
                                  value: NoteState.open,
                                  groupValue: noteState,
                                  activeColor: Colors.black,
                                  onChanged: (NoteState? value) {
                                    setState(() {
                                      noteState = value!;
                                    });
                                  },
                                ),
                                Text(NoteState.open.name),
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                  value: NoteState.closed,
                                  groupValue: noteState,
                                  activeColor: Colors.black,
                                  onChanged: (NoteState? value) {
                                    setState(() {
                                      noteState = value!;
                                    });
                                  },
                                ),
                                Text(NoteState.closed.name),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: picturePath.isEmpty ? null : 200,
                          child: picturePath.isEmpty ? null : Image.file(File(picturePath)),
                        ),
                        ElevatedButton(
                          onPressed: readyCamera,
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                          ),
                          child: const Text(
                            'Take Picture',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
