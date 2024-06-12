import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/services/firestore.dart';
import 'package:todo_app/model/note_model.dart';
import 'package:todo_app/views/edit_note_view.dart';

class TaskWidget extends StatefulWidget {
  final Note _note;
  TaskWidget(this._note, {super.key});

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {
    bool isDone = widget._note.isDone;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: IntrinsicHeight(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                imageContainer(),
                SizedBox(width: 25),
                // Title and Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget._note.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Checkbox(
                            activeColor: custom_green,
                            value: isDone,
                            onChanged: (value) {
                              setState(() {
                                isDone = !isDone;
                              });
                              FirestoreDataSource()
                                  .isDone(widget._note.id, isDone);
                            },
                          ),
                        ],
                      ),
                      
                      Flexible(
                        child: Text(
                          widget._note.subtitle,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade400,
                          ),
                          overflow: TextOverflow.visible,
                          maxLines: 3, // Limit the number of lines if necessary
                        ),
                      ),
                      SizedBox(height: 5),
                      isDone == false
                          ? editTime()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(height: 20),
                                      Text('Completed')
                                    ],
                                  )
                                ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget editTime() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 28,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('images/icon_time.png'),
                    SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        formatDateTime(widget
                            ._note.date), // Format the updatedAt timestamp
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }

// Helper method to format DateTime
  String formatDateTime(DateTime dateTime) {
    final DateFormat timeFormatter =
        DateFormat('hh:mm a'); // Format to show only time
    return timeFormatter.format(dateTime);
  }

  Widget imageContainer() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => EditNoteView(widget._note),
        ));
      },
      child: Container(
        height: 130,
        width: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage('images/${widget._note.image}.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
