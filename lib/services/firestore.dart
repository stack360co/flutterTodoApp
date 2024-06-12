import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/model/note_model.dart';
import 'package:uuid/uuid.dart';
import 'dart:developer' as devtools show log;

class FirestoreDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> createUser(String email) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .set({'id': _auth.currentUser!.uid, email: email});
      return true;
    } catch (e) {
      devtools.log(e.toString());
    }

    return false;
  }

  Future<bool> addNote(String subtitle, String title, int image,
      {DateTime? selectedDate, TimeOfDay? selectedTime}) async {
    try {
      var uuid = Uuid().v4();
      DateTime now = DateTime.now();

      // Default to current date and time if not provided
      selectedDate ??= now;
      selectedTime ??= TimeOfDay(hour: now.hour, minute: now.minute);

      // Combine selectedDate and selectedTime into a single DateTime object
      DateTime dateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('notes')
          .doc(uuid)
          .set({
        'id': uuid,
        'subtitle': subtitle,
        'title': title,
        'isDone': false,
        'image': image,
        'date':
            dateTime.toIso8601String(), // Store as ISO 8601 string if present
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      });
      return true;
    } catch (e) {
      devtools.log(e.toString());
    }

    return false;
  }

  List getNotes(AsyncSnapshot snapshot) {
    try {
      final notesList = snapshot.data.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        String time;
        
        DateTime date = DateTime.parse(data['date']);
        DateTime createdAt = DateTime.parse(data['created_at']);
        DateTime updatedAt = DateTime.parse(data['updated_at']);
        time = '${date.hour}:${date.minute}';

        return Note(
          data['id'],
          data['subtitle'],
          data['title'],
          time,
          data['image'],
          data['isDone'],
          date,
          createdAt,
          updatedAt,
        );
      }).toList();

      return notesList;
    } catch (e) {
      devtools.log(e.toString());
    }

    return [];
  }

  Stream<QuerySnapshot> stream(bool isDone) {
    return _firestore
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .collection('notes')
        .orderBy('updated_at', descending: true) // Order by updated_at
        .snapshots();
  }

  Future<bool> isDone(String uuid, bool isDone) async {
    try {
      DateTime now = DateTime.now();
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('notes')
          .doc(uuid)
          .update({'isDone': isDone, 'updated_at': now.toIso8601String()});
      return true;
    } catch (e) {
      devtools.log(e.toString());
    }

    return true;
  }

  Future<bool> updateNote(String uuid, int image, String title, String subtitle,
      {DateTime? selectedDate, TimeOfDay? selectedTime}) async {
    try {
      DateTime now = DateTime.now();
      DateTime dateTime = DateTime(
        selectedDate!.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime!.hour,
        selectedTime.minute,
      );

      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('notes')
          .doc(uuid)
          .update({
        'title': title,
        'subtitle': subtitle,
        'image': image,
        'date': dateTime.toIso8601String(),
        'updated_at': now.toIso8601String(),
      });
      return true;
    } catch (e) {
      devtools.log(e.toString());
    }

    return false;
  }

  Future<bool> deleteNote(String uuid) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('notes')
          .doc(uuid)
          .delete();
      return true;
    } catch (e) {
      devtools.log(e.toString());
    }

    return false;
  }

  Future<void> logOut() async {
    await _auth.signOut();
  }
}
