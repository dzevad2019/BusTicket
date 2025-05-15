import 'package:bus_ticket_admin/models/listItem.dart';
import 'package:bus_ticket_admin/models/notification.dart';
import 'package:bus_ticket_admin/providers/enum_provider.dart';
import 'package:bus_ticket_admin/providers/notifications_provider.dart';
import 'package:bus_ticket_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';
import '../../enums/enums.dart';
import '../../utils/colorized_text_avatar.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({Key? key}) : super(key: key);

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  NotificationsProvider? _notificationsProvider;
  EnumProvider? _enumProvider;
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<NumberPaginatorState> paginatorKey = GlobalKey();

  List<NotificationData> data = [];
  List<ListItem> busLines = [];
  int page = 1;
  int pageSize = 10;
  int totalRecordCounts = 0;
  int numberOfPages = 1;
  int currentPage = 1;

  bool isLoading = true;
  bool isFirstSubmit = false;
  int? _selectedLineId;
  int? _selectedSearchLineId;
  late DateTime _selectedDate;
  final _messageController = TextEditingController();
  int? companyId = null;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _notificationsProvider = context.read<NotificationsProvider>();
    _enumProvider = context.read<EnumProvider>();
    loadBusLines();
    loadData("", page, pageSize);
  }

  Future<void> loadData(searchFilter, page, pageSize) async {
    try {
      if (searchFilter != '') page = 1;

      var params = {
        //'SearchFilter': searchFilter,
        'PageNumber': page.toString(),
        'PageSize': pageSize.toString(),
      };

      if (_selectedSearchLineId != null) {
        params['BusLineId'] = _selectedSearchLineId.toString();
      }

      var response = await (_notificationsProvider?.getForPagination(params) ??
          Future.value(null));

      if (response == null) {
        throw Exception('No response from provider');
      }

      setState(() {
        data = response.items ?? [];
        totalRecordCounts = response.totalCount ?? 0;
        numberOfPages = ((totalRecordCounts - 1) / pageSize).toInt() + 1;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error loading data: $e');
    }
  }

  Future loadBusLines() async {
    var response = await _enumProvider!.getEnumItems("Bus-Lines");
    setState(() {
      busLines = response;
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

  DataRow recentDataRow(NotificationData notification, BuildContext context) {
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
                text: notification.busLineName ?? '',
              ),
              const SizedBox(width: 12),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    notification.busLineName ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        DataCell(
          Tooltip(
            message: notification.message.toString(),
            child: Text(
              notification.message.toString().substring(0, notification.message.length > 80 ? 80 : notification.message.length) +
                  (notification.message.length > 80 ? '...' : ''),
              style: TextStyle(
                color: Colors.grey[700],
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ),
        DataCell(
          Text(
            DateFormat("dd.MM.yyyy").format(notification.departureDateTime!),
            style: TextStyle(
              color: Colors.grey[700],
            ),
          ),
        ),
        DataCell(
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            tooltip: 'Obriši',
            onPressed: () => showDeleteModal(context, notification),
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
          "Notifikacije",
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

  void showDeleteModal(BuildContext context, NotificationData notification) {
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
        content: Text("Da li ste sigurni da želite obrisati notifikaciju?"),
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
              await deleteById(notification.id);
              await loadData("", 1, pageSize);
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
            //Expanded(
            //  child: TextField(
            //    controller: _searchController,
            //    decoration: InputDecoration(
            //      contentPadding:
            //      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            //      hintText: "Pretražite vozila...",
            //      prefixIcon: const Icon(Icons.search),
            //      border: OutlineInputBorder(
            //        borderRadius: BorderRadius.circular(8),
            //        borderSide: BorderSide(color: Colors.grey[300]!),
            //      ),
            //      filled: true,
            //      fillColor: Colors.grey[50],
            //    ),
            //  ),
            //),
            //SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: DropdownButtonFormField<int>(
                value: _selectedSearchLineId,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  labelText: 'Autobuske linije',
                ),
                isExpanded: true,
                onChanged: (value) =>
                    setState(() => _selectedSearchLineId = value),
                items: [
                  DropdownMenuItem<int>(
                    value: null,
                    child: Text('Sve autobuske linije',
                        overflow: TextOverflow.ellipsis),
                  ),
                  ...busLines.map((company) {
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
                loadData("", page, pageSize);
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
                showSendNotificationModal(context);
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Pošalji notifikaciju'),
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
                label: Text("Poruka",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text("Datum",
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
    await _notificationsProvider?.deleteById(id);
    setState(() {
      currentPage = 1;
      loadData("", currentPage, pageSize);
      //paginatorKey.currentState?.dispose();
      paginatorKey = GlobalKey();
    });
  }

  void showSendNotificationModal(BuildContext context) {
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
                      'Slanje notifikacije',
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DropdownButtonFormField<int>(
                        value: _selectedLineId,
                        items: busLines
                            .map((line) => DropdownMenuItem<int>(
                                  value: line.id,
                                  child: Text(line.label),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedLineId = value!;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Odaberite liniju';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Linija',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: () async {
                          final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime.now(),
                            lastDate:
                                DateTime.now().add(const Duration(days: 365)),
                          );
                          if (selectedDate != null) {
                            setState(() {
                              _selectedDate = selectedDate;
                            });
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Datum polaska',
                            border: OutlineInputBorder(),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(DateFormat('dd.MM.yyyy')
                                  .format(_selectedDate)),
                              const Icon(Icons.calendar_today),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          labelText: 'Poruka',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Unesite poruku';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _sendNotification,
                        child: const Text('Pošalji'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _sendNotification() async {
    if (_formKey.currentState!.validate()) {
      final notificationData = NotificationData(
        id: 0,
        busLineId: _selectedLineId!,
        departureDateTime: _selectedDate,
        message: _messageController.text,
      );

      final success = await _notificationsProvider!.insert(notificationData);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notifikacija uspešno poslata'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
        loadData("", 1, pageSize);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Greška pri slanju notifikacije'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
