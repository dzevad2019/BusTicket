import 'package:bus_ticket_admin/models/bus_stop.dart';
import 'package:bus_ticket_admin/models/listItem.dart';
import 'package:bus_ticket_admin/providers/bus_stops_provider.dart';
import 'package:bus_ticket_admin/providers/enum_provider.dart';
import 'package:bus_ticket_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';
import '../../../utils/exstenzions/iterable_extension.dart';

class BusStopListScreen extends StatefulWidget {
  const BusStopListScreen({Key? key}) : super(key: key);

  @override
  State<BusStopListScreen> createState() => _BusStopListScreenState();
}

class _BusStopListScreenState extends State<BusStopListScreen> {
  BusStopsProvider? _busStopsProvider = null;
  EnumProvider? _enumProvider = null;
  TextEditingController _searchController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  GlobalKey<NumberPaginatorState> paginatorKey = GlobalKey();
  List<BusStop> data = [];
  List<ListItem> cities = [];
  int page = 1;
  int pageSize = 10;
  int totalRecordCounts = 0;
  String searchFilter = '';
  bool isLoading = true;
  int numberOfPages = 1;
  int currentPage = 1;
  List<Center> pages = [];
  final _formKey = GlobalKey<FormState>();
  bool isFirstSubmit = false;
  int? searchCityId = null;

  @override
  void initState() {
    super.initState();
    _busStopsProvider = context.read<BusStopsProvider>();
    _enumProvider = context.read<EnumProvider>();
    loadCities();
    loadData(searchFilter, page, pageSize);
  }

  Future loadCities() async {
    var response = await _enumProvider?.getEnumItems("Cities");
    setState(() {
      cities = response!;
    });
  }

  Future loadData(searchFilter, page, pageSize) async {
    if (searchFilter != '') {
      page = 1;
    }

    var searchParams = {
      'SearchFilter': searchFilter.toString() ?? "",
      'PageNumber': page.toString(),
      'PageSize': pageSize.toString()
    };

    if (searchCityId != null) {
      searchParams['CityId'] = searchCityId.toString();
    }

    var response = await _busStopsProvider?.getForPagination(searchParams);
    setState(() {
      data = response?.items as List<BusStop>;
    });
    totalRecordCounts = response?.totalCount as int;
    numberOfPages = ((totalRecordCounts - 1) / pageSize).toInt() + 1;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    pages = List.generate(numberOfPages, (index) => Center());
    return MasterScreenWidget(
      child: Scaffold(
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: _buildList(context),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildPagination(),
                  ],
                ),
              ),
      ),
    );
  }

  DataRow recentDataRow(BusStop busStop, BuildContext context) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            busStop.name!,
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        DataCell(
          Text(
            busStop.city?.name ?? '',
            style: TextStyle(
              color: Colors.grey[700],
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
                  showAddEditModal(context, busStop, true);
                },
              ),
              SizedBox(width: 4),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                tooltip: 'Obriši',
                onPressed: () => showDeleteModal(context, busStop),
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
          "Upravljanje autobusnim stanicama",
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

  void showDeleteModal(BuildContext context, BusStop busStop) {
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
              "Da li ste sigurni da želite obrisati autobusku stanicu ${busStop.name}?"),
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
                await deleteById(busStop.id);
                await loadData(searchFilter, 1, pageSize);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void showAddEditModal(BuildContext context, BusStop busStop, bool isEdit) {
    _nameController.text = busStop.name ?? '';
    int? selectedCityId = cities.firstOrNull((x) => x.id == busStop.cityId)?.id;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: 400,
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isEdit
                          ? 'Uredi autobusku stanicu'
                          : "Dodaj autobusku stanicu",
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
                Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _formKey,
                  onChanged: () {
                    if (isFirstSubmit) _formKey.currentState!.validate();
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        key: Key('nazivTextField'),
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Naziv stanice',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 16),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Molimo unesite naziv';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      Container(
                        height: 50,
                        width: double.infinity,
                        child: DropdownButtonFormField<int>(
                          value: selectedCityId,
                          decoration: InputDecoration(
                            labelText: "Grad",
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 16),
                          ),
                          validator: (value) {
                            if (value == null) {
                              return 'Molimo odaberite grad';
                            }
                            return null;
                          },
                          items: [
                            DropdownMenuItem<int>(
                              value: null,
                              child: Text('Odaberi grad'),
                            ),
                            ...cities.map((city) {
                              return DropdownMenuItem<int>(
                                value: city.id,
                                child: Text(
                                  city.label,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                          ],
                          onChanged: (value) =>
                              setState(() => selectedCityId = value),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Odustani'),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          isFirstSubmit = true;
                          busStop.name = _nameController.text;
                          busStop.cityId = selectedCityId;
                          bool? result = false;
                          if (isEdit) {
                            result = await _busStopsProvider?.update(
                                busStop.id, busStop);
                          } else {
                            result = await _busStopsProvider?.insert(busStop);
                          }
                          if (result != null && result) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Podaci su uspješno spremljeni"),
                                backgroundColor: Colors.green,
                              ),
                            );
                            loadData("", 1, pageSize);
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "Dogodila se greška prilikom spremljanja podataka"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      child: Text('Spremi'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
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
                      EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  hintText: "Pretražite stanice...",
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
            Container(
              width: 250,
              child: DropdownButtonFormField<int>(
                value: searchCityId,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  labelText: 'Grad',
                ),
                isExpanded: true,
                onChanged: (value) => setState(() => searchCityId = value),
                items: [
                  DropdownMenuItem<int>(
                    value: null,
                    child: Text('Svi gradovi', overflow: TextOverflow.ellipsis),
                  ),
                  ...cities.map((city) {
                    return DropdownMenuItem<int>(
                      value: city.id,
                      child: Text(
                        city.label,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                searchFilter = _searchController.text;
                loadData(searchFilter, page, pageSize);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Pretraži'),
            ),
            SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: () {
                BusStop busStop = BusStop(id: 0, name: "");
                showAddEditModal(context, busStop, false);
              },
              icon: Icon(Icons.add, size: 18),
              label: Text('Dodaj stanicu'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
          columns: [
            DataColumn(
              label:
                  Text("Naziv", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label:
                  Text("Grad", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label:
                  Text("Akcije", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
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
    await _busStopsProvider?.deleteById(id);
    setState(() {
      currentPage = 1;
      loadData("", currentPage, pageSize);
      //paginatorKey.currentState?.dispose();
      paginatorKey = GlobalKey();
    });
  }
}
