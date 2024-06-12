import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/services/firestore.dart';
import 'package:todo_app/widgets/task_widget.dart';

class StreamNote extends StatelessWidget {
  final bool isCompleted;
  StreamNote(this.isCompleted, {super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirestoreDataSource().stream(isCompleted),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final notesList = FirestoreDataSource().getNotes(snapshot);
        return ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(), // Allow scrolling
          itemBuilder: (context, index) {
            final note = notesList[index];
            return Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) {
                FirestoreDataSource().deleteNote(note.id);
              },
              child: TaskWidget(note),
            );
          },
          itemCount: notesList.length,
        );
      },
    );
  }
}
