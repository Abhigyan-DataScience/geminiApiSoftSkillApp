import 'package:circle_chart/circle_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/modelProvider.dart';

class CustomCharts extends StatefulWidget {
  final email;
  const CustomCharts({super.key, required this.email});

  @override
  State<CustomCharts> createState() => _CustomChartsState();
}

class _CustomChartsState extends State<CustomCharts> {
  @override
  Widget build(BuildContext context) {
    double xX = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      body: StreamBuilder<List<double>>(
        stream: context.read<ModelProvider>().getAvg(widget.email),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Text('Error loading data');
          }

          List<double> averages = snapshot.data!;

          double vocabularyAverage =
              averages[0] == 0 ? 0.01 : (averages[0] == 10 ? 9.9 : averages[0]);

          double speakingAverage =
              averages[1] == 0 ? 0.01 : (averages[1] == 10 ? 9.9 : averages[1]);

          double pronunciationAverage =
              averages[2] == 0 ? 0.01 : (averages[2] == 10 ? 9.9 : averages[2]);

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: xX * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleChart(
                  progressNumber: vocabularyAverage,
                  maxNumber: 10,
                  width: xX * 0.5,
                  progressColor: Colors.red,
                  children: const [
                    Text(
                      'Vocabulary',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                CircleChart(
                  progressNumber: speakingAverage,
                  maxNumber: 10,
                  width: xX * 0.5,
                  progressColor: Colors.blue,
                  children: const [
                    Text(
                      'Speaking',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                CircleChart(
                  progressNumber: pronunciationAverage,
                  maxNumber: 10,
                  width: xX * 0.5,
                  progressColor: Colors.green,
                  children: const [
                    Text(
                      'Pronunciation',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    ));
  }
}
