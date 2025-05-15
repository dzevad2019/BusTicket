import 'package:bus_ticket_mobile/models/listItem.dart';
import 'package:bus_ticket_mobile/providers/dropdown_provider.dart';
import 'package:bus_ticket_mobile/providers/tickets_provider.dart';
import 'package:bus_ticket_mobile/utils/authorization.dart';
import 'package:flutter/material.dart';
import 'package:bus_ticket_mobile/models/ticket.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr/qr.dart' as qr_lib;

class TicketsPage extends StatefulWidget {
  const TicketsPage({Key? key}) : super(key: key);

  @override
  _TicketsPageState createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  final ScrollController _scrollController = ScrollController();
  TicketsProvider? _ticketsProvider;
  DropdownProvider? _enumProvider;

  bool _isLoading = false;
  bool _hasMore = true;
  final List<Ticket> _loadedTickets = [];
  int _currentPage = 1;
  static const int _ticketsPerPage = 10;
  List<ListItem> busStops = [];

  @override
  void initState() {
    super.initState();
    _ticketsProvider = context.read<TicketsProvider>();
    _enumProvider = context.read<DropdownProvider>();
    loadBusStops();
    _loadInitialTickets();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future loadBusStops() async {
    var response = await _enumProvider!.getItems("Bus-Stops");
    setState(() {
      busStops = response;
    });
  }

  Future<void> _loadInitialTickets() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      Map<String, String> params = {
        "PageNumber": _currentPage.toString(),
        "PageSize": _ticketsPerPage.toString(),
        "UserId": Authorization.id.toString()
      };

      final newTickets = await _ticketsProvider!.getMyTickets(params);
      setState(() {
        _loadedTickets.addAll(newTickets.items);
        _hasMore = newTickets.items.length >= _ticketsPerPage;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load tickets: $e'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  Future<void> _loadMoreTickets() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      Map<String, String> params = {
        "PageNumber": _currentPage.toString(),
        "PageSize": _ticketsPerPage.toString()
      };

      final newTickets = await _ticketsProvider!.getMyTickets(params);
      setState(() {
        _loadedTickets.addAll(newTickets.items);
        _hasMore = newTickets.items.length >= _ticketsPerPage;
        _currentPage++;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load more tickets: $e'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _scrollListener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        !_isLoading &&
        _hasMore) {
      _loadMoreTickets();
    }
  }

  Future<void> _refreshTickets() async {
    setState(() {
      _loadedTickets.clear();
      _currentPage = 1;
      _hasMore = true;
    });
    await _loadInitialTickets();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Karte',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [theme.primaryColor, theme.primaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _refreshTickets,
          ),
        ],
      ),
      body: RefreshIndicator(
        color: Colors.blue,
        onRefresh: _refreshTickets,
        child: _loadedTickets.isEmpty && !_isLoading
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //SvgPicture.asset(
              //  'assets/images/empty_tickets.svg',
              //  height: 200,
              //  semanticsLabel: 'No tickets',
              //),
              const SizedBox(height: 20),
              const Text(
                'No tickets found',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: _refreshTickets,
                child: const Text(
                  'Refresh',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        )
            : ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.only(top: 16, bottom: 16),
          itemCount: _loadedTickets.length + (_hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= _loadedTickets.length) {
              return _hasMore
                  ? const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
              )
                  : const SizedBox.shrink();
            }

            final ticket = _loadedTickets[index];
            return _buildTicketCard(ticket, index, theme.primaryColor);
          },
        ),
      ),
    );
  }

  Widget _buildTicketCard(Ticket ticket, int index, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            _showQrCodeDialog(ticket);
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Karta #${ticket.id}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusColor(ticket.status).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _getStatusColor(ticket.status),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        _getStatusText(ticket.status),
                        style: TextStyle(
                          color: _getStatusColor(ticket.status),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (ticket.transactionId != null)
                  Row(
                    children: [
                      const Icon(Icons.receipt, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        'Transakcije: ${ticket.transactionId}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                if (ticket.ticketSegments.isNotEmpty)
                  _buildTripDetails(ticket.ticketSegments.first, color),
                if (ticket.ticketSegments.length > 1)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      '${ticket.ticketSegments.length > 1 ? 'Povratna linija' : ''}',
                      style: TextStyle(
                        fontSize: 12,
                        color: color,
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Putnici',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '${ticket.persons.length}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    if (ticket.totalAmount != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            '\$${ticket.totalAmount!.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                if (ticket.persons.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  ...ticket.persons.map((person) => _buildPerson(person, color)).toList(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTripDetails(TicketSegment segment, Color color) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final timeFormat = DateFormat('HH:mm');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detalji',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                Container(
                  width: 2,
                  height: 30,
                  color: Colors.grey[300],
                ),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getBusStopName(segment.busLineSegmentFrom?.busStopId),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Polazak: ${dateFormat.format(segment.dateTime)} u ${timeFormat.format(segment.dateTime)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _getBusStopName(segment.busLineSegmentTo?.busStopId),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPerson(TicketPerson person, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              Icons.person,
              size: 18,
              color: color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${person.firstName} ${person.lastName}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _buildInfoChip(
                      Icons.phone,
                      person.phoneNumber ?? 'N/A',
                      color: color
                    ),
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      Icons.event_seat,
                      '${person.numberOfSeat}',
                        color: color
                    ),
                    if (person.numberOfSeatRoundTrip != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: _buildInfoChip(
                          Icons.event_seat,
                          '${person.numberOfSeatRoundTrip}',
                          color: Colors.orange,
                        ),
                      ),
                  ],
                ),
                if (person.discount != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: _buildInfoChip(
                      Icons.discount,
                      '${person.discount!.name} (${person.discount}%)',
                      color: Colors.green,
                    ),
                  ),
                const SizedBox(height: 4),
                Text(
                  '${person.amount.toStringAsFixed(2)} BAM',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (color ?? Colors.blue).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: color ?? Colors.blue,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              color: color ?? Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  String _getBusStopName(int? busStopId) {
    if (busStopId == null) return 'Unknown';
    try {
      return busStops.firstWhere((x) => x.key == busStopId).value;
    } catch (e) {
      return 'Unknown';
    }
  }

  String _getStatusText(TicketStatusType? status) {
    switch (status) {
      case TicketStatusType.pending:
        return 'Na čekanju';
      case TicketStatusType.confirmed:
        return 'Potvrđeno';
      case TicketStatusType.cancelled:
        return 'Otkazano';
      default:
        return 'Unknown';
    }
  }

  Color _getStatusColor(TicketStatusType? status) {
    switch (status) {
      case TicketStatusType.pending:
        return Colors.orange;
      case TicketStatusType.confirmed:
        return Colors.green;
      case TicketStatusType.cancelled:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showQrCodeDialog(Ticket ticket) {
    try {
      // Validate and prepare QR data
      final qrData = ticket.id?.toString() ?? 'invalid-ticket';

      // Calculate the appropriate version
      final qrCode = qr_lib.QrCode.fromData(
        data: qrData,
        errorCorrectLevel: qr_lib.QrErrorCorrectLevel.L,
      );

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Karta #${ticket.id}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  child: QrImageView(
                    data: qrData,
                    version: qrCode.typeNumber,
                    errorCorrectionLevel: QrErrorCorrectLevel.L,
                    size: 200.0,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Skenirajte QR kod za provjeru karte',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ZATVORI'),
            ),
          ],
        ),
      );
    } catch (e) {
      // Fallback if QR generation fails
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Greška pri generiranju QR koda'),
          content: Text('Nije moguće generirati QR kod za kartu #${ticket.id}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}