import 'package:equatable/equatable.dart';
import '../../models/note.dart';

abstract class NoteState extends Equatable {
  const NoteState();

  @override
  List<Object?> get props => [];
}

class NoteInitial extends NoteState {}

class NoteLoading extends NoteState {}

class NoteLoaded extends NoteState {
  final Note note;

  const NoteLoaded(this.note);

  @override
  List<Object?> get props => [note];
}

class NoteError extends NoteState {
  final String message;

  const NoteError(this.message);

  @override
  List<Object?> get props => [message];
}
