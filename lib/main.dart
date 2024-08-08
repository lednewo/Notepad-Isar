import 'package:flutter/material.dart';
import 'package:notepad_with_isar/models/note_database.dart';
import 'package:notepad_with_isar/pages/note_page.dart';
import 'package:notepad_with_isar/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  // iniciar database
  WidgetsFlutterBinding.ensureInitialized();
  await NoteDatabase.inicializar();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => NoteDatabase(),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
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
      debugShowCheckedModeBanner: false,
      home: const NotesPage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
