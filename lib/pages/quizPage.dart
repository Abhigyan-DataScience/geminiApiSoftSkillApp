import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../pages/completionPage.dart';
import 'package:intl/intl.dart';
import './../model/genAi.dart';
import 'package:provider/provider.dart';
import './../provider/mainProvider.dart';

class QuizPage extends StatefulWidget {
  final String topic, email;
  const QuizPage({super.key, required this.email, required this.topic});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<dynamic> quizQuestions = [];
  Map<int, String?> selectedAnswers = {};
  late PageController _pageController;
  Timer? _timer;
  int _timeRemaining = 30;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    loadQuiz();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> loadQuiz() async {
    List<dynamic> questions = await genAi(widget.email, widget.topic);
    setState(() {
      quizQuestions = questions;
      startTimer();
    });
  }

  void startTimer() {
    _timeRemaining = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeRemaining > 0) {
          _timeRemaining--;
        } else {
          _timer?.cancel();
          if (_pageController.page?.toInt() == quizQuestions.length - 1) {
            submitQuiz();
          } else {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
            startTimer();
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double xX = MediaQuery.of(context).size.width;
    double yY = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(219, 219, 219, 1),
        body: quizQuestions.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Container(
                    width: xX,
                    height: yY * 0.15,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(40),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [
                          Colors.redAccent,
                          Colors.amber,
                        ],
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: xX * 0.05),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(
                                Icons.arrow_back_rounded,
                                size: yY * 0.04,
                              ),
                              color: Colors.white,
                            ),
                            Text(
                              widget.topic.split(" ")[0],
                              style: GoogleFonts.dancingScript(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: yY * 0.05,
                              ),
                            ),
                            CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  context.read<MainProvider>().user?.photoURL !=
                                          null
                                      ? NetworkImage(context
                                          .read<MainProvider>()
                                          .user!
                                          .photoURL!)
                                      : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: yY * 0.02),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: quizQuestions.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var question = quizQuestions[index];
                        var options = question['options'];

                        return Padding(
                          padding: EdgeInsets.all(xX * 0.03),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${index + 1}. ${question['question']}',
                                style: TextStyle(
                                  fontSize: yY * 0.03,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                height: 5,
                                width: xX * (_timeRemaining / 30),
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: List.generate(
                                      options.length,
                                      (optionIndex) {
                                        String option = options[optionIndex];
                                        return Card(
                                          elevation: 5,
                                          color:
                                              selectedAnswers[index] == option
                                                  ? Colors.blue
                                                  : Colors.white,
                                          child: ListTile(
                                            title: Text(
                                              option,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: yY * 0.02,
                                              ),
                                            ),
                                            onTap: () {
                                              setState(() {
                                                selectedAnswers[index] = option;
                                              });
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        setState(() {
                                          selectedAnswers[index] = null;
                                        });
                                      },
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15),
                                        side: const BorderSide(
                                            color: Colors.black),
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(30),
                                            bottomLeft: Radius.circular(30),
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        'Clear',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: xX * 0.02),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (index < quizQuestions.length - 1) {
                                          _pageController.nextPage(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.easeInOut,
                                          );
                                          startTimer();
                                        } else {
                                          submitQuiz();
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.black,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15),
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(30),
                                            bottomRight: Radius.circular(30),
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        index < quizQuestions.length - 1
                                            ? 'Next'
                                            : 'Submit',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> submitQuiz() async {
    _timer?.cancel();
    int correctAnswers = 0;

    for (int i = 0; i < quizQuestions.length; i++) {
      if (quizQuestions[i]['answer'] == selectedAnswers[i]) {
        correctAnswers++;
      }
    }
    if (correctAnswers > 0) {
      String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

      final user = context.read<MainProvider>().user;
      String email = user?.email ?? 'unknown@example.com';

      final firestore = FirebaseFirestore.instance;
      DocumentReference userDoc = firestore.collection('users').doc(email);

      await userDoc.update({
        'score${widget.topic.split(" ")[0]}': FieldValue.arrayUnion([
          {currentDate: correctAnswers}
        ]),
      });
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => CompletionPage(score: correctAnswers),
      ),
    );
  }
}
