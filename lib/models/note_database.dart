import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:notepad_with_isar/models/note.dart';
import 'package:path_provider/path_provider.dart';

class NoteDatabase extends ChangeNotifier {
  static late Isar isar;

  // I N I C I A L I Z A R
  static Future<void> inicializar() async {
    final dir = await getApplicationCacheDirectory();
    isar = await Isar.open([NoteSchema], directory: dir.path);
  }

  // lista de notes
  final List<Note> currentNotes = [];
  bool isThema = true;

  // C R I A R
  Future<void> addNote(String textFromUser) async {
    //criar um novo object note
    final newNote = Note()..text = textFromUser;

    //salvar no db
    await isar.writeTxn(() => isar.notes.put(newNote));

    //re-ler do db
    fetchNotes();
  }

  // L E R
  Future<void> fetchNotes() async {
    List<Note> fetchNotes = await isar.notes.where().findAll();
    currentNotes.clear();
    currentNotes.addAll(fetchNotes);
    notifyListeners();
  }

  // A T U A L I Z A R
  Future<void> updateNote(int id, String newText) async {
    final existingNote = await isar.notes.get(id);
    if (existingNote != null) {
      existingNote.text = newText;
      await isar.writeTxn(() => isar.notes.put(existingNote));
      await fetchNotes();
    }
  }

  // D E L E T A R
  Future<void> deleteNote(int id) async {
    await isar.writeTxn(() => isar.notes.delete(id));
    await fetchNotes();
  }

  // T E M A
}
