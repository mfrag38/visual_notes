import 'dart:convert';

enum NoteState { open, closed }

extension NoteStateExtension on NoteState {
  String get name {
    switch (this) {
      case NoteState.open:
        return 'Open';
      case NoteState.closed:
        return 'Closed';
    }
  }

  static NoteState fromString(String string) {
    return string == 'Open' ? NoteState.open : NoteState.closed;
  }
}

class Note {
  late final String id;
  late final String title;
  late final String description;
  String picturePath;
  String date;
  String status;

  Note({
    required this.id,
    required this.title,
    required this.description,
    required this.picturePath,
    required this.date,
    required this.status,
  });

  factory Note.fromMap(Map<String, dynamic> map) => Note(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        picturePath: map['picturePath'],
        date: map['date'],
        status: map['status'],
      );

  static Map<String, dynamic> toMap(Note note) => {
        'id': note.id,
        'title': note.title,
        'description': note.description,
        'picturePath': note.picturePath,
        'date': note.date,
        'status': note.status,
      };

  static String encode(List<Note> notes) => json.encode(
        notes.map<Map<String, dynamic>>((note) => Note.toMap(note)).toList(),
      );

  static List<Note> decode(String notes) {
    return notes.isEmpty
        ? []
        : (json.decode(notes) as List<dynamic>).map<Note>((item) => Note.fromMap(item)).toList();
  }
}
