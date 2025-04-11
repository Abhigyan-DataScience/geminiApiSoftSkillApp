import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/genAi.dart';
import '../provider/mainProvider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LessonPage extends StatefulWidget {
  final String topic;

  const LessonPage({super.key, required this.topic});

  @override
  _LessonPageState createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  Future<List<dynamic>> _fetchLessonContent() async {
    return await contentgenAi(widget.topic);
  }

  @override
  Widget build(BuildContext context) {
    double xX = MediaQuery.of(context).size.width;
    double yY = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(219, 219, 219, 1),
        body: SingleChildScrollView(
          child: Column(
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
                          backgroundImage: context
                                      .watch<MainProvider>()
                                      .user
                                      ?.photoURL !=
                                  null
                              ? NetworkImage(
                                  context.watch<MainProvider>().user!.photoURL!)
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: yY * 0.01,
              ),
              FutureBuilder<List<dynamic>>(
                future: _fetchLessonContent(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No data available"));
                  } else {
                    return SizedBox(
                      height: yY * 0.8,
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var section = snapshot.data![index];
                          return LessonSection(
                            sectionTitle: section['section'],
                            content: section['content'],
                            videoUrl: section['video'],
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LessonSection extends StatelessWidget {
  final String sectionTitle;
  final String content;
  final String videoUrl;

  const LessonSection({
    super.key,
    required this.sectionTitle,
    required this.content,
    required this.videoUrl,
  });

  @override
  Widget build(BuildContext context) {
    double xX = MediaQuery.of(context).size.width;
    double yY = MediaQuery.of(context).size.height;
    return Card(
      elevation: 10,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sectionTitle,
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.bold,
                fontSize: yY * 0.045,
                color: Colors.black87,
              ),
            ),
            const Divider(thickness: 1.5),
            SizedBox(height: yY * 0.01),
            _buildRichText(content, yY * 0.025),
            SizedBox(height: yY * 0.05),
            if (videoUrl.isNotEmpty)
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _launchURL(videoUrl);
                  },
                  icon: const Icon(Icons.play_circle_outline),
                  label: SizedBox(
                    width: xX,
                    child: const Center(
                      child: Text('Watch Video'),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  RichText _buildRichText(String text, double size) {
    final RegExp boldRegex = RegExp(r'\*\*(.*?)\*\*');
    List<TextSpan> spans = [];
    int lastMatchEnd = 0;

    for (final match in boldRegex.allMatches(text)) {
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(text: text.substring(lastMatchEnd, match.start)));
      }

      spans.add(TextSpan(
        text: match.group(1),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ));

      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastMatchEnd)));
    }

    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: Colors.black87,
          fontSize: size,
          height: 1.5,
        ),
        children: spans,
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
