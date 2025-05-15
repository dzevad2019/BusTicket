import 'package:bus_ticket_mobile/screens/home/home_page.dart';
import 'package:bus_ticket_mobile/screens/home/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PaymentSuccess extends StatelessWidget {
  const PaymentSuccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Animated success checkmark
            Container(
              height: 150,
              margin: const EdgeInsets.only(bottom: 32),
              child: Lottie.asset(
                'assets/success.json',
                width: 150,
                height: 150,
                fit: BoxFit.contain,
              ),
            ),

            // Success message
            Text(
              "Plaćanje uspješno!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),

            // Additional info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Vaša karta je uspješno kupljena. Detalje o putovanju možete pronaći u sekciji 'Moje karte'.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
            ),
            const Spacer(),

            // Ticket icon
            Icon(
              Icons.confirmation_number_outlined,
              size: 40,
              color: theme.primaryColor,
            ),
            const SizedBox(height: 8),
            Text(
              "Broj karte: #${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const Spacer(),

            // Home button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const MainScreen()),
                          (route) => false,
                    );
                  },
                  child: const Text(
                    'Idi na početnu',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}