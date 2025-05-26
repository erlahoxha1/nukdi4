import 'package:flutter/material.dart';
import 'package:nukdi4/features/auth/screens/auth_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E), // dark charcoal background
      body: SafeArea(
        child: Stack(
          children: [
            // SMALLER Background red circle
            Positioned(
              bottom: 120,
              right: -90,
              child: Container(
                height: 280, // smaller size
                width: 280,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 104, 9, 9),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Main content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),

                  // 🚨 Brand title
                  const Text(
                    "AUTOSPARKS",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Hero title
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(fontSize: 26, color: Colors.white),
                      children: [
                        TextSpan(
                          text: 'Get the ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: 'best\n',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 104, 9, 9),
                          ),
                        ),
                        TextSpan(
                          text: 'parts for your car.',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "Search thousands of parts that fit your car's needs.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.5, color: Colors.white70),
                  ),

                  const SizedBox(height: 10),

                  // 🚘 Rotated right & scaled car image
                  Transform(
                    alignment: Alignment.center,
                    transform:
                        Matrix4.identity()
                          ..rotateY(0.2) // rotate slightly right
                          ..scale(1.5), // enlarge 50%
                    child: Image.asset(
                      'assets/images/car.png',
                      height: 220,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const Spacer(),

                  // CTA button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 104, 9, 9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const AuthScreen()),
                        );
                      },
                      child: const Text(
                        "Start Exploring →",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
