import 'package:cubit_state_manager/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubits/note_cubit.dart';
import 'pages/notes_page.dart';

void main() {
  runApp(
      BlocProvider(
        create: (_) => NoteCubit(ApiService()),
        child: const MyApp(),
      ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App (Provider + Dio)',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NotesPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}