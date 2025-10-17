import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/note.dart';
import '../../services/local/database_helper.dart';
import 'note_state.dart';

class NoteCubit extends Cubit<NoteState> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  NoteCubit() : super(NoteInitial());

  Future<void> fetchAllNotes() async {
    emit(NoteLoading());
    try {
      final notes = await _dbHelper.getNotes();
      emit(NoteLoaded(notes));
    } catch (e) {
      emit(NoteError('Failed to fetch notes: $e'));
    }
  }

  Future<void> addNote(Note note) async {
    try {
      await _dbHelper.insertNote(note);
      emit(NoteActionSuccess('Note added successfully.'));
      fetchAllNotes();
    } catch (e) {
      emit(NoteError('Failed to add note: $e'));
    }
  }

  Future<void> updateNoteById(Note note) async {
    try {
      await _dbHelper.updateNote(note);
      emit(NoteActionSuccess('Note updated successfully.'));
      fetchAllNotes();
    } catch (e) {
      emit(NoteError('Failed to update note: $e'));
    }
  }

  Future<void> deleteNoteById(int id) async {
    try {
      await _dbHelper.deleteNoteById(id);
      emit(NoteActionSuccess('Note deleted successfully.'));
      fetchAllNotes();
    } catch (e) {
      emit(NoteError('Failed to delete note: $e'));
    }
  }
}
