import 'package:bus_ticket_mobile/extensions/date_time_extension.dart';
import 'package:bus_ticket_mobile/models/bus_line.dart';
import 'package:bus_ticket_mobile/screens/ticket/ticket_purchase_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BusRoutesList extends StatelessWidget {
  final List<BusLine> routes;
  final bool isRoundTrip;
  final int fromStationId;
  final int toStationId;

  final DateTime dateTime;
  final DateTime? dateTimeRoundTrip;


  const BusRoutesList({
    Key? key,
    required this.routes,
    required this.fromStationId,
    required this.toStationId,
    required this.isRoundTrip,
    required this.dateTime,
    required this.dateTimeRoundTrip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: routes.length,
      itemBuilder: (context, index) {
        final route = routes[index];
        return BusRouteCard(
          route: route,
          fromStationId: fromStationId,
          toStationId: toStationId,
          isRoundTrip: isRoundTrip,
          dateTime: dateTime,
          dateTimeRoundTrip: dateTimeRoundTrip,
        );
      },
    );
  }
}

class BusRouteCard extends StatefulWidget {
  final BusLine route;
  final bool isRoundTrip;
  final int fromStationId;
  final int toStationId;

  final DateTime dateTime;
  final DateTime? dateTimeRoundTrip;


  const BusRouteCard({
    Key? key,
    required this.route,
    required this.fromStationId,
    required this.toStationId,
    required this.isRoundTrip,
    required this.dateTime,
    required this.dateTimeRoundTrip,
  }) : super(key: key);

  @override
  _BusRouteCardState createState() => _BusRouteCardState();
}

class _BusRouteCardState extends State<BusRouteCard> {
  bool _isExpanded = false;
  bool _showSegments = false;

  int? _selectedReturnRouteIndex;

  int? returnFromSegmentId;
  int? returnToSegmentId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final route = widget.route;

    // Get departure and arrival segments
    final fromSegment = route.segments.firstWhere(
          (s) => s.busStopId == widget.fromStationId,
    );

    final toSegment = route.segments.lastWhere(
          (s) => s.busStopId == widget.toStationId,
    );

    // Find the price for this specific segment
    final price = fromSegment.prices?.firstWhere(
          (p) => p.busLineSegmentToId == toSegment.id,
    );

    // Get all segments between from and to stations
    //final relevantSegments = route.segments.where((s) =>
    //s.stopOrder! >= fromSegment.stopOrder! &&
    //    s.stopOrder! <= toSegment.stopOrder!
    //).toList();

