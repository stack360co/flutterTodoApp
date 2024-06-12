import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/firebase_options.dart';
import 'package:todo_app/auth/main_view.dart';
import 'package:todo_app/services/notification_service.dart';
import 'package:todo_app/views/add_note_view.dart';
import 'package:todo_app/views/home_view.dart';
import 'package:todo_app/widgets/task_widget.dart';
import 'timezone_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  TimeZoneHelper.initialize();
  NotificationService().initNotification();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO List',
      debugShowCheckedModeBanner: false,
      home: MainView(),
    );
  }
}
