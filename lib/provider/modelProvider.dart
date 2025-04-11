import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ModelProvider extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

  Stream<List<double>> getAvg(String email) async* {
    final now = DateTime.now();
    try {
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(email).get();
      if (userDoc.exists) {
        var data = userDoc.data() as Map<String, dynamic>?;

        var vocabularyScores = data?["scoreVocabulary"] as List<dynamic>?;
        var speakingScores = data?["scoreSpeaking"] as List<dynamic>?;
        var pronunciationScores = data?["scorePronunciation"] as List<dynamic>?;

        double vocabularySum = 0;
        double speakingSum = 0;
        double pronunciationSum = 0;

        for (int i = 0; i < 10; i++) {
          String date = dateFormat.format(now.subtract(Duration(days: i)));

          if (vocabularyScores != null) {
            for (var entry in vocabularyScores) {
              if (entry is Map<String, dynamic> && entry.containsKey(date)) {
                vocabularySum += entry[date];
              }
            }
          }

          if (speakingScores != null) {
            for (var entry in speakingScores) {
              if (entry is Map<String, dynamic> && entry.containsKey(date)) {
                speakingSum += entry[date];
              }
            }
          }

          if (pronunciationScores != null) {
            for (var entry in pronunciationScores) {
              if (entry is Map<String, dynamic> && entry.containsKey(date)) {
                pronunciationSum += entry[date];
              }
            }
          }
        }
        yield [
          vocabularySum / 10,
          speakingSum / 10,
          pronunciationSum / 10,
        ];
      }
    } catch (e) {
      print('Error fetching averages: $e');
      yield [0, 0, 0];
    }
  }

  Stream<Map<String, dynamic>> allScore() async* {
    final now = DateTime.now();
    Map<String, dynamic> result = {};

    try {
      await for (var _ in Stream.periodic(const Duration(seconds: 5))) {
        QuerySnapshot usersSnapshot =
            await FirebaseFirestore.instance.collection('users').get();

        for (var userDoc in usersSnapshot.docs) {
          String email = userDoc.id;
          Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;

          List<dynamic>? vocabularyScores = data?["scoreVocabulary"];
          List<dynamic>? speakingScores = data?["scoreSpeaking"];
          List<dynamic>? pronunciationScores = data?["scorePronunciation"];

          Map<DateTime, List<int>> scoresMap = {};

          for (int i = 0; i < 10; i++) {
            String date = dateFormat.format(now.subtract(Duration(days: i)));
            DateTime currentDate = now.subtract(Duration(days: i));
            String formattedDate = dateFormat.format(currentDate);
            DateTime parsedDateTime = dateFormat.parse(formattedDate);

            int vocabularyScore = 0;
            int speakingScore = 0;
            int pronunciationScore = 0;

            if (vocabularyScores != null) {
              for (var entry in vocabularyScores) {
                if (entry is Map<String, dynamic> && entry.containsKey(date)) {
                  vocabularyScore = entry[date];
                  break;
                }
              }
            }

            if (speakingScores != null) {
              for (var entry in speakingScores) {
                if (entry is Map<String, dynamic> && entry.containsKey(date)) {
                  speakingScore = entry[date];
                  break;
                }
              }
            }

            if (pronunciationScores != null) {
              for (var entry in pronunciationScores) {
                if (entry is Map<String, dynamic> && entry.containsKey(date)) {
                  pronunciationScore = entry[date];
                  break;
                }
              }
            }

            scoresMap[parsedDateTime] = [
              vocabularyScore,
              speakingScore,
              pronunciationScore
            ];
          }

          result[email] = scoresMap;
        }
        yield result;
      }
    } catch (e) {
      print('Error fetching scores: $e');
      yield {};
    }
  }
}
