import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thedios/providers/note_provider.dart';
import 'pages/notes_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NoteProvider()),
      ],
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