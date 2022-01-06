import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'package:visual_notes/providers/notes_data.dart';
import 'package:visual_notes/models/note.dart';
import 'package:visual_notes/screens/camera_screen.dart';
import 'package:visual_notes/screens/display_picture_screen.dart';

class NoteDetailsScreen extends StatefulWidget {
  final Note note;
  const NoteDetailsScreen({Key? key, required this.note}) : super(key: key);

  @override
  _NoteDetailsScreenState createState() => _NoteDetailsScreenState();
}

class _NoteDetailsScreenState extends State<NoteDetailsScreen> {
  bool isEditing = false;
  late String id;
  late String title;
  late String description;
  late String picturePath;
  late NoteState status;

  @override
  void initState() {
    id = widget.note.id;
    title = widget.note.title;
    description = widget.note.description;
    picturePath = widget.note.picturePath;
    status = NoteStateExtension.fromString(widget.note.status);
    super.initState();
  }

  void updateNote(NotesData notesData) {
    Note newNote = Note(
      id: id,
      title: title,
      description: description,
      picturePath: picturePath,
      date: widget.note.date,
      status: status.name,
    );
    notesData.updateNote(widget.note, newNote);
    setState(() {
      isEditing = false;
    });
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

  void displayImage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => DisplayPictureScreen(isTaking: false, picturePath: picturePath)));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotesData>(builder: (context, notesData, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(title),
          actions: [
            isEditing
                ? IconButton(
                    onPressed: () => updateNote(notesData),
                    icon: const Icon(Icons.check),
                  )
                : IconButton(
                    onPressed: () => setState(() {
                      isEditing = true;
                    }),
                    icon: const Icon(Icons.create),
                  )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: const Text(
                        'ID: ',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        widget.note.id,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.black,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: const Text(
                        'Title: ',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextFormField(
                          enabled: isEditing,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          textAlign: TextAlign.left,
                          maxLines: null,
                          cursorColor: Colors.teal,
                          decoration: const InputDecoration(
                            hintText: 'Title',
                            border: InputBorder.none,
                          ),
                          initialValue: title,
                          textInputAction: TextInputAction.next,
                          onChanged: (newText) {
                            setState(() {
                              title = newText;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.black,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: const Text(
                        'Description: ',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextFormField(
                          enabled: isEditing,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          textAlign: TextAlign.left,
                          maxLines: null,
                          cursorColor: Colors.teal,
                          decoration: const InputDecoration(
                            hintText: 'Description',
                            border: InputBorder.none,
                          ),
                          initialValue: description,
                          textInputAction: TextInputAction.done,
                          onChanged: (newText) {
                            setState(() {
                              description = newText;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.black,
                ),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: const Text(
                        'Date: ',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        widget.note.date,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.black,
                ),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: const Text(
                        'Status: ',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          isEditing
                              ? Row(
                                  children: [
                                    Row(
                                      children: [
                                        Radio(
                                          value: NoteState.open,
                                          groupValue: status,
                                          activeColor: Colors.black,
                                          onChanged: (NoteState? value) {
                                            setState(() {
                                              status = value!;
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
                                          groupValue: status,
                                          activeColor: Colors.teal,
                                          onChanged: (NoteState? value) {
                                            setState(() {
                                              status = value!;
                                            });
                                          },
                                        ),
                                        Text(NoteState.closed.name),
                                      ],
                                    ),
                                  ],
                                )
                              : Container(
                                  margin: const EdgeInsets.symmetric(vertical: 12),
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    status.name,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: const Divider(
                    color: Colors.black,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 25,
                  height: MediaQuery.of(context).size.width - 25,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: InkWell(
                    onTap: isEditing ? readyCamera : displayImage,
                    child: Image.file(File(picturePath)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
