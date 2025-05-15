import 'package:bus_ticket_admin/enums/enums.dart';
import 'package:bus_ticket_admin/models/bus_line.dart';
import 'package:bus_ticket_admin/models/listItem.dart';
import 'package:bus_ticket_admin/providers/bus_lines_provider.dart';
import 'package:bus_ticket_admin/providers/enum_provider.dart';
import 'package:bus_ticket_admin/screens/bus_lines/add_edit_bus_line_page.dart';
import 'package:bus_ticket_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';
import '../../utils/colorized_text_avatar.dart';

class BusLineListScreen extends StatefulWidget {
  const BusLineListScreen({Key? key}) : super(key: key);

  @override
  State<BusLineListScreen> createState() => _BusLineListScreenState();
}

class _BusLineListScreenState extends State<BusLineListScreen> {
  BusLinesProvider? _busLinesProvider;
  EnumProvider? _enumProvider;
  final TextEditingController _searchController = TextEditingController();
  GlobalKey<NumberPaginatorState> paginatorKey = GlobalKey();

  List<BusLine> data = [];
  List<ListItem> companies = [];
  int page = 1;
  int pageSize = 10;
  int totalRecordCounts = 0;
  int numberOfPages = 1;
  int currentPage = 1;

  bool isLoading = true;
  String searchFilter = '';
  int? searchCompanyId;

  @override
  void initState() {
    super.initState();
    _busLinesProvider = context.read<BusLinesProvider>();
    _enumProvider = context.read<EnumProvider>();
    loadCompanies();
    loadData(searchFilter, page, pageSize);
  }

  Future loadData(searchFilter, page, pageSize) async {
    if (searchFilter != '') page = 1;

    var params = {
      'SearchFilter': searchFilter.toString(),
      'PageNumber': page.toString(),
      'PageSize': pageSize.toString(),
    };

    if (searchCompanyId != null) {
      params['CompanyId'] = searchCompanyId.toString();
    }

    var response = await _busLinesProvider?.getForPagination(params);
    setState(() {
      data = response?.items ?? [];
      totalRecordCounts = response?.totalCount ?? 0;
      numberOfPages = ((totalRecordCounts - 1) / pageSize).toInt() + 1;
      isLoading = false;
    });
  }

  Future loadCompanies() async {
    var response = await _enumProvider!.getEnumItems("Companies");
    setState(() {
      companies = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 16),
                    _buildSearch(),
                    const SizedBox(height: 24),
                    Expanded(
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: _buildList(context),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildPagination(),
                  ],
                ),
              ),
      ),
    );
  }

  DataRow recentDataRow(BusLine busLine, BuildContext context) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              TextAvatar(
                size: 35,
                backgroundColor: Colors.blue[800],
                textColor: Colors.white,
                fontSize: 14,
                upperCase: true,
                numberLetters: 1,
                shape: Shape.Rectangle,
                text: busLine.name ?? '',
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    busLine.name ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (busLine.vehicles?.isNotEmpty ?? false)
                    Text(
                      busLine.vehicles!.first.vehicle?.company?.name ?? 'N/A',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        DataCell(
          Text(
            busLine.segments.isNotEmpty
                ? busLine.segments.first.departureTime!
                : "N/A",
            style: TextStyle(
              color: Colors.grey[700],
            ),
          ),
        ),
        DataCell(
          Text(
            busLine.segments.isNotEmpty
                ? busLine.segments.last.departureTime!
                : "N/A",
            style: TextStyle(
              color: Colors.grey[700],
            ),
          ),
        ),
        DataCell(
          Center(
            child: Icon(
              busLine.active ? Icons.check_circle : Icons.cancel,
              color: busLine.active ? Colors.green : Colors.red,
            ),
          ),
        ),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue),
                tooltip: 'Uredi',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          AddEditBusLinePage(busLineId: busLine.id),
                    ),
                  );
                },
              ),
              const SizedBox(width: 4),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                tooltip: 'Obriši',
                onPressed: () => showDeleteModal(context, busLine),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Upravljanje autobusnim linijama",
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

  void showDeleteModal(BuildContext context, BusLine busLine) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            const SizedBox(width: 12),
            Text("Potvrda brisanja"),
          ],
        ),
        content: Text(
            "Da li ste sigurni da želite obrisati liniju ${busLine.name}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Odustani", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () async {
              await deleteById(busLine.id);
              await loadData(searchFilter, 1, pageSize);
              Navigator.pop(context);
            },
            child: const Text("Obriši"),
          ),
        ],
      ),
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
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  hintText: "Pretražite linije...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: DropdownButtonFormField<int>(
                value: searchCompanyId,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  labelText: 'Kompanija',
                ),
                isExpanded: true,
                onChanged: (value) => setState(() => searchCompanyId = value),
                items: [
                  DropdownMenuItem<int>(
                    value: null,
                    child:
                        Text('Sve kompanije', overflow: TextOverflow.ellipsis),
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
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                searchFilter = _searchController.text;
                loadData(searchFilter, page, pageSize);
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Pretraži'),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddEditBusLinePage(),
                  ),
                );
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Dodaj liniju'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
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
          columns: const [
            DataColumn(
                label: Text("Linija",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text("Polazak",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text("Dolazak",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text("Status",
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
                const SizedBox(width: 8),
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
    await _busLinesProvider?.deleteById(id);
    setState(() {
      currentPage = 1;
      loadData("", currentPage, pageSize);
      //paginatorKey.currentState?.dispose();
      paginatorKey = GlobalKey();
    });
  }
}
