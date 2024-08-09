import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notepad_with_isar/components/drawer.dart';
import 'package:notepad_with_isar/components/note_title.dart';
import 'package:notepad_with_isar/models/note.dart';
import 'package:notepad_with_isar/models/note_database.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotePageState();
}

class _NotePageState extends State<NotesPage> {
  //text controller
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  // read notes
  void readNotes() {
    context.read<NoteDatabase>().fetchNotes();
  }

  //update note
  void updateNote(Note note) {
    textController.text = note.text;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Atualizar Nota'),
        content: TextField(
          controller: textController,
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              // update note db
              context
                  .read<NoteDatabase>()
                  .updateNote(note.id, textController.text);

              //clear controller
              textController.clear();

              //pop dialog
              Navigator.pop(context);
            },
            child: const Text('Atualizar'),
          ),
        ],
      ),
    );
  }

  //delete note
  void deleteNote(int id) {
    context.read<NoteDatabase>().deleteNote(id);
  }

  //snackbar
  void mostrarSnackBar() {
    final snackBar = SnackBar(
      content: const Text(
        'Digite alguma nota!',
        style: TextStyle(fontSize: 16),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 100,
      action: SnackBarAction(
          textColor: Theme.of(context).colorScheme.primary,
          label: 'Ok',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    //note database
    final noteDataBase = context.watch<NoteDatabase>();

    //current notes
    List<Note> currentNotes = noteDataBase.currentNotes;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: createNote,
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   child: const Icon(Icons.add),
      // ),
      drawer: const MyDrawer(),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //heading
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Text(
                  "Embarques",
                  style: GoogleFonts.dmSerifText(
                      fontSize: 48,
                      color: Theme.of(context).colorScheme.inversePrimary),
                ),
              ),
              //notas
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: ListView.builder(
                    itemCount: currentNotes.length,
                    itemBuilder: (context, index) {
                      //get individual note
                      final note = currentNotes[index];

                      //list title UI
                      return NoteTitle(
                        text: note.text,
                        onEditPressed: () => updateNote(note),
                        onDeletePressed: () => deleteNote(note.id),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            right: 0,
            left: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      cursorColor: Theme.of(context).colorScheme.inversePrimary,
                      controller: textController,
                      decoration: InputDecoration(
                        hintText: 'Digite uma nota',
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (textController.text.isEmpty) {
                        return mostrarSnackBar();
                      } else {
                        //add db
                        context
                            .read<NoteDatabase>()
                            .addNote(textController.text);

                        //clear controller
                        textController.clear();
                      }
                    },
                    child: CircleAvatar(
                      backgroundColor:
                          Theme.of(context).colorScheme.inversePrimary,
                      child: Center(
                        child: Icon(
                          Icons.add,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
