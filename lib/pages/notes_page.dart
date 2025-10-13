import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';
import 'NoteDetailPage.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final int noteIdToDisplay = 1;

  @override
  void initState() {
    super.initState();
    // Provider.of<NoteProvider>(context, listen: false).fetchNoteById(noteIdToDisplay);
    Future.microtask(() =>
        Provider.of<NoteProvider>(context, listen: false).fetchNoteById(noteIdToDisplay));
  }

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);

    if (noteProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (noteProvider.error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Notes')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(noteProvider.error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => noteProvider.fetchNoteById(noteIdToDisplay),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (noteProvider.note == null) {
      return const Scaffold(body: Center(child: Text('No note found')));
    }

    final note = noteProvider.note!;
    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue.shade50,
                radius: 28,
                child: Text('${note.id}',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              const SizedBox(height: 12),
              Text(note.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => NoteDetailPage(note: note)),
                ),
                child: const Text('View More Details'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}