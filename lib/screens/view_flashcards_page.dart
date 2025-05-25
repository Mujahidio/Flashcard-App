import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/flashcard.dart';

class ViewFlashcardsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final flashcardBox = Hive.box<Flashcard>('flashcards');

    return Scaffold(
      appBar: AppBar(title: Text('Your Flashcards')),
      body: ValueListenableBuilder(
        valueListenable: flashcardBox.listenable(),
        builder: (context, Box<Flashcard> box, _) {
          if (box.values.isEmpty) {
            return Center(child: Text('No flashcards yet.'));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final flashcard = box.getAt(index)!;
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text(flashcard.question),
                  subtitle: Text(flashcard.answer),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
