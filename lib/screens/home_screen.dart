import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visual_notes/providers/notes_data.dart';
import 'package:visual_notes/widgets/add_note_sheet.dart';
import 'package:visual_notes/widgets/notes_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void didChangeDependencies() {
    Future.delayed(
        const Duration(milliseconds: 100), () => Provider.of<NotesData>(context, listen: false).loadNotes());
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.black,
      ),
      body: const NotesList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () => showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: const AddNoteSheet(),
                    ),
                  ],
                )),
        child: const Icon(Icons.add),
      ),
    );
  }
}
