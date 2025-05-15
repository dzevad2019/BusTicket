import 'package:bus_ticket_admin/models/listItem.dart';
import 'package:bus_ticket_admin/models/ticket.dart';
import 'package:bus_ticket_admin/providers/enum_provider.dart';
import 'package:bus_ticket_admin/providers/tickets_provider.dart';
import 'package:bus_ticket_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';

class TicketListScreen extends StatefulWidget {
  int? userId = null;

  TicketListScreen({Key? key, this.userId}) : super(key: key);

  @override
  State<TicketListScreen> createState() => _TicketListScreenState();
}

class _TicketListScreenState extends State<TicketListScreen> {
  // Providers
  TicketsProvider? _ticketsProvider = null;
  EnumProvider? _enumProvider = null;

  // Controllers
  final TextEditingController _searchController = TextEditingController();

  // Pagination
  GlobalKey<NumberPaginatorState> paginatorKey = GlobalKey();
  int page = 1;
  int pageSize = 10;
  int totalRecordCounts = 0;
  int numberOfPages = 1;
  int currentPage = 1;

  // UI State
  bool isLoading = true;

  // Data Collections
  List<Ticket> data = [];
  List<Center> pages = [];

  List<ListItem> busStops = [];
  List<ListItem> companies = [];
  List<ListItem> statuses = [];
  List<ListItem> clients = [];

  int? searchClientId = null;
  int? searchCompanyId = null;
  int? searchStatus = null;

  @override
  void initState() {
    super.initState();
    _ticketsProvider = context.read<TicketsProvider>();
    _enumProvider = context.read<EnumProvider>();
    loadAllData();
  }

  Future loadAllData() async {
    await loadClients();
    loadBusStops();
    loadCompanies();
    loadStatuses();
    loadData("", page, pageSize);
  }

  Future loadData(searchFilter, page, pageSize) async {
    if (searchFilter != '') {
      page = 1;
    }

    var params = {
      'SearchFilter': searchFilter.toString() ?? "",
      'PageNumber': page.toString(),
      'PageSize': pageSize.toString(),
    };

    if (searchClientId != null) {
      params['UserId'] = searchClientId.toString();
    }

    if (searchCompanyId != null) {
      params['CompanyId'] = searchCompanyId.toString();
    }

    if (searchStatus != null && searchStatus != 3) {
      params['Status'] = searchStatus!.toString();
    }

    var response = await _ticketsProvider?.getForPagination(params);
    setState(() {
      data = response?.items as List<Ticket>;
    });
    totalRecordCounts = response?.totalCount as int;
    numberOfPages = ((totalRecordCounts - 1) / pageSize).toInt() + 1;

    setState(() {
      isLoading = false;
    });
  }

  Future loadClients() async {
    var response = await _enumProvider!.getEnumItems("Clients");

    setState(() {
      clients = response;

      if (widget.userId != null && response.any((client) => client.id == widget.userId)) {
        searchClientId = widget.userId;
      } else {
        searchClientId = null;
        //Navigator.of(context).pop();
      }
    });
  }

  Future loadBusStops() async {
    var response = await _enumProvider!.getEnumItems("Bus-Stops");
    setState(() {
      busStops = response;
    });
  }

  Future loadCompanies() async {
    var response = await _enumProvider!.getEnumItems("Companies");
    setState(() {
      companies = response;
    });
  }