    final relevantSegments = route.segments;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: [
          // Basic info (always visible)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Departure info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Polazak',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        fromSegment.departureTime ?? '--:--',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(fromSegment.busStop!.name),
                    ],
                  ),
                ),

                // Duration and line type
                Column(
                  children: [
                    Text(_calculateDuration(
                        fromSegment.departureTime ?? '00:00',
                        toSegment.departureTime ?? '00:00'
                    )),
                    const Text('direktna linija'),
                  ],
                ),

                // Arrival info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Dolazak',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        toSegment.departureTime ?? '--:--',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(toSegment.busStop!.name),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Price and expand button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(widget.isRoundTrip ?
                    price?.returnTicketPrice!.toStringAsFixed(2) :
                    price?.oneWayTicketPrice!.toStringAsFixed(2)) ?? '0.00'} KM',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Text(
                    _isExpanded ? 'SAKRIJ DETALJE' : 'PRIKAŽI DETALJE',
                    style: TextStyle(color: theme.primaryColor),
                  ),
                ),
              ],
            ),
          ),

          // Expanded details
          if (_isExpanded) ...[
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Bus line info
                  const Text(
                    'Autobuska linija:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    route.name ?? 'Nepoznato',
                    style: const TextStyle(fontSize: 15),
                  ),

                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.directions_bus,
                                size: 20,
                                color: theme.primaryColor),
                            const SizedBox(width: 8),
                            Text(
                              'INFORMACIJE O SJEDIŠTIMA',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: theme.primaryColor,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildSeatInfo(
                              icon: Icons.event_seat,
                              label: 'Ukupno sjedišta',
                              value: route.numberOfSeats?.toString() ?? 'N/A',
                              iconColor: Colors.grey[600]!,
                            ),
                            _buildSeatInfo(
                              icon: Icons.event_seat,
                              label: 'Zauzeto',
                              value: route.busySeats?.length?.toString() ?? 'N/A',
                              iconColor: Colors.red,
                            ),
                            _buildSeatInfo(
                              icon: Icons.percent,
                              label: 'Popunjenost',
                              value: route.numberOfSeats != null && route.busySeats?.length != null
                                  ? '${((route.busySeats!.length / route.numberOfSeats!) * 100).roundToDouble()}%'
                                  : 'N/A',
                              iconColor: Colors.blue,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),


                  // Bus company info
                  const Text(
                    'Autobuska kompanija:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    route.vehicles.isNotEmpty
                        ? route.vehicles.first.vehicle!.company?.name ?? 'Nepoznato'
                        : 'Nepoznato',
                    style: const TextStyle(fontSize: 15),
                  ),

                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Stajališta na liniji:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _showSegments = !_showSegments;
                              });
                            },
                            child: Text(
                              _showSegments ? 'Sakrij stajališta' : 'Prikaži stajališta',
                              style: TextStyle(
                                color: theme.primaryColor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_showSegments) ...[
                        const SizedBox(height: 8),
                        ...relevantSegments.map((segment) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            segment.busStop!.name,
                                            style: const TextStyle(fontSize: 15),
                                          ),
                                        ),
                                        Container(
                                          width: 70,
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            segment.departureTime ?? '--:--',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(height: 16),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )).toList(),
                      ],
                      const SizedBox(height: 16),
                    ],
                  ),

                  // Discounts
                  if (route.discounts.isNotEmpty) ...[
                    const Text(
                      'Dostupni popusti:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ...route.discounts.map((discount) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '${discount.discount!.name} - ${discount.value}%',
                        style: const TextStyle(fontSize: 15),
                      ),
                    )).toList(),
                  ],

                  if (widget.isRoundTrip && route.returnLines.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    const Text(
                      'Odaberite povratnu kartu:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Lista povratnih linija
                    ...route.returnLines.asMap().entries.map((entry) {
                      final index = entry.key;
                      final returnLine = entry.value;
                      final returnFromSegment = returnLine.segments.firstWhere(
                            (s) => s.busStopId == widget.toStationId,
                      );
                      final returnToSegment = returnLine.segments.lastWhere(
                            (s) => s.busStopId == widget.fromStationId,
                      );

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              // Vremena polaska i dolaska
                              Row(
                                children: [
                                  // Polazak
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Polazak',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        Text(
                                          returnFromSegment?.departureTime ?? '--:--',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(returnFromSegment?.busStop?.name ?? ""),
                                      ],
                                    ),
                                  ),

                                  // Trajanje
                                  Column(
                                    children: [
                                      Text(_calculateDuration(
                                          returnFromSegment?.departureTime ?? '00:00',
                                          returnToSegment?.departureTime ?? '00:00')),
                                      const Text('direktna linija'),
                                    ],
                                  ),

                                  // Dolazak
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        const Text(
                                          'Dolazak',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        Text(
                                          returnToSegment?.departureTime ?? '--:--',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(returnToSegment?.busStop?.name ?? ""),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Kompanija i dugme za odabir
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    returnLine.vehicles.isNotEmpty
                                        ? returnLine.vehicles.first.vehicle!.company?.name ?? 'Nepoznato'
                                        : 'Nepoznato',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _selectedReturnRouteIndex == index
                                          ? Colors.green
                                          : theme.primaryColor,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _selectedReturnRouteIndex = index;
                                      });
                                    },
                                    child: Text(
                                      _selectedReturnRouteIndex == index
                                          ? 'ODABRANO'
                                          : 'ODABERI',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ],
              ),
            ),

            // Buy button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {

                    if (widget.isRoundTrip && _selectedReturnRouteIndex == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Molimo odaberite povratnu liniju'),
                        ),
                      );
                      return;
                    }

                    BusLine? returnLine = widget.isRoundTrip && _selectedReturnRouteIndex != null
                        ? route.returnLines[_selectedReturnRouteIndex!]
                        : null;

                    final returnFromSegment = returnLine?.segments.firstWhere(
                          (s) => s.busStopId == widget.toStationId,
                    );
                    final returnToSegment = returnLine?.segments.lastWhere(
                          (s) => s.busStopId == widget.fromStationId,
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TicketPurchasePage(
                          route: widget.route,
                          returnRoute: returnLine,
                          roundTrip: widget.isRoundTrip,
                          busLineSegmentFromId: fromSegment.id,
                          busLineSegmentToId: toSegment.id,
                          busLineSegmentReturnFromId: returnFromSegment?.id,
                          busLineSegmentReturnToId: returnToSegment?.id,
                          basePrice: (widget.isRoundTrip ? price?.returnTicketPrice : price?.oneWayTicketPrice) ?? 0.0,
                          dateTime: widget.dateTime.withTimeFromString(route.segments.first.departureTime!),
                          dateTimeRoundTrip: widget.isRoundTrip && _selectedReturnRouteIndex != null
                        ? widget.dateTimeRoundTrip!.withTimeFromString(returnLine!.segments.first.departureTime!)
                          : null,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'KUPI KARTU',
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
        ],
      ),
    );
  }

  String _calculateDuration(String departure, String arrival) {
    try {
      final dep = departure.split(':');
      final arr = arrival.split(':');
      final depHour = int.parse(dep[0]);
      final depMin = int.parse(dep[1]);
      final arrHour = int.parse(arr[0]);
      final arrMin = int.parse(arr[1]);

      int totalMinutes = (arrHour * 60 + arrMin) - (depHour * 60 + depMin);
      int hours = totalMinutes ~/ 60;
      int minutes = totalMinutes % 60;

      return '${hours}h:${minutes}m';
    } catch (e) {
      return '--h:--m';
    }
  }
}

Widget _buildSeatInfo({
  required IconData icon,
  required String label,
  required String value,
  required Color iconColor,
}) {
  return Column(
    children: [
      Icon(icon, size: 28, color: iconColor),
      const SizedBox(height: 4),
      Text(
        value,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
    ],
  );
}