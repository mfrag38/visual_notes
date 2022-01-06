import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visual_notes/models/note.dart';

class NotesData extends ChangeNotifier {
  List<Note> _notes = [];
  SharedPreferences? _prefs;

  UnmodifiableListView<Note> get notes {
    return UnmodifiableListView(_notes);
  }

  int get notesCount {
    return _notes.length;
  }

  void addNote(Note note) {
    _initPrefs();
    _notes.add(note);
    _saveToPrefs();
    notifyListeners();
  }

  void updateNote(Note oldNote, Note newNote) {
    _notes[_notes.indexOf(oldNote)] = newNote;
    _saveToPrefs();
    notifyListeners();
  }

  void deleteNote(Note note) {
    _notes.remove(note);
    _saveToPrefs();
    notifyListeners();
  }

  void loadNotes() {
    _loadFromPrefs();
  }

  void clear() {
    _notes.clear();
    _clearPrefs();
    notifyListeners();
  }

  _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    _initStore();
  }

  _initStore() async {
    if (_prefs!.getString('notes') == null) {
      _prefs!.setString('notes', '');
    }
  }

  _loadFromPrefs() async {
    await _initPrefs();
    String notesString = _prefs!.getString('notes')!;
    _notes = Note.decode(notesString);
    notifyListeners();
  }

  _saveToPrefs() async {
    await _initPrefs();
    final String encodedNotes = Note.encode(_notes);
    _prefs!.setString('notes', encodedNotes);
    _loadFromPrefs();
  }

  _clearPrefs() async {
    await _initPrefs();
    _prefs!.remove('notes');
  }
}