  Future loadStatuses() async {
    var response = [
      ListItem(id: 3, label: "Svi statusi"),
      ListItem(id: 1, label: "Potvrđeno"),
      ListItem(id: 0, label: "Na čekanju"),
      ListItem(id: 2, label: "Otkazano"),
    ];
    setState(() {
      statuses = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    pages = List.generate(numberOfPages, (index) => Center());
    return MasterScreenWidget(
        child: Scaffold(
            appBar: widget.userId != null ? AppBar() : null,
            backgroundColor: Colors.grey[50],
            body: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        SizedBox(height: 16),
                        _buildSearch(),
                        SizedBox(height: 24),
                        Expanded(
                          child: Card(
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: _buildList(context),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildPagination(),
                      ],
                    ),
                  )));
  }

  DataRow recentDataRow(Ticket ticket, BuildContext context) {
    return DataRow(
      cells: [
        DataCell(
          Tooltip(
            message: ticket.transactionId,
            child: Text(
              ticket.transactionId,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ),
        DataCell(
          Tooltip(
            message: _getTicketSegmentsInfo(ticket),
            child: Text(
              _getTicketSegmentsInfo(ticket),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        DataCell(
          Text(
            ticket.payedBy?.userName ?? "N/A",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        DataCell(
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                ticket.persons.length.toString(),
                style: TextStyle(
                  color: Colors.blue[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        DataCell(
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getStatusColor(ticket.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _getStatusColor(ticket.status).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                _getStatusText(ticket.status),
                style: TextStyle(
                  color: _getStatusColor(ticket.status),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        DataCell(
          Text(
            "${ticket.totalAmount?.toStringAsFixed(2) ?? '0.00'} KM",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.green[800],
            ),
          ),
        ),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove_red_eye, color: Colors.blue),
                tooltip: 'Detalji',
                onPressed: () => showDetailsModal(context, ticket),
              ),
              IconButton(
                icon: Icon(Icons.edit, color: Colors.orange),
                tooltip: 'Promijeni status',
                onPressed: () => showChangeStatusModal(context, ticket),
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                tooltip: 'Obriši',
                onPressed: () => showDeleteModal(context, ticket),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getStatusText(TicketStatusType? status) {
    switch (status) {
      case TicketStatusType.confirmed:
        return "Potvrđeno";
      case TicketStatusType.cancelled:
        return "Otkazano";
      case TicketStatusType.pending:
      default:
        return "Na čekanju";
    }
  }

  Color _getStatusColor(TicketStatusType? status) {
    switch (status) {
      case TicketStatusType.confirmed:
        return Colors.green;
      case TicketStatusType.cancelled:
        return Colors.red;
      case TicketStatusType.pending:
      default:
        return Colors.orange;
    }
  }

  String _getTicketSegmentsInfo(Ticket ticket) {
    if (ticket.ticketSegments.isEmpty) return "N/A";

    String result = "";
    for (var segment in ticket.ticketSegments) {
      String date =
          "${segment.dateTime.day}.${segment.dateTime.month}.${segment.dateTime.year}";

      result += getRelationName(segment.busLineSegmentFrom?.busStopId,
              segment.busLineSegmentTo?.busStopId) +
          " ($date)\n";
    }
    return result.trim();
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Upravljanje kartama",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        Text(
          "Ukupno: $totalRecordCounts",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  String getRelationName(int? busStopFrom, int? busStopTo) {
    if (busStopFrom == null || busStopTo == null) {
      return "N/A";
    }
    var busStopFromName = busStops.firstWhere((x) => x.id == busStopFrom).label;
    var busStopToName = busStops.firstWhere((x) => x.id == busStopTo).label;

    return "$busStopFromName - $busStopToName";
  }

  void showDeleteModal(BuildContext context, Ticket ticket) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red),
              SizedBox(width: 12),
              Text("Potvrda brisanja"),
            ],
          ),
          content: Text(
              "Da li ste sigurni da želite obrisati kartu ${ticket.transactionId}?"),
          actions: [
            TextButton(
              child: Text("Odustani", style: TextStyle(color: Colors.grey)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text("Obriši"),
              onPressed: () async {
                await deleteById(ticket.id);
                await loadData(_searchController.text, 1, pageSize);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void showDetailsModal(BuildContext context, Ticket ticket) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Detalji karte",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                Divider(),
                SizedBox(height: 16),

                // Main ticket info
                Wrap(
                  spacing: 32,
                  runSpacing: 16,
                  children: [
                    _buildDetailCard(
                        "Transakcija", ticket.transactionId, Icons.receipt),
                    _buildDetailCard(
                        "Status", _getStatusText(ticket.status), Icons.info,
                        color: _getStatusColor(ticket.status)),
                    _buildDetailCard("Kupio", ticket.payedBy?.userName ?? "N/A",
                        Icons.person),
                    _buildDetailCard("Broj putnika",
                        ticket.persons.length.toString(), Icons.people),
                    _buildDetailCard(
                        "Ukupno",
                        "${ticket.totalAmount?.toStringAsFixed(2) ?? '0.00'} KM",
                        Icons.attach_money,
                        color: Colors.green),
                  ],
                ),

                SizedBox(height: 24),

                // Segments section
                Text("Segmenti vožnje",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 8),
                ...ticket.ticketSegments
                    .map((segment) => Card(
                          margin: EdgeInsets.only(bottom: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getRelationName(
                                      segment.busLineSegmentFrom?.busStopId,
                                      segment.busLineSegmentTo?.busStopId),
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "${segment.dateTime.day}.${segment.dateTime.month}.${segment.dateTime.year} • ${segment.dateTime.hour}:${segment.dateTime.minute.toString().padLeft(2, '0')}",
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                        ))
                    .toList(),

                SizedBox(height: 24),

                // Passengers section
                Text("Putnici",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 8),
                ...ticket.persons
                    .map((person) => Card(
                          margin: EdgeInsets.only(bottom: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${person.firstName} ${person.lastName}",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 8),
                                Wrap(
                                  spacing: 16,
                                  runSpacing: 8,
                                  children: [
                                    _buildPersonDetail(
                                        "Telefon", person.phoneNumber),
                                    _buildPersonDetail("Sjedalo",
                                        person.numberOfSeat.toString()),
                                    if (person.numberOfSeatRoundTrip != null)
                                      _buildPersonDetail(
                                          "Sjedalo (povratno)",
                                          person.numberOfSeatRoundTrip
                                              .toString()),
                                    _buildPersonDetail("Popust",
                                        person.discount?.name ?? "Nema"),
                                    _buildPersonDetail("Iznos",
                                        "${person.amount.toStringAsFixed(2)} KM"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailCard(String label, String value, IconData icon,
      {Color color = Colors.blue}) {
    return Container(
      width: 200,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 18, color: color),
                  SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPersonDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSearch() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      hintText: "Pretražite karte...",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                  ),
                ),
                SizedBox(width: 16),
                SizedBox(
                  width: 200,
                  child: DropdownButtonFormField<int>(
                    value: searchClientId,
                    decoration: InputDecoration(
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      labelText: 'Korisnik',
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    isExpanded: true,
                    onChanged: (value) =>
                        setState(() => searchClientId = value),
                    items: [
                      DropdownMenuItem<int>(
                        value: null,
                        child: Text('Svi korisnici',
                            overflow: TextOverflow.ellipsis),
                      ),
                      ...clients.map((client) {
                        return DropdownMenuItem<int>(
                          value: client.id,
                          child: Tooltip(
                            message: client.label,
                            child: Text(
                              client.label,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                SizedBox(
                  width: 200,
                  child: DropdownButtonFormField<int>(
                    value: searchCompanyId,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      labelText: 'Kompanija',
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    isExpanded: true,
                    onChanged: (value) =>
                        setState(() => searchCompanyId = value),
                    items: [
                      DropdownMenuItem<int>(
                        value: null,
                        child: Text('Sve kompanije',
                            overflow: TextOverflow.ellipsis),
                      ),
                      ...companies.map((company) {
                        return DropdownMenuItem<int>(
                          value: company.id,
                          child: Text(
                            company.label,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                SizedBox(
                  width: 200,
                  child: DropdownButtonFormField<int>(
                    value: searchStatus,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      labelText: 'Status',
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    isExpanded: true,
                    onChanged: (value) => setState(() => searchStatus = value),
                    items: statuses.map((status) {
                      return DropdownMenuItem<int>(
                        value: status.id,
                        child: Text(
                          status.label,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    loadData(_searchController.text, 1, pageSize);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Primijeni filtere'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SizedBox(
        width: double.infinity,
        child: DataTable(
          horizontalMargin: 0,
          columnSpacing: 16,
          columns: [
            DataColumn(
                label: Text("Transakcija",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text("Relacija",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text("Kupio",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text("Putnici",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text("Status",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text("Iznos",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text("Akcije",
                    style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: List.generate(
            data.length,
            (index) => recentDataRow(data[index], context),
          ),
        ),
      ),
    );
  }

  Widget _buildPagination() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Prikazano ${data.length} od $totalRecordCounts rezultata",
              style: TextStyle(color: Colors.grey[600]),
            ),
            Container(
              width: 400,
              child: NumberPaginator(
                key: paginatorKey,
                numberPages: numberOfPages,
                initialPage: currentPage - 1,
                onPageChange: (index) {
                  setState(() {
                    currentPage = index + 1;
                    loadData("", currentPage, pageSize);
                  });
                },
                config: NumberPaginatorUIConfig(
                  height: 40,
                  buttonShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  buttonSelectedForegroundColor: Colors.white,
                  buttonSelectedBackgroundColor: Colors.blue,
                  buttonUnselectedForegroundColor: Colors.grey[800],
                  buttonUnselectedBackgroundColor: Colors.grey[200],
                ),
              ),
            ),
            Row(
              children: [
                Text("Prikaži po:"),
                SizedBox(width: 8),
                DropdownButton<int>(
                  value: pageSize,
                  items: [5, 10, 20, 50].map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      pageSize = value!;
                      loadData(_searchController.text, 1, pageSize);
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> deleteById(int id) async {
    await _ticketsProvider?.deleteById(id);
    setState(() {
      currentPage = 1;
      loadData("", currentPage, pageSize);
      //paginatorKey.currentState?.dispose();
      paginatorKey = GlobalKey();
    });
  }

  void showChangeStatusModal(BuildContext context, Ticket ticket) {
    TicketStatusType? selectedStatus = ticket.status;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.edit, color: Colors.blue),
                  SizedBox(width: 12),
                  Text("Promijeni status karte"),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Trenutni status: ${_getStatusText(ticket.status)}"),
                  SizedBox(height: 16),
                  DropdownButtonFormField<TicketStatusType>(
                    value: selectedStatus,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Novi status',
                    ),
                    items: [
                      DropdownMenuItem(
                        value: TicketStatusType.pending,
                        child: Text("Na čekanju"),
                      ),
                      DropdownMenuItem(
                        value: TicketStatusType.confirmed,
                        child: Text("Potvrđeno"),
                      ),
                      DropdownMenuItem(
                        value: TicketStatusType.cancelled,
                        child: Text("Otkazano"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedStatus = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text("Odustani", style: TextStyle(color: Colors.grey)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Text("Sačuvaj"),
                  onPressed: () async {
                    if (selectedStatus != null &&
                        selectedStatus != ticket.status) {
                      await _changeTicketStatus(ticket.id, selectedStatus!);
                      await loadData(
                          _searchController.text, currentPage, pageSize);
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

// Add this method to handle the status change API call
  Future<void> _changeTicketStatus(
      int ticketId, TicketStatusType newStatus) async {
    try {
      await _ticketsProvider?.changeStatus(ticketId, newStatus.index);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Status karte uspješno promijenjen"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Greška pri promjeni statusa: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
