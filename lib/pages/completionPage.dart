import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CompletionPage extends StatelessWidget {
  final int score;

  const CompletionPage({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    double yY = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(219, 219, 219, 1),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.emoji_events, // Trophy icon
                size: yY * 0.2,
                color: Colors.amber,
              ),
              const SizedBox(height: 20),
              Text(
                'You have completed topic assessment',
                style: GoogleFonts.openSans(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                '$score / 10',
                style: GoogleFonts.openSans(
                    fontSize: 48, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: yY * 0.02),
                ),
                child: Text('Dashboard'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
