import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:todo_app/auth/auth_view.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/services/firestore.dart';
import 'package:todo_app/views/add_note_view.dart';
import 'package:todo_app/widgets/stream_note.dart';
import 'package:todo_app/widgets/task_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final FirestoreDataSource _datasource = FirestoreDataSource();
  bool visibilityFlag = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            color: Colors.black,
            onPressed: () async {
              await _datasource.logOut();

              if (!context.mounted) return;
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) =>
                        AuthView()), // Replace with your actual login screen widget
              );
            },
          ),
        ],
      ),
      backgroundColor: backgroundColors,
      floatingActionButton: Visibility(
        visible: visibilityFlag,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddNoteView(),
            ));
          },
          backgroundColor: custom_green,
          child: Icon(Icons.add, size: 30),
        ),
      ),
      body: SafeArea(
        child: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            if (notification.direction == ScrollDirection.forward) {
              setState(() {
                visibilityFlag = true;
              });
            }
            if (notification.direction == ScrollDirection.reverse) {
              setState(() {
                visibilityFlag = false;
              });
            }
            return true;
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                StreamNote(false),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
