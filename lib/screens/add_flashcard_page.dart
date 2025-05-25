import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/flashcard.dart';

class AddFlashcardPage extends StatelessWidget {
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Flashcard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _questionController,
              decoration: InputDecoration(labelText: 'Question'),
            ),
            TextField(
              controller: _answerController,
              decoration: InputDecoration(labelText: 'Answer'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Save'),
              onPressed: () {
                final flashcard = Flashcard(
                  question: _questionController.text,
                  answer: _answerController.text,
                );
                Hive.box<Flashcard>('flashcards').add(flashcard);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
