import 'package:bus_ticket_admin/providers/login_provider.dart';
import 'package:bus_ticket_admin/screens/bus_lines/bus_lines_list_screen.dart';
import 'package:bus_ticket_admin/screens/bus_stops/bus_stop_list_screen.dart';
import 'package:bus_ticket_admin/screens/cities/city_list_screen.dart';
import 'package:bus_ticket_admin/screens/companies/company_list_screen.dart';
import 'package:bus_ticket_admin/screens/countries/country_list_screen.dart';
import 'package:bus_ticket_admin/screens/discounts/discount_list_screen.dart';
import 'package:bus_ticket_admin/screens/holidays/holidays_list_screen.dart';
import 'package:bus_ticket_admin/screens/home/home_screen.dart';
import 'package:bus_ticket_admin/screens/login/login_screen.dart';
import 'package:bus_ticket_admin/screens/notifications/notification_list_page.dart';
import 'package:bus_ticket_admin/screens/notifications/notification_sender_page.dart';
import 'package:bus_ticket_admin/screens/reports/reports_page.dart';
import 'package:bus_ticket_admin/screens/tickets/tickets_list_screen.dart';
import 'package:bus_ticket_admin/screens/users/user_list_screen.dart';
import 'package:bus_ticket_admin/screens/vehicles/vehicle_list_screen.dart';
import 'package:bus_ticket_admin/utils/authorization.dart';
import 'package:flutter/material.dart';

class BusAdminDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text((Authorization.firstName ?? '') +
                      ' ' +
                      (Authorization.lastName ?? '')),
                  accountEmail: Text(Authorization.email ?? ''),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40),
                  ),
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                  ),
                ),

                // Menu items
                _createDrawerItem(
                  icon: Icons.dashboard,
                  text: "Početna",
                  onTap: () => _navigateTo(context, HomeScreen()),
                ),

                // Locations section
                _buildSectionHeader('Lokacije'),
                _createDrawerItem(
                  icon: Icons.flag,
                  text: "Zemlje",
                  onTap: () => _navigateTo(context, CountryListScreen()),
                ),
                _createDrawerItem(
                  icon: Icons.location_city,
                  text: "Gradovi",
                  onTap: () => _navigateTo(context, CityListScreen()),
                ),
                _createDrawerItem(
                  icon: Icons.pin_drop,
                  text: "Autobuske stanice",
                  onTap: () => _navigateTo(context, BusStopListScreen()),
                ),

                Divider(height: 1, thickness: 1),

                // Operations section
                _buildSectionHeader('Operacije'),
                _createDrawerItem(
                  icon: Icons.business,
                  text: "Prijevoznici",
                  onTap: () => _navigateTo(context, CompanyListScreen()),
                ),
                _createDrawerItem(
                  icon: Icons.directions_bus,
                  text: "Vozila",
                  onTap: () => _navigateTo(context, VehicleListScreen()),
                ),
                _createDrawerItem(
                  icon: Icons.route,
                  text: "Autobuske linije",
                  onTap: () => _navigateTo(context, BusLineListScreen()),
                ),
                _createDrawerItem(
                  icon: Icons.qr_code,
                  text: "Prodane karte",
                  onTap: () => _navigateTo(context, TicketListScreen()),
                ),
                _createDrawerItem(
                  icon: Icons.person,
                  text: "Korisnici",
                  onTap: () => _navigateTo(context, UserListScreen()),
                ),
                _createDrawerItem(
                  icon: Icons.add_chart,
                  text: "Izvještaji",
                  onTap: () => _navigateTo(context, ReportsPage()),
                ),
                _createDrawerItem(
                  icon: Icons.notifications,
                  text: "Notifikacije",
                  onTap: () => _navigateTo(context, NotificationListScreen()),
                ),
                Divider(height: 1, thickness: 1),

                // Settings section
                _buildSectionHeader('Postavke'),
                _createDrawerItem(
                  icon: Icons.event,
                  text: "Praznici",
                  onTap: () => _navigateTo(context, HolidayListScreen()),
                ),
                _createDrawerItem(
                  icon: Icons.discount,
                  text: "Popusti",
                  onTap: () => _navigateTo(context, DiscountListScreen()),
                ),

                //SizedBox(height: 20), // Adjust height as needed

                //Divider(height: 1, thickness: 1),
//
                //// Logout button
                //_createDrawerItem(
                //  icon: Icons.exit_to_app,
                //  text: "Logout",
                //  onTap: () {
                //    LoginProvider.setResponseFalse();
                //    Navigator.of(context).pushReplacement(
                //      MaterialPageRoute(builder: (context) => LoginScreen()),
                //    );
                //  },
                //),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _createDrawerItem({
    required IconData icon,
    required String text,
    required GestureTapCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 24),
      title: Text(
        text,
        style: TextStyle(fontSize: 14),
      ),
      dense: true,
      horizontalTitleGap: 10,
      minLeadingWidth: 30,
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
      onTap: onTap,
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}
