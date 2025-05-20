import 'package:flutter/material.dart';
import 'package:nukdi4/features/auth/screens/auth_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // 🔵 Background blue circle (positioned on the right)
            Positioned(
              bottom: 120,
              right: -100,
              child: Container(
                height: 320,
                width: 320,
                decoration: const BoxDecoration(
                  color: Colors.lightBlueAccent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // 🔧 Tagline
                      const Text(
                        "🔧 AUTOSPARKS",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.2,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // 🏷️ Title
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(fontSize: 28, color: Colors.black),
                          children: [
                            TextSpan(
                              text: 'Get the ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: 'best\n',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.lightBlue,
                              ),
                            ),
                            TextSpan(
                              text: 'parts for you.',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "Search hundreds and thousands of parts that best fit you.",
                        style: TextStyle(fontSize: 14.5, color: Colors.black54),
                      ),

                      const SizedBox(height: 20),

                      // 🚗 Car image: bigger and snapped off right
                      Transform.translate(
                        offset: const Offset(80, 0), // Shift to the right
                        child: Image.asset(
                          'assets/images/car.png',
                          height: 330, // Bigger height
                          width: 430, // Bigger width
                          fit: BoxFit.contain,
                        ),
                      ),

                      const Spacer(),

                      // 🔘 Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AuthScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Start Exploring →",
                            style: TextStyle(fontSize: 17, color: Colors.white),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
