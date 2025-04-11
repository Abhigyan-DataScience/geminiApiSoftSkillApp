import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:soft_app/pages/profilePage.dart';
import '../pages/lessonPage.dart';
import '../pages/loginPage.dart';
import '../pages/quizPage.dart';
import '../provider/mainProvider.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool _isExpanded = false;
  bool _isLessonExpanded = false;

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _toggleLessonExpand() {
    setState(() {
      _isLessonExpanded = !_isLessonExpanded;
    });
  }

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

  void _navigateToLessonPage(String lesson) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LessonPage(topic: lesson),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mainProvider = context.read<MainProvider>();
    final String email = mainProvider.user?.email ?? "unknown@example.com";
    final String displayName = mainProvider.user?.displayName ?? "Employee";
    final String? photoURL = mainProvider.user?.photoURL;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(displayName),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(
              radius: 40,
              backgroundImage: photoURL != null ? NetworkImage(photoURL) : null,
            ),
          ),
          ListTile(
            leading: !_isExpanded
                ? const Icon(Icons.arrow_forward_ios_rounded)
                : const Icon(Icons.arrow_downward_rounded),
            title: const Text('Tests'),
            onTap: _toggleExpand,
          ),
          if (_isExpanded) ...[
            ListTile(
              title: const Text('Vocabulary Evaluation'),
              trailing: StreamBuilder<int>(
                stream: getTopicScoreForDate(email, "Vocabulary", currentDate),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text("Error");
                  } else {
                    return Text("${snapshot.data?.toString() ?? "0"}/10");
                  }
                },
              ),
              onTap: () => _handleNavigation("Vocabulary Lessons"),
            ),
            const Divider(),
            ListTile(
              title: const Text('Speaking Assessment'),
              trailing: StreamBuilder<int>(
                stream: getTopicScoreForDate(email, "Speaking", currentDate),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text("Error");
                  } else {
                    return Text("${snapshot.data?.toString() ?? "0"}/10");
                  }
                },
              ),
              onTap: () => _handleNavigation("Speaking Skills"),
            ),
            const Divider(),
            ListTile(
              title: const Text('Pronunciation Assessment'),
              trailing: StreamBuilder<int>(
                stream:
                    getTopicScoreForDate(email, "Pronunciation", currentDate),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text("Error");
                  } else {
                    return Text("${snapshot.data?.toString() ?? "0"}/10");
                  }
                },
              ),
              onTap: () => _handleNavigation("Pronunciation Lessons"),
            ),
          ],
          const Divider(),
          ListTile(
            leading: !_isLessonExpanded
                ? const Icon(Icons.arrow_forward_ios_rounded)
                : const Icon(Icons.arrow_downward_rounded),
            title: const Text('Lessons'),
            onTap: _toggleLessonExpand,
          ),
          if (_isLessonExpanded) ...[
            ListTile(
              title: const Text('Vocabulary Lessons'),
              onTap: () => _navigateToLessonPage("Vocabulary Lessons"),
            ),
            const Divider(),
            ListTile(
              title: const Text('Speaking Lessons'),
              onTap: () => _navigateToLessonPage("Speaking Lessons"),
            ),
            const Divider(),
            ListTile(
              title: const Text('Pronunciation Lessons'),
              onTap: () => _navigateToLessonPage("Pronunciation Lessons"),
            ),
          ],
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Employee info'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProfilePage(
                    email: email,
                  ),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Sign Out'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const Loginpage(),
                ),
              );
              mainProvider.signOut();
            },
          ),
        ],
      ),
    );
  }
}
