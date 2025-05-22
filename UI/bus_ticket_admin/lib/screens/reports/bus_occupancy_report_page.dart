import 'package:bus_ticket_admin/models/listItem.dart';
import 'package:bus_ticket_admin/providers/enum_provider.dart';
import 'package:bus_ticket_admin/providers/reports_provider.dart';
import 'package:bus_ticket_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';

class BusOccupancyReportPage extends StatefulWidget {
  const BusOccupancyReportPage({Key? key}) : super(key: key);

  @override
  _BusOccupancyReportPageState createState() => _BusOccupancyReportPageState();
}

class _BusOccupancyReportPageState extends State<BusOccupancyReportPage> {
  List<ListItem> companies = [];
  ListItem? selectedCompany;
  DateTime? fromDate;
  DateTime? toDate;
  bool isLoading = false;

  bool _companyValid = true;
  bool _fromDateValid = true;
  bool _toDateValid = true;
  String _dateRangeError = '';

  late final EnumProvider _enumProvider;
  late final ReportsProvider _reportsProvider;

  @override
  void initState() {
    super.initState();
    _enumProvider = context.read<EnumProvider>();
    _reportsProvider = context.read<ReportsProvider>();
    _loadCompanies();
  }

  Future<void> _loadCompanies() async {
    final response = await _enumProvider.getEnumItems("Companies");
    if (mounted) {
      setState(() => companies = response ?? []);
    }
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && mounted) {
      setState(() {
        fromDate = picked;
        _fromDateValid = true;
        _validateDateRange();
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && mounted) {
      setState(() {
        toDate = picked;
        _toDateValid = true;
        _validateDateRange();
      });
    }
  }

  void _validateDateRange() {
    if (fromDate != null && toDate != null && fromDate!.isAfter(toDate!)) {
      setState(() {
        _dateRangeError = 'Datum "od" ne može biti nakon datuma "do"';
        _fromDateValid = false;
        _toDateValid = false;
      });
    } else {
      setState(() {
        _dateRangeError = '';
      });
    }
  }

  bool _validateForm() {
    bool isValid = true;

    // Reset validation states
    setState(() {
      _fromDateValid = fromDate != null;
      _toDateValid = toDate != null;
    });

    // Validate dates
    if (fromDate == null) {
      setState(() => _fromDateValid = false);
      isValid = false;
    }
    if (toDate == null) {
      setState(() => _toDateValid = false);
      isValid = false;
    }

    // Validate date range
    if (fromDate != null && toDate != null && fromDate!.isAfter(toDate!)) {
      setState(() {
        _dateRangeError = 'Datum "od" ne može biti nakon datuma "do"';
        _fromDateValid = false;
        _toDateValid = false;
      });
      isValid = false;
    }

    return isValid;
  }

  Future<void> _downloadReport() async {
    if (!_validateForm()) {
      return;
    }

    setState(() => isLoading = true);

    try {
      final filePath = await _reportsProvider.busOccupancy(selectedCompany?.id, fromDate!, toDate!);

      // Open the file
      final result = await OpenFile.open(filePath);

      if (result.type != ResultType.done) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
              Text('Greška pri otvaranju datoteke: ${result.message}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Izvještaj uspješno preuzet')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Greška pri preuzimanju: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<ListItem>(
                      value: selectedCompany,
                      decoration: InputDecoration(
                        labelText: 'Kompanija',
                        border: const OutlineInputBorder(),
                        errorText: !_companyValid ? 'Molimo odaberite kompaniju' : null,
                      ),
                      items: [
                        const DropdownMenuItem(
                            value: null, child: Text('Sve kompanije')),
                        ...companies.map((company) {
                          return DropdownMenuItem(
                            value: company,
                            child: Text(company.label ?? 'Nepoznato'),
                          );
                        }).toList(),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedCompany = value;
                          _companyValid = true;
                        });
                      },
                    ),
                    if (!_companyValid)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0, left: 12.0),
                        child: Text(
                          'Molimo odaberite kompaniju',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () => _selectFromDate(context),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Datum od',
                                border: const OutlineInputBorder(),
                                errorText: !_fromDateValid ? ' ' : null,
                              ),
                              child: Text(
                                fromDate != null
                                    ? DateFormat('dd.MM.yyyy').format(fromDate!)
                                    : 'Odaberite datum',
                              ),
                            ),
                          ),
                          if (!_fromDateValid)
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0, left: 12.0),
                              child: Text(
                                'Molimo odaberite datum',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () => _selectToDate(context),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Datum do',
                                border: const OutlineInputBorder(),
                                errorText: !_toDateValid ? ' ' : null,
                              ),
                              child: Text(
                                toDate != null
                                    ? DateFormat('dd.MM.yyyy').format(toDate!)
                                    : 'Odaberite datum',
                              ),
                            ),
                          ),
                          if (!_toDateValid)
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0, left: 12.0),
                              child: Text(
                                'Molimo odaberite datum',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (_dateRangeError.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, left: 12.0),
                    child: Text(
                      _dateRangeError,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 12,
                      ),
                    ),
                  ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: isLoading ? null : _downloadReport,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.deepPurple
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Generiši izvještaj', style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          ),
        );
  }
}