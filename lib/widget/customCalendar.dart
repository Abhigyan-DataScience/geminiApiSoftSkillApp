import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../widget/heatMapWidget.dart';

class CustomCalendar extends StatefulWidget {
  final String email;

  const CustomCalendar({super.key, required this.email});

  @override
  _CustomCalendarState createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  String? selectedOption;
  String difficulty = "Loading...";
  List<String> options = ["Vocabulary", "Speaking", "Pronunciation"];

  @override
  void initState() {
    super.initState();
    selectedOption = options[0];
    _fetchDifficulty(); // Move this after super.initState
  }

  Future<void> _fetchDifficulty() async {
    final firestore = FirebaseFirestore.instance;
    final now = DateTime.now();
    final dateFormat = DateFormat('dd-MM-yyyy');
    double sum = 0;

    String subject = selectedOption!;

    try {
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(widget.email).get();
      if (userDoc.exists) {
        var data = userDoc.data() as Map<String, dynamic>?;
        var scores = data?["score${subject.split(" ")[0]}"] as List<dynamic>?;

        if (scores != null) {
          for (int i = 0; i < 10; i++) {
            String date = dateFormat.format(now.subtract(Duration(days: i)));
            for (var entry in scores) {
              if (entry is Map<String, dynamic> && entry.containsKey(date)) {
                sum += entry[date];
              }
            }
          }
        }
      }

      double average = sum / 10;
      setState(() {
        difficulty = _calculateDifficulty(average);
      });
    } catch (e) {
      print('Error fetching scores: $e');
      setState(() {
        difficulty = "Error";
      });
    }
  }

  String _calculateDifficulty(double average) {
    if (average < 2.5) {
      return 'Easy';
    } else if (average < 5.0) {
      return 'Medium';
    } else if (average < 7.5) {
      return 'Hard';
    } else {
      return 'Expert';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            DropdownButton<String>(
              value: selectedOption,
              hint: const Text("Choose an option"),
              onChanged: (String? newValue) {
                setState(() {
                  selectedOption = newValue;
                  difficulty = "Loading...";
                });
                _fetchDifficulty();
              },
              items: options.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(width: 20),
            Text(
              difficulty,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Expanded(
          child: HeatMapWidget(
            userEmail: widget.email,
            topic: selectedOption!,
          ),
        ),
      ],
    );
  }
}
