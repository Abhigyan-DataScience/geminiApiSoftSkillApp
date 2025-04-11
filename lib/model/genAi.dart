import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';

String apiKey = dotenv.env['API_KEY'] ?? "";

Future<List<dynamic>> genAi(String email, String subject) async {
  final firestore = FirebaseFirestore.instance;
  final now = DateTime.now();
  final dateFormat = DateFormat('dd-MM-yyyy');
  double sum = 0;

  try {
    DocumentSnapshot userDoc =
        await firestore.collection('users').doc(email).get();
    if (userDoc.exists) {
      var data = userDoc.data() as Map<String, dynamic>?;
      var scoresVocabulary =
          data?["score${subject.split(" ")[0]}"] as List<dynamic>?;

      if (scoresVocabulary != null) {
        for (int i = 0; i < 10; i++) {
          String date = dateFormat.format(now.subtract(Duration(days: i)));
          for (var entry in scoresVocabulary) {
            if (entry is Map<String, dynamic> && entry.containsKey(date)) {
              sum += entry[date];
            }
          }
        }
      }
    }
  } catch (e) {
    print('Error fetching scores: $e');
  }

  double average = sum / 10;
  String difficulty;

  if (average < 2.5) {
    difficulty = 'easy';
  } else if (average < 5.0) {
    difficulty = 'medium';
  } else if (average < 7.5) {
    difficulty = 'hard';
  } else {
    difficulty = 'expert';
  }

  try {
    final generationConfig = GenerationConfig(
      temperature: 1.0,
      topP: 0.95,
      topK: 64,
      maxOutputTokens: 8192,
      responseMimeType: 'text/plain',
    );

    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      generationConfig: generationConfig,
      apiKey: apiKey,
    );

    final content = [
      Content.text(
        """Generate 10 quiz questions about $subject with a difficulty of $difficulty.
        Return the output in JSON using the following structure:
        [
          {
            "question": "\$quizQuestion",
            "options": ["\$quizOption1", "\$quizOption2", "\$quizOption3", "\$quizOption4"],
            "answer": "\$quizAnswer"
          }
        ]

        quizQuestion should be of type String.
        quizOptions should be of type List<String>.
        quizAnswer should be of type String.
        """,
      ),
    ];

    final response = await model.generateContent(content);

    if (response.text != null && response.text!.isNotEmpty) {
      try {
        RegExp jsonRegExp = RegExp(r'\[\s*\{.*?\}\s*\]', dotAll: true);

        RegExpMatch? match = jsonRegExp.firstMatch(response.text!);

        if (match != null) {
          List<dynamic> quizQuestions = jsonDecode(match.group(0)!);
          return quizQuestions;
        } else {
          print('No JSON array found in the response.');
          return [];
        }
      } catch (e) {
        print('Failed to parse JSON: $e');
        return [];
      }
    } else {
      print('No response text received.');
      return [];
    }
  } catch (e) {
    print('Error generating quiz questions: $e');
    return [];
  }
}

Future<List<dynamic>> contentgenAi(String topic) async {
  try {
    final generationConfig = GenerationConfig(
      temperature: 1.0,
      topP: 0.95,
      topK: 64,
      maxOutputTokens: 8192,
      responseMimeType: 'text/plain',
    );

    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      generationConfig: generationConfig,
      apiKey: apiKey,
    );

    final content = [
      Content.text(
        """Generate a detailed lesson about $topic with the following sections:
        1. Introduction to $topic
        2. Importance of $topic
        3. Techniques for Improving $topic
        4. Common Challenges in $topic and Solutions
        5. Practicing $topic

        Return the output in JSON using the following structure:
        {
          "lesson": [
            {
              "section": "Introduction to $topic",
              "content": "\$detailedContent1",
              "video": "\$youtubeVideoLink1"
            },
            {
              "section": "Importance of $topic",
              "content": "\$detailedContent2",
              "video": "\$youtubeVideoLink2"
            },
            {
              "section": "Techniques for Improving $topic",
              "content": "\$detailedContent3",s
              "video": "\$youtubeVideoLink3"
            },
            {
              "section": "Common Challenges in $topic and Solutions",
              "content": "\$detailedContent4",
              "video": "\$youtubeVideoLink4"
            },
            {
              "section": "Practicing $topic",
              "content": "\$detailedContent5",
              "video": "\$youtubeVideoLink5"
            }
          ]
        }

        Each section should contain detailed content about the section topic and a relevant YouTube video link.
        """,
      ),
    ];

    final response = await model.generateContent(content);

    if (response.text != null && response.text!.isNotEmpty) {
      try {
        RegExp jsonRegExp = RegExp(r'\[\s*\{.*?\}\s*\]', dotAll: true);

        RegExpMatch? match = jsonRegExp.firstMatch(response.text!);

        if (match != null) {
          List<dynamic> quizQuestions = jsonDecode(match.group(0)!);
          return quizQuestions;
        } else {
          print('No JSON array found in the response.');
          return [];
        }
      } catch (e) {
        print('Failed to parse JSON: $e');
        return [];
      }
    } else {
      print('No response text received.');
      return [];
    }
  } catch (e) {
    print('Error generating quiz questions: $e');
    return [];
  }
}
