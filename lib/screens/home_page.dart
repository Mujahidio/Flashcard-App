import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/flashcard.dart';
import '../widgets/flashcard_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Box<Flashcard> flashcardsBox;

  @override
  void initState() {
    super.initState();
    flashcardsBox = Hive.box<Flashcard>('flashcards');
  }

  void _addFlashcard() async {
    final questionController = TextEditingController();
    final answerController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Flashcard'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: questionController,
              decoration: const InputDecoration(labelText: 'Question'),
            ),
            TextField(
              controller: answerController,
              decoration: const InputDecoration(labelText: 'Answer'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Add')),
        ],
      ),
    );

    if (result == true) {
      final newFlashcard = Flashcard(
        question: questionController.text,
        answer: answerController.text,
      );
      await flashcardsBox.add(newFlashcard);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final flashcards = flashcardsBox.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcard App'),
      ),
      body: ListView.builder(
        itemCount: flashcards.length,
        itemBuilder: (context, index) {
          final flashcard = flashcards[index];
          return FlashcardWidget(
            flashcard: flashcard,
            onDelete: () async {
              await flashcard.delete();
              setState(() {});
            },
            onUpdate: () {
              setState(() {});
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addFlashcard,
        child: const Icon(Icons.add),
      ),
    );
  }
}
