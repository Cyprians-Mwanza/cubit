import '../models/note.dart';

abstract class NoteState {}//

// equitable

class NoteInitial extends NoteState {}

class NoteLoading extends NoteState {}

class NoteLoaded extends NoteState {
  final Note note;
  NoteLoaded(this.note);
}

class NoteError extends NoteState {
  final String message;
  NoteError(this.message);
}
