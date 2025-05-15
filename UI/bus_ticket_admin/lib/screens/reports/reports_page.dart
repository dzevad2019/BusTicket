import 'package:bus_ticket_admin/screens/reports/bus_occupancy_report_page.dart';
import 'package:bus_ticket_admin/screens/reports/ticket_sales_report_page.dart';
import 'package:bus_ticket_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Izvještaj o prodanim kartama po kompanijama i datumu',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TicketSalesReportPage(),
              Divider(height: 1, thickness: 1),
              const SizedBox(height: 20),
              const Text(
                'Izvještaj o popunjenosti autobusa',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              BusOccupancyReportPage(),
              Divider(height: 1, thickness: 1),
              const SizedBox(height: 20),

            ],
          ),
        ),
      ),
    );
  }
}
