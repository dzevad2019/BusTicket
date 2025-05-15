import 'dart:io';
import 'package:bus_ticket_admin/providers/bus_lines_provider.dart';
import 'package:bus_ticket_admin/providers/cities_provider.dart';
import 'package:bus_ticket_admin/providers/companies_provider.dart';
import 'package:bus_ticket_admin/providers/holidays_provider.dart';
import 'package:bus_ticket_admin/providers/notifications_provider.dart';
import 'package:bus_ticket_admin/providers/reports_provider.dart';
import 'package:bus_ticket_admin/providers/tickets_provider.dart';
import 'package:bus_ticket_admin/providers/users_provider.dart';
import 'package:bus_ticket_admin/providers/vehicles_provider.dart';
import 'package:flutter/material.dart';
import 'package:bus_ticket_admin/providers/bus_stops_provider.dart';
import 'package:bus_ticket_admin/providers/countries_provider.dart';
import 'package:bus_ticket_admin/providers/discounts_provider.dart';
import 'package:bus_ticket_admin/providers/enum_provider.dart';
import 'package:bus_ticket_admin/screens/countries/country_list_screen.dart';
import 'package:bus_ticket_admin/screens/home/home_screen.dart';
import 'package:bus_ticket_admin/screens/login/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'helpers/my_http_overrides.dart';

void main() async {
  await dotenv.load(fileName: "assets/.env");
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CityProvider()),
          ChangeNotifierProvider(create: (_) => CompanyProvider()),
          ChangeNotifierProvider(create: (_) => CountryProvider()),
          ChangeNotifierProvider(create: (_) => DiscountsProvider()),
          ChangeNotifierProvider(create: (_) => BusStopsProvider()),
          ChangeNotifierProvider(create: (_) => EnumProvider()),
          ChangeNotifierProvider(create: (_) => BusLinesProvider()),
          ChangeNotifierProvider(create: (_) => HolidaysProvider()),
          ChangeNotifierProvider(create: (_) => TicketsProvider()),
          ChangeNotifierProvider(create: (_) => UsersProvider()),
          ChangeNotifierProvider(create: (_) => VehiclesProvider()),
          ChangeNotifierProvider(create: (_) => NotificationsProvider()),
          ChangeNotifierProvider(create: (_) => ReportsProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: LoginScreen(),
          onGenerateRoute: (settings) {
            if (settings.name == LoginScreen.routeName) {
              return MaterialPageRoute(
                builder: ((context) => LoginScreen()),
              );
            }
            if (settings.name == HomeScreen.routeName) {
              return MaterialPageRoute(
                builder: ((context) => HomeScreen()),
              );
            }
            if (settings.name == CountryListScreen.routeName) {
              return MaterialPageRoute(
                builder: ((context) => CountryListScreen()),
              );
            }
            return MaterialPageRoute(
              builder: ((context) => UnknownScreen()),
            );
          },
        ),
    );
  }
}

class UnknownScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unknown Screen'),
      ),
      body: Center(
        child: Text('Unknown Screen'),
      ),
    );
  }
}