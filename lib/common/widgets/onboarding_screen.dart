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
            // Background circle
            Positioned(
              bottom: 100,
              right: -100,
              child: Container(
                height: 300,
                width: 300,
                decoration: const BoxDecoration(
                  color: Colors.lightBlueAccent,
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

                  // 🚨 MAIN BRANDING: AUTOSPARKS
                  const Text(
                    "AUTOSPARKS",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 🏷️ Hero Title
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(fontSize: 26, color: Colors.black),
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
                    style: TextStyle(fontSize: 14.5, color: Colors.black54),
                  ),

                  const SizedBox(height: 30),

                  // 🚘 Car Image
                  Image.asset(
                    'assets/images/car.png',
                    height: 240,
                    fit: BoxFit.contain,
                  ),

                  const Spacer(),

                  // CTA Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
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
