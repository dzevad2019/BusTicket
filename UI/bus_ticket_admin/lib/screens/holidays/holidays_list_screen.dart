import 'package:bus_ticket_admin/models/holiday.dart';
import 'package:bus_ticket_admin/providers/holidays_provider.dart';
import 'package:bus_ticket_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';

class HolidayListScreen extends StatefulWidget {
  static const String routeName = "holidays";

  const HolidayListScreen({Key? key}) : super(key: key);

  @override
  State<HolidayListScreen> createState() => _HolidayListScreenState();
}

class _HolidayListScreenState extends State<HolidayListScreen> {
  HolidaysProvider? _holidayProvider;
  TextEditingController _searchController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  DateTime? _selectedDate;
  GlobalKey<NumberPaginatorState> paginatorKey = GlobalKey();
  List<Holiday> data = [];
  int page = 1;
  int pageSize = 10;
  int totalRecordCounts = 0;
  String searchFilter = '';
  bool isLoading = true;
  int numberOfPages = 1;
  int currentPage = 1;
  final _formKey = GlobalKey<FormState>();
  bool isFirstSubmit = false;

  @override
  void initState() {
    super.initState();
    _holidayProvider = context.read<HolidaysProvider>();
    loadData(searchFilter, page, pageSize);
  }

  Future loadData(searchFilter, page, pageSize) async {
    if (searchFilter != '') page = 1;

    var response = await _holidayProvider?.getForPagination({
      'SearchFilter': searchFilter,
      'PageNumber': page.toString(),
      'PageSize': pageSize.toString()
    });

    setState(() {
      data = response?.items ?? [];
      totalRecordCounts = response?.totalCount ?? 0;
      numberOfPages = ((totalRecordCounts - 1) / pageSize).toInt() + 1;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
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

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Upravljanje praznicima",
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
                  hintText: "Pretražite praznike...",
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
                _nameController.clear();
                _selectedDate = null;
                showAddEditModal(context,
                    Holiday(id: 0, name: "", date: DateTime.now()), false);
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Dodaj praznik'),
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
                label: Text("Naziv",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text("Datum",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text("Akcije",
                    style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: data.map((holiday) => _buildDataRow(holiday)).toList(),
        ),
      ),
    );
  }

  DataRow _buildDataRow(Holiday holiday) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            holiday.name,
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        DataCell(
          Text(
            "${holiday.date.toLocal()}".split(' ')[0],
            style: TextStyle(
              color: Colors.grey[700],
            ),
          ),
        ),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                tooltip: 'Uredi',
                onPressed: () {
                  _nameController.text = holiday.name;
                  _selectedDate = holiday.date;
                  showAddEditModal(context, holiday, true);
                },
              ),
              const SizedBox(width: 4),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                tooltip: 'Obriši',
                onPressed: () => _showDeleteDialog(holiday),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog(Holiday holiday) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 12),
            Text("Potvrda brisanja"),
          ],
        ),
        content: Text(
            "Da li ste sigurni da želite obrisati praznik ${holiday.name}?"),
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
              await _holidayProvider?.deleteById(holiday.id);
              await loadData("", 1, pageSize);
              Navigator.pop(context);
            },
            child: const Text("Obriši"),
          ),
        ],
      ),
    );
  }

  void showAddEditModal(BuildContext context, Holiday holiday, bool isEdit) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
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
                        isEdit ? "Uredi praznik" : "Dodaj praznik",
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
                    key: _formKey,
                    onChanged: () {
                      if (isFirstSubmit) _formKey.currentState!.validate();
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Naziv praznika',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 16),
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Unesite naziv praznika'
                              : null,
                        ),
                        SizedBox(height: 16),
                        InkWell(
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: _selectedDate ??
                                  DateTime.now().add(Duration(days: 1)),
                              firstDate: DateTime.now().add(Duration(days: 1)),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setState(() {
                                _selectedDate = picked;
                              });
                            }
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Datum',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _selectedDate == null
                                      ? "Odaberite datum"
                                      : "${_selectedDate!.toLocal()}"
                                          .split(' ')[0],
                                ),
                                Icon(Icons.calendar_today),
                              ],
                            ),
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
                        onPressed: () => Navigator.pop(context),
                        child: Text('Odustani'),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          saveData(holiday, isEdit, context);
                        },
                        child: Text('Spremi'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  void saveData(holiday, isEdit, modalContext) async {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      holiday.name = _nameController.text;
      holiday.date = _selectedDate!;
      bool? result = isEdit
          ? await _holidayProvider?.update(holiday.id, holiday)
          : await _holidayProvider?.insert(holiday);

      if (result == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Podaci su uspješno spremljeni"),
            backgroundColor: Colors.green,
          ),
        );
        await loadData("", 1, pageSize);
        Navigator.pop(modalContext);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Dogodila se greška prilikom spremljanja podataka"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
}
