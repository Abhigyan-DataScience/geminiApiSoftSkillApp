import 'package:awesome_icons/awesome_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../pages/dashboardPage.dart';
import 'scorePage.dart';
import '../provider/mainProvider.dart';
import 'package:provider/provider.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double xX = MediaQuery.of(context).size.width;
    double yY = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(219, 219, 219, 1),
        body: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: xX * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: yY * 0.1),
                  Icon(
                    Icons.lock,
                    size: yY * 0.1,
                  ),
                  SizedBox(height: yY * 0.05),
                  const Text(
                    "Welcome to LangApp!",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: yY * 0.03),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ScorePage(),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 10,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.black,
                        ),
                        height: yY * 0.3,
                        width: xX * 0.9,
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                "Points",
                                style: GoogleFonts.aBeeZee(
                                  color: Colors.white,
                                  fontSize: yY * 0.1,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Board",
                                style: GoogleFonts.aBeeZee(
                                  color: Colors.white,
                                  fontSize: yY * 0.05,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(
                                Icons.emoji_events,
                                color: Colors.yellow,
                                size: yY * 0.05,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: yY * 0.05),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: yY * 0.01),
                            child: const Divider(
                              thickness: 2,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const Text(
                          "Employee Sign In",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: yY * 0.01),
                            child: const Divider(
                              thickness: 2,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: xX * 0.02),
                        child: FloatingActionButton.large(
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              await context
                                  .read<MainProvider>()
                                  .signInWithGoogle();
                              if (context.read<MainProvider>().user != null) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => DashboardPage(),
                                  ),
                                );
                              }
                            } catch (e) {
                              print(e);
                            } finally {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                          backgroundColor: Colors.white54,
                          elevation: 10,
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.redAccent,
                                  ),
                                )
                              : const Icon(
                                  FontAwesomeIcons.google,
                                  color: Colors.redAccent,
                                  size: 40,
                                ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: yY * 0.1),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
