import 'package:bus_ticket_admin/models/bus_line_segment.dart';
import 'package:bus_ticket_admin/models/listItem.dart';
import 'package:bus_ticket_admin/models/notification_data.dart';
import 'package:bus_ticket_admin/providers/enum_provider.dart';
import 'package:bus_ticket_admin/providers/notifications_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NotificationSenderPage extends StatefulWidget {
  const NotificationSenderPage({
    Key? key,
  }) : super(key: key);

  @override
  _NotificationSenderPageState createState() => _NotificationSenderPageState();
}

class _NotificationSenderPageState extends State<NotificationSenderPage> {
  final _formKey = GlobalKey<FormState>();
  int? _selectedLineId;
  late DateTime _selectedDate;
  final _messageController = TextEditingController();

  NotificationsProvider? _notificationService;
  EnumProvider? _enumProvider;
  List<ListItem> _availableLines = [];

  @override
  void initState() {
    super.initState();
    _notificationService = context.read<NotificationsProvider>();
    _enumProvider = context.read<EnumProvider>();
    _selectedDate = DateTime.now();
    fetchData();
  }

  void fetchData(){
    _loadBusLines();
  }

  Future _loadBusLines() async {
    var response = await _enumProvider?.getEnumItems("Bus-Lines");
    setState(() {
      _availableLines = response ?? [];
      _selectedLineId = response?.first?.id ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pošalji Notifikaciju'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<int>(
                value: _selectedLineId,
                items: _availableLines
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
                    lastDate: DateTime.now().add(const Duration(days: 365)),
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
                      Text(DateFormat('dd.MM.yyyy').format(_selectedDate)),
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
                child: const Text('Pošalji Notifikaciju'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sendNotification() async {
    if (_formKey.currentState!.validate()) {
      final notificationData = NotificationData(
        lineId: _selectedLineId!,
        departureDate: _selectedDate,
        message: _messageController.text,
      );

      final success = true; // await widget.notificationService.sendNotification(notificationData);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notifikacija uspešno poslata')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Greška pri slanju notifikacije')),
        );
      }
    }
  }
}