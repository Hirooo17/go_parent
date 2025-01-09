import 'package:flutter/material.dart';
import 'package:go_parent/Beta%20Testing%20Folder/betaTestmodels/note_helper.dart';
import 'package:go_parent/Beta%20Testing%20Folder/betaTestmodels/note_model.dart';
import 'package:go_parent/Beta%20Testing%20Folder/note_screen.dart';
import 'package:go_parent/services/database/local/sqlite.dart';

class DashboardScreen extends StatelessWidget {
  final String username;
  final int userId;

  const DashboardScreen({
    Key? key,
    required this.username,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            _buildDashboardGrid(context),
            SizedBox(height: 20),
            _buildRecentNotes(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      padding: EdgeInsets.all(16.0),
      children: [
        _buildDashboardCard(
          'Notes',
          Icons.note,
          Colors.blue,
          context,
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotesScreen(
                userId: userId,
                username: username,
              ),
            ),
          ),
        ),
        // Other dashboard cards...
      ],
    );
  }

  Widget _buildDashboardCard(
    String title,
    IconData icon,
    Color color,
    BuildContext context,
    VoidCallback onTap,
  ) {
    return Card(
      color: color,
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 50),
              SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentNotes(BuildContext context) {
    return FutureBuilder<List<NoteModel>>(
      future: _loadRecentNotes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('No recent notes'),
          );
        }

        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recent Notes',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.length > 3 ? 3 : snapshot.data!.length,
                itemBuilder: (context, index) {
                  final note = snapshot.data![index];
                  return Card(
                    child: ListTile(
                      title: Text(note.title),
                      subtitle: Text(
                        note.content,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotesScreen(
                            userId: userId,
                            username: username,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<List<NoteModel>> _loadRecentNotes() async {
    final db = await DatabaseService.instance.database;
    final noteHelper = NoteHelper(db);
    return noteHelper.getNotesByUserId(userId);
  }
}