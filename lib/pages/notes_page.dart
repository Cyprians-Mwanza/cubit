import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/note_cubit.dart';
import '../cubits/note_state.dart';
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
    Future.microtask(() =>
        context.read<NoteCubit>().fetchNoteById(noteIdToDisplay));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      body: BlocConsumer<NoteCubit, NoteState>(
        listener: (context, state) {
          if (state is NoteError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is NoteLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NoteLoaded) {
            final note = state.note;
            return Center(
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
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => NoteDetailPage(note: note)),
                      ),
                      child: const Text('View More Details'),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is NoteError) {
            return Center(
              child: ElevatedButton(
                onPressed: () =>
                    context.read<NoteCubit>().fetchNoteById(noteIdToDisplay),
                child: const Text('Retry'),
              ),
            );
          } else {
            return const Center(child: Text('No note found'));
          }
        },
      ),
    );
  }
}
