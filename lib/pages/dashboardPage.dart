import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:soft_app/widget/customCharts.dart';
import '../pages/LessonPage.dart';
import '../pages/quizPage.dart';
import '../provider/mainProvider.dart';
import '../widget/customCalendar.dart';
import '../widget/customDrawer.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

  Stream<int> getTopicScoreForDate(String email, String topic, String date) {
    final firestore = FirebaseFirestore.instance;

    return firestore.collection('users').doc(email).snapshots().map((snapshot) {
      if (snapshot.exists) {
        List<dynamic> scores = snapshot['score$topic'];

        for (var entry in scores) {
          if (entry.containsKey(date)) {
            return entry[date];
          }
        }
      }
      return 0;
    });
  }

  void _handleNavigation(String topic) async {
    final String email =
        context.read<MainProvider>().user?.email ?? "unknown@example.com";

    int score =
        await getTopicScoreForDate(email, topic.split(" ")[0], currentDate)
            .first;

    if (score > 0) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Center(
            child: Icon(
              Icons.done,
              size: 50,
            ),
          ),
          content: const Text('1 attempt done for the day'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => QuizPage(
            email: context.read<MainProvider>().user!.email ?? "",
            topic: topic,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double xX = MediaQuery.of(context).size.width;
    double yY = MediaQuery.of(context).size.height;
    final String email =
        context.read<MainProvider>().user?.email ?? "unknown@example.com";

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color.fromRGBO(219, 219, 219, 1),
        drawer: const CustomDrawer(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
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
                              _scaffoldKey.currentState!.openDrawer();
                            },
                            icon: Icon(
                              Icons.menu_rounded,
                              size: yY * 0.05,
                            ),
                            color: Colors.white,
                          ),
                          Text(
                            "LangApp",
                            style: GoogleFonts.dancingScript(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: yY * 0.05),
                          ),
                          CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                context.read<MainProvider>().user?.photoURL !=
                                        null
                                    ? NetworkImage(
                                        context
                                            .read<MainProvider>()
                                            .user!
                                            .photoURL!,
                                      )
                                    : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: yY * 0.05,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: xX * 0.03),
                child: Column(
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "Welcome! ${context.read<MainProvider>().user!.displayName!.split(" ")[0]}"
                            .split(' ')
                            .map(
                              (word) =>
                                  word[0].toUpperCase() + word.substring(1),
                            )
                            .join(' '),
                        style: GoogleFonts.comfortaa(
                          fontWeight: FontWeight.bold,
                          fontSize: yY * 0.05,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: yY * 0.03,
                      ),
                      child: Card(
                        elevation: 5,
                        child: SizedBox(
                          width: xX,
                          height: yY * 0.3,
                          child: CustomCharts(
                            email: email,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: yY * 0.05),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              "Learn And Understand",
                              style: GoogleFonts.comfortaa(fontSize: yY * 0.05),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Wrap(
                      runSpacing: yY * 0.02,
                      spacing: xX * 0.1,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const LessonPage(
                                  topic: 'Vocabulary Lessons',
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            side:
                                const BorderSide(color: Colors.black, width: 2),
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: xX * 0.02,
                              vertical: yY * 0.02,
                            ),
                            child: const Text('Vocabulary Lessons'),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const LessonPage(
                                  topic: 'Speaking Lessons',
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            side:
                                const BorderSide(color: Colors.black, width: 2),
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: xX * 0.02,
                              vertical: yY * 0.02,
                            ),
                            child: const Text('Speaking Lessons'),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const LessonPage(
                                  topic: 'Pronunciation Lessons',
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            side:
                                const BorderSide(color: Colors.black, width: 2),
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: xX * 0.02,
                              vertical: yY * 0.02,
                            ),
                            child: const Text('Pronunciation Lessons'),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: yY * 0.05),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              "Test And Assessments",
                              style: GoogleFonts.comfortaa(fontSize: yY * 0.05),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Wrap(
                      runSpacing: yY * 0.02,
                      spacing: xX * 0.1,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _handleNavigation("Vocabulary");
                          },
                          style: ElevatedButton.styleFrom(
                            side: const BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: xX * 0.02,
                              vertical: yY * 0.02,
                            ),
                            child: const Text('Vocabulary Evaluation'),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _handleNavigation("Speaking");
                          },
                          style: ElevatedButton.styleFrom(
                            side:
                                const BorderSide(color: Colors.black, width: 2),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: xX * 0.02,
                              vertical: yY * 0.02,
                            ),
                            child: const Text('Speaking Assessment'),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _handleNavigation("Pronunciation");
                          },
                          style: ElevatedButton.styleFrom(
                            side:
                                const BorderSide(color: Colors.black, width: 2),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: xX * 0.02,
                              vertical: yY * 0.02,
                            ),
                            child: const Text('Pronunciation Assessment'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: yY * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        "Active Days",
                        style: GoogleFonts.comfortaa(fontSize: yY * 0.05),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: yY * 0.01),
                    child: SizedBox(
                      width: xX * 0.95,
                      height: yY * 0.6,
                      child: CustomCalendar(
                        email: email,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
