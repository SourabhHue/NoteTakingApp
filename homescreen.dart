import 'package:flutter/material.dart';
import '../models/note.dart';
import '../widgets/note_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Note> _notes = [];
  List<Note> _filteredNotes = [];
  TextEditingController _searchController = TextEditingController();
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_searchNotes);
  }

  void _searchNotes() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredNotes = _notes.where((note) =>
          note.title.toLowerCase().contains(query) ||
          note.content.toLowerCase().contains(query)).toList();
    });
  }

  void _addNote() {
    if (titleController.text.isEmpty || contentController.text.isEmpty) return;

    setState(() {
      final newNote = Note(
        title: titleController.text,
        content: contentController.text,
      );
      _notes.add(newNote);
      // Update the filtered list according to current search input.
      _filteredNotes = _notes.where((note) {
        return note.title.toLowerCase().contains(_searchController.text.toLowerCase()) ||
            note.content.toLowerCase().contains(_searchController.text.toLowerCase());
      }).toList();
    });

    titleController.clear();
    contentController.clear();
    Navigator.of(context).pop(); // Closes the dialog after adding the note.
  }

  void _showAddNoteDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(labelText: 'Content'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: _addNote, child: const Text('Add')),
        ],
      ),
    );
  }

  void _deleteNote(int index) {
    final deletedNote = _filteredNotes[index];
    setState(() {
      _notes.remove(deletedNote);
      _searchNotes(); // Refresh the filtered list after deletion.
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search notes...',
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: _filteredNotes.isEmpty
          ? const Center(child: Text('No matching notes.'))
          : ListView.builder(
              itemCount: _filteredNotes.length,
              itemBuilder: (ctx, i) => NoteCard(
                note: _filteredNotes[i],
                onDelete: () => _deleteNote(i),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNoteDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}