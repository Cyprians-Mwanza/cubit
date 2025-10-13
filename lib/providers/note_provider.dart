import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/api_service.dart';

class NoteProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  Note? _note;
  bool _isLoading = false;
  String? _error;

  Note? get note => _note;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchNoteById(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _note = await _apiService.fetchNoteById(id);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}