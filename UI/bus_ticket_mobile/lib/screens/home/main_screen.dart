import 'package:bus_ticket_mobile/screens/bus-line/bus_routes_list.dart';
import 'package:bus_ticket_mobile/screens/bus-stops/bus_stop_list.dart';
import 'package:bus_ticket_mobile/screens/company/companies_list.dart';
import 'package:bus_ticket_mobile/screens/home/home_content.dart';
import 'package:bus_ticket_mobile/screens/ticket/user_tickets_page.dart';
import 'package:bus_ticket_mobile/screens/user/profile_edit_page.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(key: UniqueKey()),
    CompaniesPage(key: UniqueKey()),
    BusStopsPage(key: UniqueKey()),
    TicketsPage(key: UniqueKey()),
    ProfileEditPage(key: UniqueKey()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Početna'),
          BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Prevoznici'),
          BottomNavigationBarItem(icon: Icon(Icons.place_outlined), label: 'Stanice'),
          BottomNavigationBarItem(icon: Icon(Icons.confirmation_number), label: 'Karte'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}