import 'dart:io';
import 'package:bus_ticket_mobile/providers/bus_lines_provider.dart';
import 'package:bus_ticket_mobile/providers/bus_stops_provider.dart';
import 'package:bus_ticket_mobile/providers/companies_provider.dart';
import 'package:bus_ticket_mobile/providers/dropdown_provider.dart';
import 'package:bus_ticket_mobile/providers/notifications_provider.dart';
import 'package:bus_ticket_mobile/providers/recommendations_provider.dart';
import 'package:bus_ticket_mobile/providers/registration_provider.dart';
import 'package:bus_ticket_mobile/providers/tickets_provider.dart';
import 'package:bus_ticket_mobile/providers/users_provider.dart';
import 'package:bus_ticket_mobile/screens/home/home_page.dart';
import 'package:bus_ticket_mobile/screens/home/main_screen.dart';
import 'package:bus_ticket_mobile/screens/login/login_screen.dart';
import 'package:bus_ticket_mobile/utils/signalr_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:flutter/material.dart';
import 'package:bus_ticket_mobile/helpers/my_http_overrides.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: "assets/.env");
  HttpOverrides.global = MyHttpOverrides();
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY']!;


  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override

  Widget build(BuildContext context) {

    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => RegistrationProvider()),
          ChangeNotifierProvider(create: (_) => DropdownProvider()),
          ChangeNotifierProvider(create: (_) => BusLinesProvider()),
          ChangeNotifierProvider(create: (_) => TicketsProvider()),
          ChangeNotifierProvider(create: (_) => UsersProvider()),
          ChangeNotifierProvider(create: (_) => NotificationsProvider()),
          ChangeNotifierProvider(create: (_) => CompaniesProvider()),
          ChangeNotifierProvider(create: (_) => BusStopsProvider()),
          ChangeNotifierProvider(create: (_) => RecommendationsProvider()),
        ],
        child: MaterialApp(
          home: const LoginScreen(),
          onGenerateRoute: (settings) {
            if (settings.name == HomePage.routeName) {
              return MaterialPageRoute(
                  builder: ((context) => MainScreen()));
            }
            else if (settings.name == LoginScreen.routeName) {
              return MaterialPageRoute(
                  builder: ((context) => LoginScreen()));
            }
          },
        ));
  }
}
