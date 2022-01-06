import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visual_notes/providers/notes_data.dart';
import 'package:visual_notes/models/note.dart';
import 'package:visual_notes/screens/note_details_screen.dart';

class NoteTile extends StatefulWidget {
  final Note note;
  const NoteTile({Key? key, required this.note}) : super(key: key);

  @override
  State<NoteTile> createState() => _NoteTileState();
}

class _NoteTileState extends State<NoteTile> {
  void deleteNote() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm'),
            content: const Text('Do you really want to delete this note'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    Provider.of<NotesData>(context, listen: false).deleteNote(widget.note);
                    Navigator.pop(context);
                  },
                  child: const Text('Ok')),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey,
      child: ListTile(
        title: Text(widget.note.title),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoteDetailsScreen(
              note: widget.note,
            ),
          ),
        ),
        trailing: IconButton(
          onPressed: deleteNote,
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
