import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visual_notes/providers/notes_data.dart';
import 'package:visual_notes/models/note.dart';
import 'package:visual_notes/widgets/note_tile.dart';

class NotesList extends StatelessWidget {
  const NotesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<NotesData>(builder: (context, notesData, child) {
      return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
        child: ListView.builder(
          itemCount: notesData.notesCount,
          itemBuilder: (context, index) {
            final Note note = notesData.notes[index];

            return NoteTile(note: note);
          },
        ),
      );
    });
  }
}
