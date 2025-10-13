import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/note.dart';
import '../../services/api_service.dart';
import 'note_state.dart';

class NoteCubit extends Cubit<NoteState> {
  final ApiService _apiService;

  NoteCubit(this._apiService) : super(NoteInitial());

  Future<void> fetchNoteById(int id) async {
    emit(NoteLoading());
    try {
      final Note note = await _apiService.fetchNoteById(id);
      emit(NoteLoaded(note));
    } catch (e) {
      emit(NoteError(e.toString()));
    }
  }
}
