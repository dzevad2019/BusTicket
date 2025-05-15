import 'package:bus_ticket_admin/models/listItem.dart';
import 'package:bus_ticket_admin/models/vehicle.dart';
import 'package:bus_ticket_admin/providers/enum_provider.dart';
import 'package:bus_ticket_admin/providers/vehicles_provider.dart';
import 'package:bus_ticket_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';
import '../../enums/enums.dart';
import '../../utils/colorized_text_avatar.dart';

class VehicleListScreen extends StatefulWidget {
  const VehicleListScreen({Key? key}) : super(key: key);

  @override
  State<VehicleListScreen> createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> {
  VehiclesProvider? _vehiclesProvider;
  EnumProvider? _enumProvider;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _registrationController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<NumberPaginatorState> paginatorKey = GlobalKey();

  List<Vehicle> data = [];
  List<ListItem> companies = [];
  int page = 1;
  int pageSize = 10;
  int totalRecordCounts = 0;
  int numberOfPages = 1;
  int currentPage = 1;

  bool isLoading = true;
  bool isFirstSubmit = false;
  String searchFilter = '';
  int? searchCompanyId;
  VehicleType? selectedVehicleType;
  Vehicle? vehicle;
  int? companyId = null;

  @override
  void initState() {
    super.initState();
    _vehiclesProvider = context.read<VehiclesProvider>();
    _enumProvider = context.read<EnumProvider>();
    loadCompanies();
    loadData(searchFilter, page, pageSize);
  }

  Future loadData(searchFilter, page, pageSize) async {
    if (searchFilter != '') page = 1;

    var response = await _vehiclesProvider?.getForPagination({
      'SearchFilter': searchFilter,
      'PageNumber': page.toString(),
      'PageSize': pageSize.toString(),
      'CompanyId': searchCompanyId?.toString() ?? '0'
    });

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

  DataRow recentDataRow(Vehicle vehicle, BuildContext context) {
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
                text: vehicle.name ?? '',
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    vehicle.name ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (vehicle.registration != null &&
                      vehicle.registration!.isNotEmpty)
                    Text(
                      vehicle.registration!,
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
            vehicle.capacity.toString(),
            style: TextStyle(
              color: Colors.grey[700],
            ),
          ),
        ),
        DataCell(
          Text(
            vehicle.company?.name ?? 'N/A',
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
                  this.vehicle = vehicle;
                  showAddEditVehicleModal(context, vehicle, true);
                },
              ),
              const SizedBox(width: 4),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                tooltip: 'Obriši',
                onPressed: () => showDeleteModal(context, vehicle),
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
          "Upravljanje vozilima",
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

  void showDeleteModal(BuildContext context, Vehicle vehicle) {
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
            "Da li ste sigurni da želite obrisati vozilo ${vehicle.name}?"),
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
              await deleteById(vehicle.id);
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
                  hintText: "Pretražite vozila...",
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
                Vehicle vehicle = Vehicle(
                    id: 0,
                    name: "",
                    capacity: 0,
                    registration: "",
                    type: VehicleType.bus,
                    company: null,
                    companyId: null);
                showAddEditVehicleModal(context, vehicle, false);
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Dodaj vozilo'),
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
                label: Text("Vozilo",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text("Kapacitet",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text("Kompanija",
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
    await _vehiclesProvider?.deleteById(id);
    setState(() {
      currentPage = 1;
      loadData("", currentPage, pageSize);
      //paginatorKey.currentState?.dispose();
      paginatorKey = GlobalKey();
    });
  }

  void showAddEditVehicleModal(
      BuildContext context, Vehicle vehicle, bool isEdit) {
    _nameController.text = vehicle.name ?? '';
    _registrationController.text = vehicle.registration ?? '';
    _capacityController.text = vehicle.capacity.toString();
    companyId = vehicle.companyId ?? companies.first.id;
    selectedVehicleType = vehicle.type ?? VehicleType.bus;

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
                      isEdit ? 'Uređivanje vozila' : 'Dodavanje vozila',
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Naziv',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 16),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Unesite naziv'
                            : null,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _registrationController,
                        decoration: InputDecoration(
                          labelText: 'Registracija',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 16),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Unesite registraciju'
                            : null,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _capacityController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Kapacitet',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 16),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Unesite kapacitet';
                          if (int.tryParse(value) == null)
                            return 'Kapacitet mora biti broj';
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      DropdownButtonFormField<int>(
                        value: companyId,
                        decoration: InputDecoration(
                          labelText: 'Kompanija',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) =>
                            setState(() => companyId = value!),
                        items: companies.map((company) {
                          return DropdownMenuItem<int>(
                            value: company.id,
                            child: Text(company.label),
                          );
                        }).toList(),
                        validator: (value) =>
                            value == null ? 'Odaberite kompaniju' : null,
                      ),
                      SizedBox(height: 16),
                      DropdownButtonFormField<VehicleType>(
                        value: selectedVehicleType,
                        decoration: InputDecoration(
                          labelText: 'Tip vozila',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 16),
                        ),
                        onChanged: (value) =>
                            setState(() => selectedVehicleType = value!),
                        items: VehicleType.values.map((type) {
                          return DropdownMenuItem<VehicleType>(
                            value: type,
                            child: Text(type.name.toUpperCase()),
                          );
                        }).toList(),
                        validator: (value) =>
                            value == null ? 'Odaberite tip vozila' : null,
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
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          vehicle.name = _nameController.text;
                          vehicle.registration = _registrationController.text;
                          vehicle.capacity =
                              int.tryParse(_capacityController.text) ?? 0;
                          vehicle.companyId = companyId!;
                          vehicle.type = selectedVehicleType!;

                          bool? result;
                          if (isEdit) {
                            result = await _vehiclesProvider?.update(
                                vehicle.id, vehicle);
                          } else {
                            result = await _vehiclesProvider?.insert(vehicle);
                          }

                          if (result != null && result) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Podaci su uspješno spremljeni"),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pop(context);
                            loadData("", 1, pageSize);
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
}
