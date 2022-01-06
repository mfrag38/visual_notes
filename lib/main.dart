import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visual_notes/providers/notes_data.dart';
import 'package:visual_notes/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotesData(),
      child: const MaterialApp(
        title: 'Visual Notes',
        home: HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
