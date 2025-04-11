import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:soft_app/pages/profilePage.dart';
import 'package:soft_app/provider/modelProvider.dart';

class ScorePage extends StatefulWidget {
  const ScorePage({super.key});

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  String filterType = 'All Scores';

  @override
  Widget build(BuildContext context) {
    double yY = MediaQuery.of(context).size.height;
    double xX = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                            Icons.arrow_back,
                            size: yY * 0.045,
                          ),
                          color: Colors.white,
                        ),
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
                padding: EdgeInsets.symmetric(horizontal: xX * 0.03),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: FittedBox(
                        child: Text(
                          "Scoreboard",
                          style: GoogleFonts.robotoSerif(
                            fontSize: yY * 0.1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "Top Scorers",
                      style: GoogleFonts.roboto(fontSize: yY * 0.05),
                    ),
                    StreamBuilder<Map<String, dynamic>>(
                      stream: context.watch<ModelProvider>().allScore(),
                      builder: (BuildContext context,
                          AsyncSnapshot<Map<String, dynamic>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text("Error: ${snapshot.error}"));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(child: Text("No data available"));
                        } else {
                          final scoresByCategory = {
                            'Vocabulary': <String, int>{},
                            'Speaking': <String, int>{},
                            'Pronunciation': <String, int>{},
                          };

                          snapshot.data!.forEach((email, dates) {
                            if (dates is Map<DateTime, List<int>>) {
                              int vocabularyScore = 0,
                                  speakingScore = 0,
                                  pronunciationScore = 0;
                              try {
                                vocabularyScore = dates.values
                                    .map((scores) =>
                                        scores.isNotEmpty ? scores[0] : 0)
                                    .reduce((sum, score) => sum + score);
                                speakingScore = dates.values
                                    .map((scores) =>
                                        scores.length > 1 ? scores[1] : 0)
                                    .reduce((sum, score) => sum + score);
                                pronunciationScore = dates.values
                                    .map((scores) =>
                                        scores.length > 2 ? scores[2] : 0)
                                    .reduce((sum, score) => sum + score);
                              } catch (e) {}

                              scoresByCategory['Vocabulary']![email] =
                                  vocabularyScore;
                              scoresByCategory['Speaking']![email] =
                                  speakingScore;
                              scoresByCategory['Pronunciation']![email] =
                                  pronunciationScore;
                            }
                          });

                          final topScores =
                              scoresByCategory.map((category, scores) {
                            final sortedScores = scores.entries.toList()
                              ..sort((a, b) => b.value.compareTo(a.value));
                            return MapEntry(
                                category,
                                sortedScores.isNotEmpty
                                    ? sortedScores.first
                                    : null);
                          });

                          return Wrap(
                            crossAxisAlignment: WrapCrossAlignment.start,
                            spacing: xX * 0.005,
                            runSpacing: yY * 0.01,
                            children: [
                              for (var category in [
                                'Vocabulary',
                                'Speaking',
                                'Pronunciation'
                              ])
                                topScores[category] != null
                                    ? Card(
                                        child: Container(
                                          width: xX * 1.0,
                                          height: yY * 0.2,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: category == 'Vocabulary'
                                                  ? [
                                                      const Color(0xFFe66465),
                                                      const Color(0xFF9198e5)
                                                    ]
                                                  : category == 'Speaking'
                                                      ? [
                                                          const Color(
                                                              0xFFFF5F6D),
                                                          const Color(
                                                              0xFFFFC371)
                                                        ]
                                                      : [
                                                          const Color(
                                                              0xFF36D1DC),
                                                          const Color(
                                                              0xFF5B86E5)
                                                        ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Center(
                                            child: ListTile(
                                              title: Text(
                                                (category[0].toUpperCase() +
                                                    category.substring(1)),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: yY * 0.05,
                                                ),
                                              ),
                                              subtitle: Text(
                                                topScores[category]!.key,
                                                style: TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: yY * 0.03),
                                              ),
                                              trailing: FittedBox(
                                                child: Text(
                                                  "${topScores[category]!.value}",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: yY * 0.1,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : const Text(
                                        "missing data for unforseen circumstances",
                                      ),
                            ],
                          );
                        }
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Filter",
                          style: GoogleFonts.robotoSerif(fontSize: yY * 0.05),
                        ),
                        FloatingActionButton(
                          backgroundColor: Colors.white70,
                          onPressed: _showFilterBottomSheet,
                          child: const Icon(Icons.filter_alt_outlined),
                        ),
                      ],
                    ),
                    StreamBuilder<Map<String, dynamic>>(
                      stream: context.watch<ModelProvider>().allScore(),
                      builder: (BuildContext context,
                          AsyncSnapshot<Map<String, dynamic>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text("Error: ${snapshot.error}"));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(child: Text("No data available"));
                        } else {
                          final totalScores =
                              snapshot.data!.map((email, dates) {
                            if (dates is Map<DateTime, List<int>>) {
                              int totalScore = 0;
                              try {
                                if (filterType == 'Vocabulary') {
                                  totalScore = dates.values
                                      .map((scores) =>
                                          scores.isNotEmpty ? scores[0] : 0)
                                      .reduce((sum, score) => sum + score);
                                } else if (filterType == 'Speaking') {
                                  totalScore = dates.values
                                      .map((scores) =>
                                          scores.length > 1 ? scores[1] : 0)
                                      .reduce((sum, score) => sum + score);
                                } else if (filterType == 'Pronunciation') {
                                  totalScore = dates.values
                                      .map((scores) =>
                                          scores.length > 2 ? scores[2] : 0)
                                      .reduce((sum, score) => sum + score);
                                } else {
                                  totalScore = dates.values
                                      .expand((scores) => scores)
                                      .reduce((sum, score) => sum + score);
                                }
                              } catch (e) {
                                totalScore = 0;
                              }
                              return MapEntry(email, totalScore);
                            } else {
                              return MapEntry(email, 0);
                            }
                          });

                          final sortedEmails = totalScores.entries.toList()
                            ..sort((a, b) => b.value.compareTo(a.value));

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "by $filterType",
                                style: GoogleFonts.robotoSerif(
                                  fontSize: yY * 0.025,
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: sortedEmails.length,
                                itemBuilder: (context, index) {
                                  final entry = sortedEmails[index];
                                  return Card(
                                    elevation: 5,
                                    child: SizedBox(
                                      height: yY * 0.1,
                                      child: Center(
                                        child: ListTile(
                                          title: GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProfilePage(
                                                    email: entry.key,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: SizedBox(
                                              width: xX * 0.06,
                                              child: Text(
                                                entry.key,
                                                style: GoogleFonts.robotoMono(
                                                  fontSize: yY * 0.02,
                                                ),
                                              ),
                                            ),
                                          ),
                                          trailing: Text(
                                            '${entry.value}',
                                            style: GoogleFonts.roboto(
                                                fontWeight: FontWeight.bold,
                                                fontSize: yY * 0.03),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          height: MediaQuery.of(context).size.height * 0.4,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Score Filter',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.03,
                      fontWeight: FontWeight.bold),
                ),
                _buildRadioTile('by All Scores', 'All Scores'),
                _buildRadioTile('by Vocabulary', 'Vocabulary'),
                _buildRadioTile('by Speaking', 'Speaking'),
                _buildRadioTile('by Pronunciation', 'Pronunciation'),
              ],
            ),
          ),
        );
      },
    );
  }

  RadioListTile<String> _buildRadioTile(String title, String value) {
    return RadioListTile<String>(
      title: Text(title),
      value: value,
      groupValue: filterType,
      onChanged: (value) {
        setState(() {
          filterType = value!;
        });
        Navigator.of(context).pop();
      },
    );
  }
}
