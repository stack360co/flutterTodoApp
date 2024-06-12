import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/services/firestore.dart';
import 'package:todo_app/services/notification_service.dart';

class AddNoteView extends StatefulWidget {
  const AddNoteView({super.key});

  @override
  State<AddNoteView> createState() => _AddNoteViewState();
}

class _AddNoteViewState extends State<AddNoteView> {
  final title = TextEditingController();
  final subtitle = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  FocusNode _focusNode1 = FocusNode();
  FocusNode _focusNode2 = FocusNode();
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColors,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                imageContainer(),
                SizedBox(height: 20),
                titleWidget(),
                SizedBox(height: 20),
                subtitleWidget(),
                SizedBox(height: 20),
                dateWidget(context),
                SizedBox(height: 20),
                timeWidget(context),
                SizedBox(height: 20),
                buttonRow(),
                // testNotificationButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget testNotificationButton() {
    return ElevatedButton(
      onPressed: () {
        NotificationService()
            .showNotification(title: 'Sample title', body: 'It works!');
      },
      child: Text('Test Immediate Notification',
          style: TextStyle(color: Colors.white)),
    );
  }

  Widget buttonRow() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: custom_green,
                minimumSize: Size(170, 48),
              ),
              onPressed: () {
                if (selectedDate != null && selectedTime != null) {
                  final DateTime scheduledDate = DateTime(
                    selectedDate!.year,
                    selectedDate!.month,
                    selectedDate!.day,
                    selectedTime!.hour,
                    selectedTime!.minute,
                  );

                  FirestoreDataSource().addNote(
                    subtitle.text,
                    title.text,
                    _index,
                    selectedDate: selectedDate,
                    selectedTime: selectedTime,
                  );

                  NotificationService().scheduleNotification(
                    title.text,
                    subtitle.text,
                    scheduledDate,
                  );
                }
                Navigator.pop(context);
              },
              child: Text('Add Task', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: Size(170, 48),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel', style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ],
    );
  }

  SizedBox imageContainer() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        itemCount: 5,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _index = index;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 2,
                  color: _index == index ? custom_green : Colors.grey,
                ),
              ),
              width: 140,
              margin: EdgeInsets.all(8),
              child: Column(
                children: [
                  // ignore: unnecessary_brace_in_string_interps
                  Image.asset('images/${index}.png'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget titleWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: TextField(
          controller: title,
          focusNode: _focusNode1,
          style: TextStyle(fontSize: 18, color: Colors.black),
          decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              hintText: 'Add Title',
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xffc5c5c5), width: 2.0)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: custom_green, width: 2.0))),
        ),
      ),
    );
  }

  Widget subtitleWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: TextField(
          maxLines: 5,
          controller: subtitle,
          focusNode: _focusNode2,
          style: TextStyle(fontSize: 18, color: Colors.black),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            hintText: 'Add Description',
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color(0xffc5c5c5), width: 2.0)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: custom_green, width: 2.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget dateWidget(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      ElevatedButton(
        onPressed: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: selectedDate ?? DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          );
          if (pickedDate != null) {
            setState(() {
              selectedDate = pickedDate;
            });
          }
        },
        child: Text(
          selectedDate == null
              ? 'Select Date'
              : 'Selected Date: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}',
        ),
      ),
    ]);
  }

  Widget timeWidget(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: selectedTime ?? TimeOfDay.now(),
        );
        if (pickedTime != null) {
          setState(() {
            selectedTime = pickedTime;
          });
        }
      },
      child: Text(
        selectedTime == null
            ? 'Select Time'
            : 'Selected Time: ${selectedTime!.format(context)}',
      ),
    );
  }
}
