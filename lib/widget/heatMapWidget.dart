import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:intl/intl.dart';

class HeatMapWidget extends StatefulWidget {
  final String userEmail, topic;

  const HeatMapWidget(
      {super.key, required this.userEmail, required this.topic});

  @override
  _HeatMapWidgetState createState() => _HeatMapWidgetState();
}

class _HeatMapWidgetState extends State<HeatMapWidget> {
  Map<DateTime, int> heatmapData = {};
  bool isLoading = true;
  bool isDataEmpty = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void didUpdateWidget(HeatMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.topic != widget.topic) {
      loadData();
    }
  }

  Future<Map<DateTime, int>> fetchUserData(String email) async {
    Map<DateTime, int> heatmapData = {};
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(email).get();

    if (userDoc.exists) {
      List<dynamic> topics = userDoc['score${widget.topic}'];

      DateTime currentDate = DateTime.now();
      for (int i = 0; i < 30; i++) {
        DateTime date = currentDate.subtract(Duration(days: i));
        String formattedDate = DateFormat('dd-MM-yyyy').format(date);

        int valueForDate = 0;
        for (var topic in topics) {
          if (topic.containsKey(formattedDate)) {
            valueForDate = topic[formattedDate];
            break;
          }
        }
        DateTime op = DateTime(date.year, date.month, date.day);
        heatmapData[op] = valueForDate;
      }
    }
    bool allZeros = heatmapData.values.every((value) => value == 0);
    if (allZeros) {
      setState(() {
        isDataEmpty = true;
      });
    } else {
      setState(() {
        isDataEmpty = false;
      });
    }
    return heatmapData;
  }

  void loadData() async {
    setState(() {
      isLoading = true;
    });
    Map<DateTime, int> data = await fetchUserData(widget.userEmail);
    setState(() {
      heatmapData = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double yY = MediaQuery.of(context).size.height;

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : isDataEmpty
            ? const Center(
                child: Text(
                  "No activity in last 30 days",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              )
            : SizedBox(
                height: yY * 0.6,
                child: HeatMap(
                  showText: true,
                  defaultColor: Colors.grey[350],
                  size: yY * 0.055,
                  startDate: DateTime.now().subtract(const Duration(days: 29)),
                  endDate: DateTime.now(),
                  datasets: heatmapData,
                  colorMode: ColorMode.opacity,
                  colorsets: {
                    1: Colors.green.withOpacity(0.1),
                    2: Colors.green.withOpacity(0.2),
                    3: Colors.green.withOpacity(0.3),
                    4: Colors.green.withOpacity(0.4),
                    5: Colors.green.withOpacity(0.5),
                    6: Colors.green.withOpacity(0.6),
                    7: Colors.green.withOpacity(0.7),
                    8: Colors.green.withOpacity(0.8),
                    9: Colors.green.withOpacity(0.9),
                    10: Colors.green,
                  },
                  onClick: (date) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            "Date: ${DateFormat('dd-MM-yyyy').format(date)}, Value: ${heatmapData[date] ?? 0}"),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              );
  }
}
