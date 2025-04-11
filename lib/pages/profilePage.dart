import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatelessWidget {
  final String email;

  const ProfilePage({Key? key, required this.email}) : super(key: key);

  Future<Map<String, dynamic>?> getUserData() async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(email).get();
    return userDoc.data() as Map<String, dynamic>?;
  }

  List<Map<String, int>> generateLastFiveDaysData(
      List<Map<String, dynamic>> scores) {
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    Map<String, int> scoresMap = {
      for (var entry in scores) entry.keys.first: entry.values.first
    };

    List<Map<String, int>> lastFiveDaysScores = [];
    for (int i = 0; i < 5; i++) {
      String date =
          formatter.format(DateTime.now().subtract(Duration(days: i)));
      lastFiveDaysScores.add({date: scoresMap[date] ?? 0});
    }
    return lastFiveDaysScores;
  }

  @override
  Widget build(BuildContext context) {
    double xX = MediaQuery.of(context).size.width;
    double yY = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder<Map<String, dynamic>?>(
                future: getUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(child: Text("No data available"));
                  }

                  var userData = snapshot.data!;
                  var name = userData['name'] ?? "No Name";
                  var img = userData['img'] ?? "";
                  var scorePronunciation = generateLastFiveDaysData(
                      List<Map<String, dynamic>>.from(
                          userData['scorePronunciation'] ?? []));
                  var scoreSpeaking = generateLastFiveDaysData(
                      List<Map<String, dynamic>>.from(
                          userData['scoreSpeaking'] ?? []));
                  var scoreVocabulary = generateLastFiveDaysData(
                      List<Map<String, dynamic>>.from(
                          userData['scoreVocabulary'] ?? []));

                  return Column(
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
                            padding:
                                EdgeInsets.symmetric(horizontal: xX * 0.05),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    icon: Icon(
                                      Icons.close_rounded,
                                      size: yY * 0.045,
                                    ),
                                    color: Colors.white),
                                Text(
                                  "LangApp",
                                  style: GoogleFonts.dancingScript(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: yY * 0.05,
                                  ),
                                ),
                                SizedBox(
                                  width: xX * 0.1,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: xX * 0.03, vertical: yY * 0.03),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 100,
                                backgroundImage:
                                    img != null ? NetworkImage(img) : null,
                              ),
                              SizedBox(height: yY * 0.03),
                              FittedBox(
                                child: Text(
                                  "Name: $name",
                                  style: GoogleFonts.robotoSerif(
                                    fontSize: yY * 0.03,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: yY * 0.03),
                              FittedBox(
                                child: Text(
                                  "Email: $email",
                                  style: GoogleFonts.robotoSerif(
                                    fontSize: yY * 0.03,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: yY * 0.01),
                              _buildScoreExpansionTile(context,
                                  "Pronunciation Scores", scorePronunciation),
                              _buildScoreExpansionTile(
                                  context, "Speaking Scores", scoreSpeaking),
                              _buildScoreExpansionTile(context,
                                  "Vocabulary Scores", scoreVocabulary),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreExpansionTile(
      BuildContext context, String title, List<Map<String, int>> scores) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.02),
      child: ExpansionTile(
        title: Text(
          title,
          style: GoogleFonts.robotoSerif(
            fontSize: MediaQuery.of(context).size.height * 0.03,
            fontWeight: FontWeight.bold,
          ),
        ),
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: FittedBox(
                child: DataTable(
                  columnSpacing: 30.0,
                  columns: const [
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Score')),
                  ],
                  rows: scores.map((entry) {
                    var date = entry.keys.first;
                    var score = entry[date];
                    return DataRow(cells: [
                      DataCell(Text(date)),
                      DataCell(Text(score.toString())),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
