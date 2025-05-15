import 'package:bus_ticket_admin/models/user_upsert_model.dart';
import 'package:bus_ticket_admin/providers/users_provider.dart';
import 'package:bus_ticket_admin/screens/tickets/tickets_list_screen.dart';
import 'package:bus_ticket_admin/screens/users/user_add_screen.dart';
import 'package:bus_ticket_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';

class UserListScreen extends StatefulWidget {
  static const String routeName = "users";

  const UserListScreen({Key? key}) : super(key: key);

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  UsersProvider? _userProvider;
  final TextEditingController _searchController = TextEditingController();
  GlobalKey<NumberPaginatorState> paginatorKey = GlobalKey();

  List<UserUpsertModel> data = [];
  int page = 1;
  int pageSize = 10;
  int totalRecordCounts = 0;
  int numberOfPages = 1;
  int currentPage = 1;

  bool isLoading = true;
  String searchFilter = '';

  @override
  void initState() {
    super.initState();
    _userProvider = context.read<UsersProvider>();
    loadData(searchFilter, page, pageSize);
  }

  Future loadData(searchFilter, page, pageSize) async {
    if (searchFilter != '') page = 1;

    var response = await _userProvider?.getForPagination({
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

  DataRow recentDataRow(UserUpsertModel user, BuildContext context) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue[800],
                child: Text(
                  "${user.firstName[0]}${user.lastName[0]}",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${user.firstName} ${user.lastName}",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    user.email,
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
            user.address,
            style: TextStyle(
              color: Colors.grey[700],
            ),
          ),
        ),
        DataCell(
          Text(
            _roleToString(user.userRoles?.first?.roleId ?? 1),
            style: TextStyle(
              color: Colors.grey[700],
            ),
          ),
        ),
        DataCell(
          Text(
            user.phoneNumber,
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
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => UserAddScreen(userId: user.id),
                    ),
                  );
                  await loadData(searchFilter, 1, pageSize);
                },
              ),
              const SizedBox(width: 4),
              IconButton(
                icon: Icon(Icons.qr_code, color: Colors.blue),
                tooltip: 'Karte',
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TicketListScreen(userId: user.id),
                    ),
                  );
                  await loadData(searchFilter, 1, pageSize);
                },
              ),
              const SizedBox(width: 4),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                tooltip: 'Obriši',
                onPressed: () => showDeleteModal(context, user),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _roleToString(int roleId) {
    switch (roleId) {
      case 1:
        return 'Administrator';
      case 2:
        return 'Klijent';
      default:
        return 'Klijent';
    }
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Upravljanje korisnicima",
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

  void showDeleteModal(BuildContext context, UserUpsertModel user) {
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
            "Da li ste sigurni da želite obrisati korisnika ${user.firstName} ${user.lastName}?"),
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
              await deleteById(user.id!);
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
                  hintText: "Pretražite korisnike...",
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
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => UserAddScreen(),
                  ),
                );
                await loadData(searchFilter, 1, pageSize);
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Dodaj korisnika'),
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
                label: Text("Korisnik",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text("Adresa",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text("Uloga",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text("Telefon",
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
    await _userProvider?.deleteById(id);
    setState(() {
      currentPage = 1;
      loadData("", currentPage, pageSize);
      //paginatorKey.currentState?.dispose();
      paginatorKey = GlobalKey();
    });
  }
}
