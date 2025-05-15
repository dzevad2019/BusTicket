import 'package:bus_ticket_admin/screens/login/login_screen.dart';
import 'package:bus_ticket_admin/utils/authorization.dart';
import 'package:bus_ticket_admin/widgets/bus_admin_drawer.dart';
import 'package:flutter/material.dart';

class MasterScreenWidget extends StatefulWidget {
  final Widget? child;
  final String? title;

  MasterScreenWidget({this.child, this.title, Key? key}) : super(key: key);

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  @override
  Widget build(BuildContext context) {
    final bool isWideScreen = MediaQuery.of(context).size.width >= 1100;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: theme.primaryColor,
        title: Row(
          children: [
            Icon(Icons.directions_bus, size: 28),
            SizedBox(width: 10),
            Text(
              widget.title ?? "BusTicket Admin",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        centerTitle: false,
        elevation: 2,
        actions: [
          //IconButton(
          //  icon: Icon(Icons.notifications),
          //  tooltip: 'Notifications',
          //  onPressed: () {},
          //),
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Odjava',
            onPressed: () => _confirmLogout(context),
          ),
        ],
      ),
      drawer: !isWideScreen ? BusAdminDrawer() : null,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isWideScreen)
              Container(
                width: 280,
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(2, 0),
                    )
                  ],
                ),
                child: BusAdminDrawer(),
              ),
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.all(20),
                child: widget.child ?? Center(child: Text('No content')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Potvrda odjave'),
        content: Text('Da li ste sigurni da želite da se odjavite?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Otkaži'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Odjavi se'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      Authorization.token = null;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
            (Route<dynamic> route) => false,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Uspešno ste se odjavili')),
      );
    }
  }
}
