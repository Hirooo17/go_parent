import 'package:go_parent/Beta%20Testing%20Folder/betaTestmodels/note_model.dart';
import 'package:sqflite/sqflite.dart';


class NoteHelper {
  final Database db;

  NoteHelper(this.db);

 

  Future<NoteModel> insertNote(NoteModel note) async {
    final id = await db.insert('notesdb', note.toMap());
    return note.copyWith(noteId: id);
  }

  Future<List<NoteModel>> getNotesByUserId(int userId) async {
      

    
    final List<Map<String, dynamic>> maps = await db.query(
      'notesdb',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) => NoteModel.fromMap(maps[i]));
  }

  Future<NoteModel?> getNoteById(int noteId) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'notesdb',
      where: 'noteId = ?',
      whereArgs: [noteId],
    );

    if (maps.isEmpty) return null;
    return NoteModel.fromMap(maps.first);
  }

  Future<bool> updateNote(NoteModel note) async {
    final count = await db.update(
      'notesdb',
      note.toMap(),
      where: 'noteId = ?',
      whereArgs: [note.noteId],
    );
    return count > 0;
  }

  Future<bool> deleteNote(int noteId) async {
    final count = await db.delete(
      'notesdb',
      where: 'noteId = ?',
      whereArgs: [noteId],
    );
    return count > 0;
  }

  Future<int> getNotesCount(int userId) async {
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM notesdb WHERE userId = ?',
      [userId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }
}