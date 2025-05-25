import 'dart:math';
import 'package:flutter/material.dart';
import '../models/flashcard.dart';

class FlashcardWidget extends StatefulWidget {
  final Flashcard flashcard;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;

  const FlashcardWidget({
    Key? key,
    required this.flashcard,
    required this.onDelete,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<FlashcardWidget> createState() => _FlashcardWidgetState();
}

class _FlashcardWidgetState extends State<FlashcardWidget> {
  bool _showQuestion = true;

  void _flipCard() {
    setState(() {
      _showQuestion = !_showQuestion;
    });
  }

  Future<void> _editFlashcard() async {
    final questionController = TextEditingController(text: widget.flashcard.question);
    final answerController = TextEditingController(text: widget.flashcard.answer);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Flashcard'),
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
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Save')),
        ],
      ),
    );

    if (result == true) {
      widget.flashcard.question = questionController.text;
      widget.flashcard.answer = answerController.text;
      await widget.flashcard.save();
      widget.onUpdate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flipCard,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              final rotate = Tween(begin: pi, end: 0.0).animate(animation);
              return AnimatedBuilder(
                animation: rotate,
                child: child,
                builder: (context, child) {
                  final isUnder = (ValueKey(_showQuestion) != child!.key);
                  var tilt = (animation.value - 0.5).abs() - 0.5;
                  tilt *= isUnder ? -0.003 : 0.003;
                  final value = isUnder ? min(rotate.value, pi / 2) : rotate.value;
                  return Transform(
                    transform: Matrix4.rotationY(value)..setEntry(3, 0, tilt),
                    alignment: Alignment.center,
                    child: child,
                  );
                },
              );
            },
            child: _showQuestion
                ? _buildCardSide(widget.flashcard.question, key: const ValueKey(true))
                : _buildCardSide(widget.flashcard.answer, key: const ValueKey(false)),
          ),
        ),
      ),
    );
  }

  Widget _buildCardSide(String text, {required Key key}) {
    return Column(
      key: key,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                _editFlashcard();
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: widget.onDelete,
            ),
          ],
        ),
      ],
    );
  }
}
