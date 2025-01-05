import 'package:flutter/material.dart';
import 'package:go_parent/Beta%20Testing%20Folder/betaTestmodels/note_model.dart';


import '../services/database/local/sqlite.dart';
import 'betaTestmodels/note_helper.dart';

class NotesScreen extends StatefulWidget {
  final int userId;
  final String username;

  const NotesScreen({
    Key? key,
    required this.userId,
    required this.username,
  }) : super(key: key);

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  late NoteHelper noteHelper;
  List<NoteModel> notes = [];
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeNoteHelper();
  }

  Future<void> _initializeNoteHelper() async {
    final db = await DatabaseService.instance.database;
    noteHelper = NoteHelper(db);
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final userNotes = await noteHelper.getNotesByUserId(widget.userId);
    setState(() {
      notes = userNotes;
    });
  }

  Future<void> _addNote() async {
    if (titleController.text.isEmpty || contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in both title and content')),
      );
      return;
    }

    final newNote = NoteModel(
      userId: widget.userId,
      title: titleController.text,
      content: contentController.text,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await noteHelper.insertNote(newNote);
    titleController.clear();
    contentController.clear();
    _loadNotes();
    Navigator.pop(context);
  }

  Future<void> _deleteNote(int noteId) async {
    await noteHelper.deleteNote(noteId);
    _loadNotes();
  }

  Future<void> _editNote(NoteModel note) async {
    titleController.text = note.title;
    contentController.text = note.content;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Note'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: contentController,
                decoration: InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final updatedNote = note.copyWith(
                title: titleController.text,
                content: contentController.text,
                updatedAt: DateTime.now(),
              );
              await noteHelper.updateNote(updatedNote);
              _loadNotes();
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.username}\'s Notes'),
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(note.title),
              subtitle: Text(
                note.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _editNote(note),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteNote(note.noteId!),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          titleController.clear();
          contentController.clear();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Add New Note'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: contentController,
                      decoration: InputDecoration(
                        labelText: 'Content',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 5,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: _addNote,
                  child: Text('Add'),
                ),
              ],
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }
}