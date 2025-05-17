import 'package:bus_ticket_admin/enums/enums.dart';
import 'package:bus_ticket_admin/models/bus_line.dart';
import 'package:bus_ticket_admin/models/bus_line_discount.dart';
import 'package:bus_ticket_admin/models/bus_line_segment.dart';
import 'package:bus_ticket_admin/models/bus_line_segment_price.dart';
import 'package:bus_ticket_admin/models/bus_line_vehicle.dart';
import 'package:bus_ticket_admin/models/listItem.dart';
import 'package:bus_ticket_admin/providers/bus_lines_provider.dart';
import 'package:bus_ticket_admin/providers/enum_provider.dart';
import 'package:bus_ticket_admin/screens/bus_lines/bus_lines_list_screen.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddEditBusLinePage extends StatefulWidget {
  final int? busLineId;

  const AddEditBusLinePage({this.busLineId, Key? key}) : super(key: key);

  @override
  State<AddEditBusLinePage> createState() => _AddEditBusLinePageState();
}

class _AddEditBusLinePageState extends State<AddEditBusLinePage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _priceFormKey = GlobalKey<FormState>();
  final _vehicleFormKey = GlobalKey<FormState>();
  late final TabController _tabController;
  late final EnumProvider _enumProvider;
  late final BusLinesProvider _busLinesProvider;
  late final ScrollController _verticalScrollController;
  late final ScrollController _horizontalScrollController;

  final TextEditingController _nameController =
  TextEditingController(text: '');
  final TextEditingController _departureTimeController =
  TextEditingController(text: '08:00');
  final TextEditingController _arrivalTimeController =
  TextEditingController(text: '09:00');

  bool _isActive = true;
  List<ListItem> companies = [];
  List<ListItem> vehicles = [];
  List<ListItem> busStops = [];
  List<ListItem> discounts = [];

  List<BusLineVehicle> selectedVehicles = [];

  int? selectedStopId;
  int? selectedDiscountId;
  int? selectedCompanyId;

  ListItem? _selectedVehicle;

  int busLineSegmentFakeId = 0;

  late BusLine _busLine = new BusLine(
      id: 0,
      name: "",
      //departureTime: "08:00",
      //arrivalTime: "09:00",
      active: true,
      segments: [],
      discounts: [],
      vehicles: []);

  bool loading = false;

  Set<OperatingDays> _selectedDays = {};

  bool get _isAllWeekdaysSelected =>
      _selectedDays.contains(OperatingDays.monday) &&
          _selectedDays.contains(OperatingDays.tuesday) &&
          _selectedDays.contains(OperatingDays.wednesday) &&
          _selectedDays.contains(OperatingDays.thursday) &&
          _selectedDays.contains(OperatingDays.friday);

  bool get _isAllWeekendSelected =>
      _selectedDays.contains(OperatingDays.saturday) &&
          _selectedDays.contains(OperatingDays.sunday);

  bool get _isAllDaysSelected =>
      _selectedDays.length == OperatingDays.values.length;

  @override
  void initState() {
    super.initState();
    _enumProvider = context.read<EnumProvider>();
    _busLinesProvider = context.read<BusLinesProvider>();
    _tabController = TabController(length: 5, vsync: this);
    _verticalScrollController = ScrollController();
    _horizontalScrollController = ScrollController();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      loading = true;
    });
    await Future.wait(
        [_loadCompanies(), _loadBusStops(), _loadDiscounts(), _loadBusLine()]);
    setState(() {
      loading = false;
    });
  }

  Future<void> _loadBusLine() async {
    if (widget.busLineId != null) {
      var response = await _busLinesProvider.getById(widget.busLineId!, null);
      setState(() {
        response.vehicles ??= [];
        response.segments ??= [];
        response.discounts ??= [];
        _busLine = response;
        _nameController.text = _busLine.name;
        _departureTimeController.text =
            _busLine.segments.first.departureTime.toString() ?? "N/A";
        _arrivalTimeController.text =
            _busLine.segments.last.departureTime.toString() ?? "N/A";
        _isActive = _busLine.active;
        _selectedDays = getSelectedDaysFromBitmask(_busLine.operatingDays);
      });
    }

    setState(() {
      selectedCompanyId = _busLine?.vehicles?.firstOrNull?.vehicle?.companyId;
    });
    await _loadVehicles(
        companyId: _busLine?.vehicles?.firstOrNull?.vehicle?.companyId);
  }

  Future<void> _loadDiscounts() async {
    final response = await _enumProvider.getEnumItems("Discounts");
    if (mounted) {
      setState(() => discounts = response ?? []);
    }
  }

  Future<void> _loadCompanies() async {
    final response = await _enumProvider.getEnumItems("Companies");
    if (mounted) {
      setState(() => companies = response ?? []);
    }
  }

  Future<void> _loadVehicles({int? companyId = null}) async {
    var query = companyId != null ? "?CompanyId=${companyId.toString()}" : "";
    final response = await _enumProvider.getEnumItems("Vehicles" + query);
    if (mounted) {
      setState(() => vehicles = response ?? []);
    }
  }

  Future<void> _loadBusStops() async {
    final response = await _enumProvider.getEnumItems("Bus-Stops");
    if (mounted) {
      setState(() => busStops = response ?? []);
    }
  }

  void _addStop() {
    if (selectedStopId == null) return;

    final alreadyExists =
    _busLine.segments.any((s) => s.busStopId == selectedStopId);
    if (alreadyExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Stajalište je već dodano.',
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    var newBusSegment = BusLineSegment(
        id: 0, busStopId: selectedStopId!, busLineId: _busLine.id);

    if (_busLine.segments.isNotEmpty) {
      var departureTime = _timeFromString(
          _busLine.segments[_busLine.segments.length - 1].departureTime ??
              "00:00");
      newBusSegment.departureTime =
          _formatTime(addMinutesToTimeOfDay(departureTime, 30));
    } else {
      newBusSegment.departureTime = "08:00";
    }

    setState(() {
      _busLine.segments.add(newBusSegment);
    });
  }

  void _removeStop(ListItem stop) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Potvrda brisanja"),
        content: Text(
            "Da li ste sigurni da želite ukloniti stajalište '${stop.label}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Otkaži"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _busLine.segments
                  .removeWhere((bs) => bs.busStopId == stop.id));
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Ukloni"),
          ),
        ],
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex--;
      final stop = _busLine.segments.removeAt(oldIndex);
      _busLine.segments.insert(newIndex, stop);

      _busLine.segments.asMap().forEach((index, segment) {
        segment.stopOrder = index + 1;
      });
    });
  }

  bool _validatePricing() {
    final segments = _busLine.segments;
    final lastIndex = segments.length - 1;

    return segments.asMap().entries.every((entry) {
      final idx = entry.key;
      final prices = entry.value.prices;

      if (idx != lastIndex) {
        if (prices == null || prices.isEmpty) return false;
      }

      if (prices != null && prices.isNotEmpty) {
        if (prices.any((p) =>
        (p.oneWayTicketPrice ?? 0) <= 0 ||
            (p.returnTicketPrice ?? 0) <= 0
        )) {
          return false;
        }
      }

      return true;
    });
  }


  void _saveBusLine() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_nameController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Naziv linije je obavezno polje"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_busLine.segments.isEmpty || _busLine.segments.length < 2){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Autobuska linija mora imati najmanje dvije stanice"),
          backgroundColor: Colors.red,
        ),
      );
      _tabController.animateTo(1);
      return;
    }

    if (_validatePricing() == false || _priceFormKey.currentState?.validate() == false) {
      _tabController.animateTo(2);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Cijene moraju biti veće od 0"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_busLine.vehicles.isEmpty) {
      _tabController.animateTo(4);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Potrebno je da odaberete kompaniju i vozila koja će obavljati ovu liniju"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_vehicleFormKey.currentState?.validate() == false) {
      _tabController.animateTo(4);
      return;
    }

    _busLine.name = _nameController.text;
    //_busLine.arrivalTime = _arrivalTimeController.text;
    //_busLine.departureTime = _departureTimeController.text;
    _busLine.active = _isActive;
    _busLine.operatingDays = getBitmaskFromSelectedDays(_selectedDays);

    _busLine.segments.asMap().forEach((index, value) {
      value.stopOrder = index + 1;
      value.id = value.id < 0 ? 0 : value.id;
      value.busLineSegmentType = index == 0
          ? BusLineSegmentType.departure
          : index == _busLine.segments.length - 1
          ? BusLineSegmentType.arrival
          : BusLineSegmentType.middle;

      value.prices?.asMap().forEach((index, pr) {
        pr.busLineSegmentFromId =
        pr.busLineSegmentFromId < 0 ? 0 : pr.busLineSegmentFromId;
        pr.busLineSegmentToId =
        pr.busLineSegmentToId < 0 ? 0 : pr.busLineSegmentToId;
      });

    });

    bool status = false;
    if (_busLine.id == 0) {
      status = await _busLinesProvider.insert(_busLine);
    } else {
      status = await _busLinesProvider.update(_busLine.id, _busLine);
    }

    if (status) {
      //Navigator.pop(context);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BusLineListScreen(),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Podaci su uspješno spremljeni"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Dogodila se greška prilikom spremljanja podataka"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _selectTime(BuildContext context,
      {required bool isDeparture}) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formattedTime =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      setState(() {
        if (isDeparture) {
          _departureTimeController.text = formattedTime;
        } else {
          _arrivalTimeController.text = formattedTime;
        }
      });
    }
  }

  Widget _buildDayChip(String label, OperatingDays day) {
    final isSelected = _selectedDays.contains(day);
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) => _toggleDay(day, selected),
      selectedColor: Colors.blue.withOpacity(0.2),
      checkmarkColor: Colors.blue,
      labelStyle: TextStyle(
        color: isSelected ? Colors.blue : Colors.grey[700],
      ),
    );
  }

  void _toggleDay(OperatingDays day, bool selected) {
    setState(() {
      if (selected) {
        _selectedDays.add(day);
      } else {
        _selectedDays.remove(day);
      }
    });
  }

  void _selectWeekdays() {
    setState(() {
      final weekdays = {
        OperatingDays.monday,
        OperatingDays.tuesday,
        OperatingDays.wednesday,
        OperatingDays.thursday,
        OperatingDays.friday,
      };

      final allSelected = weekdays.every(_selectedDays.contains);

      if (allSelected) {
        _selectedDays.removeAll(weekdays);
      } else {
        _selectedDays.addAll(weekdays);
      }
    });
  }

  void _selectWeekend() {
    setState(() {
      final weekend = {
        OperatingDays.saturday,
        OperatingDays.sunday,
      };

      final allSelected = weekend.every(_selectedDays.contains);

      if (allSelected) {
        _selectedDays.removeAll(weekend);
      } else {
        _selectedDays.addAll(weekend);
      }
    });
  }

  void _selectAllDays() {
    setState(() {
      if (_selectedDays.length == OperatingDays.values.length) {
        _selectedDays.clear();
      } else {
        _selectedDays.addAll(OperatingDays.values);
      }
    });
  }

  Widget _buildBasicTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    "Osnovne informacije",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Naziv linije',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.directions_bus),
                          ),
                          validator: (value) => value?.isEmpty ?? true
                              ? "Ovo polje je obavezno"
                              : null,
                        ),
                      ),
                    ],
                  ),
                  //const SizedBox(height: 20),
                  //Row(
                  //  children: [
                  //    Expanded(
                  //      child: InkWell(
                  //        onTap: () => _selectTime(context, isDeparture: true),
                  //        child: InputDecorator(
                  //          decoration: const InputDecoration(
                  //            labelText: 'Vrijeme polaska',
                  //            border: OutlineInputBorder(),
                  //            prefixIcon: Icon(Icons.access_time),
                  //          ),
                  //          child: Text(
                  //            _departureTimeController.text.isEmpty
                  //                ? 'Odaberite vrijeme'
                  //                : _departureTimeController.text,
                  //          ),
                  //        ),
                  //      ),
                  //    ),
                  //    const SizedBox(width: 20),
                  //    Expanded(
                  //      child: InkWell(
                  //        onTap: () => _selectTime(context, isDeparture: false),
                  //        child: InputDecorator(
                  //          decoration: const InputDecoration(
                  //            labelText: 'Vrijeme dolaska',
                  //            border: OutlineInputBorder(),
                  //            prefixIcon: Icon(Icons.access_time),
                  //          ),
                  //          child: Text(
                  //            _arrivalTimeController.text.isEmpty
                  //                ? 'Odaberite vrijeme'
                  //                : _arrivalTimeController.text,
                  //          ),
                  //        ),
                  //      ),
                  //    ),
                  //  ],
                  //),

                  // Operating Days Section
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  const Text(
                    "Dani saobraćanja:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildDayChip("Ponedjeljak", OperatingDays.monday),
                      _buildDayChip("Utorak", OperatingDays.tuesday),
                      _buildDayChip("Srijeda", OperatingDays.wednesday),
                      _buildDayChip("Četvrtak", OperatingDays.thursday),
                      _buildDayChip("Petak", OperatingDays.friday),
                      _buildDayChip("Subota", OperatingDays.saturday),
                      _buildDayChip("Nedjelja", OperatingDays.sunday),
                      _buildDayChip("Praznici", OperatingDays.holidays),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 8,
                    children: [
                      Tooltip(
                        message: 'Toggle radni dani (Pon-Pet)',
                        child: ActionChip(
                          label: const Text("Radni dani"),
                          avatar: Icon(Icons.work, size: 18),
                          onPressed: _selectWeekdays,
                          backgroundColor: _isAllWeekdaysSelected
                              ? Colors.blue.withOpacity(0.2)
                              : null,
                        ),
                      ),
                      Tooltip(
                        message: 'Toggle vikend (Sub-Ned)',
                        child: ActionChip(
                          label: const Text("Vikend"),
                          avatar: Icon(Icons.weekend, size: 18),
                          onPressed: _selectWeekend,
                          backgroundColor: _isAllWeekendSelected
                              ? Colors.blue.withOpacity(0.2)
                              : null,
                        ),
                      ),
                      Tooltip(
                        message: 'Toggle svi dani',
                        child: ActionChip(
                          label: const Text("Svi dani"),
                          avatar: Icon(Icons.calendar_today, size: 18),
                          onPressed: _selectAllDays,
                          backgroundColor: _isAllDaysSelected
                              ? Colors.blue.withOpacity(0.2)
                              : null,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Status linije:",
                          style: TextStyle(fontSize: 16)),
                      Switch.adaptive(
                        value: _isActive,
                        onChanged: (v) => setState(() => _isActive = v),
                        activeColor: Colors.green,
                      ),
                      Text(
                        _isActive ? "Aktivna" : "Neaktivna",
                        style: TextStyle(
                          color: _isActive ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStopsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Upravljanje stajalištima",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownSearch<int>(
                          popupProps: PopupProps.menu(
                            showSearchBox: true,
                            searchFieldProps: const TextFieldProps(
                              decoration: InputDecoration(
                                  hintText: 'Pretraga stajališta'),
                            ),
                          ),
                          items: busStops.map((s) => s.id!).toList(),
                          itemAsString: (id) =>
                          busStops.firstWhere((s) => s.id == id).label,
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: const InputDecoration(
                              labelText: 'Stajalište',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          selectedItem: selectedStopId,
                          onChanged: (val) =>
                              setState(() => selectedStopId = val),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: _addStop,
                          child: const Text('Dodaj', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.deepPurple,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text("Redoslijed stajališta:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ReorderableListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      onReorder: _onReorder,
                      children: [
                        for (int index = 0;
                        index < _busLine.segments.length;
                        index++)
                          _buildStopListItem(_busLine.segments[index], index),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStopListItem(BusLineSegment segment, int index) {
    final busStop = busStops.firstWhere((bs) => bs.id == segment.busStopId);

    return Container(
      key: ValueKey(segment),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: ListTile(
        leading: const Icon(Icons.drag_handle),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(busStop.label),
            const SizedBox(height: 4),
            _buildDepartureTimePicker(segment, index),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () => _removeStop(busStop),
        ),
      ),
    );
  }

  Widget _buildDepartureTimePicker(BusLineSegment segment, int index) {
    return InkWell(
      onTap: () => _selectStopDepartureTime(segment, index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.access_time, size: 16, color: Colors.blue),
            const SizedBox(width: 4),
            Text(
              segment.departureTime ?? 'Odaberi vrijeme',
              style: TextStyle(
                color:
                segment.departureTime != null ? Colors.black : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectStopDepartureTime(
      BusLineSegment segment, int index) async {
    // Don't allow setting time for first segment (handled by busLine departureTime)
    if (index == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Vrijeme prvog stajališta se postavlja kao vrijeme polaska linije'),
          backgroundColor: Colors.blue,
        ),
      );
      return;
    }

    // Validate previous segment has time set
    if (_busLine.segments[index - 1].departureTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Postavite vrijeme za prethodno stajalište prvo'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final prevTime =
    _timeFromString(_busLine.segments[index - 1].departureTime!);

    // Get next segment time if exists and has time set
    TimeOfDay? nextTime;
    if (index < _busLine.segments.length - 1 &&
        _busLine.segments[index + 1].departureTime != null) {
      nextTime = _timeFromString(_busLine.segments[index + 1].departureTime!);
    }

    // Use current time or previous segment's time as initial
    final initialTime = segment.departureTime != null
        ? _timeFromString(segment.departureTime!)
        : prevTime;

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (picked != null) {
      // Validate time is after previous segment
      if (_compareTimes(picked, prevTime) <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Vrijeme mora biti poslije ${_formatTime(prevTime)}'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Validate time is before next segment (if exists and has time set)
      if (nextTime != null && _compareTimes(picked, nextTime) >= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Vrijeme mora biti prije ${_formatTime(nextTime)}'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        segment.departureTime = _formatTime(picked);
      });
    }
  }

  int _compareTimes(TimeOfDay a, TimeOfDay b) {
    final aMinutes = a.hour * 60 + a.minute;
    final bMinutes = b.hour * 60 + b.minute;
    return aMinutes.compareTo(bMinutes);
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  TimeOfDay _timeFromString(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  TimeOfDay addMinutesToTimeOfDay(TimeOfDay time, int minutesToAdd) {
    final now = DateTime.now();
    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    ).add(Duration(minutes: minutesToAdd));

    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }

  Widget _buildDicountsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Upravljanje popustima",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownSearch<int>(
                          popupProps: PopupProps.menu(
                            showSearchBox: true,
                            searchFieldProps: const TextFieldProps(
                              decoration:
                              InputDecoration(hintText: 'Pretraga popusta'),
                            ),
                          ),
                          items: discounts
                              .where((d) => !_busLine.discounts
                              .any((bd) => bd.discountId == d.id))
                              .map((s) => s.id!)
                              .toList(),
                          itemAsString: (id) =>
                          discounts.firstWhere((s) => s.id == id).label,
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: const InputDecoration(
                              labelText: 'Odaberi popust',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          onChanged: (val) =>
                              setState(() => selectedDiscountId = val),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(
                          Icons.add_circle,
                          color: selectedDiscountId == null
                              ? Colors.grey
                              : Colors.blue,
                          size: 32,
                        ),
                        onPressed: selectedDiscountId == null
                            ? null
                            : () {
                          setState(() {
                            _busLine.discounts.add(BusLineDiscount(
                                id: 0,
                                discountId: selectedDiscountId!,
                                busLineId: _busLine.id,
                                value: 0));
                            selectedDiscountId = null;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text("Popusti:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _busLine.discounts.length,
                      itemBuilder: (context, index) {
                        final discount = _busLine.discounts[index];
                        final discountInfo = discounts
                            .firstWhere((d) => d.id == discount.discountId);

                        return Container(
                          key: ValueKey(discount),
                          decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                BorderSide(color: Colors.grey.shade200)),
                          ),
                          child: ListTile(
                            title: Text(discountInfo.label),
                            subtitle: TextFormField(
                              //controller: _discountControllers[index],
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(
                                    r'^(100(\.0{0,2})?|([0-9]{1,2})(\.[0-9]{0,2})?)$')),
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'Unesite popust';
                                final numValue = double.tryParse(value);
                                if (numValue == null)
                                  return 'Unesite validan broj';
                                if (numValue < 0)
                                  return 'Popust ne može biti manji od 0';
                                if (numValue > 100)
                                  return 'Popust ne može biti veći od 100';
                                return null;
                              },
                              initialValue:
                              _busLine.discounts[index].value.toString(),
                              decoration: const InputDecoration(
                                labelText: 'Popust u %',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  final numValue = double.tryParse(value);
                                  if (numValue != null) {
                                    _busLine.discounts[index].value = numValue;
                                  }
                                }
                              },
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _busLine.discounts.removeAt(index);
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingMatrix() {
    return Form(
      key: _priceFormKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "Cjenovnik za liniju: ${_nameController.text}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Scrollbar(
              controller: _verticalScrollController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: _verticalScrollController,
                scrollDirection: Axis.vertical,
                child: Scrollbar(
                  controller: _horizontalScrollController,
                  thumbVisibility: true,
                  scrollbarOrientation: ScrollbarOrientation.bottom,
                  child: SingleChildScrollView(
                    controller: _horizontalScrollController,
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) =>
                            Theme.of(context).primaryColor.withOpacity(0.1),
                      ),
                      columnSpacing: 0,
                      dataRowMinHeight: 60,
                      dataRowMaxHeight: 120,
                      columns: [
                        const DataColumn(
                          label: SizedBox(
                            width: 100,
                            child: Text(
                              'Od \nDo',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        ..._busLine.segments.skip(1).map((stop) => DataColumn(
                          label: SizedBox(
                            width: 150,
                            child: Text(
                              busStops
                                  .firstWhere((bs) => bs.id == stop.busStopId)
                                  .label,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )),
                      ],
                      rows: _buildPricingRows(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<DataRow> _buildPricingRows() {
    return _busLine.segments
        .take(_busLine.segments.length - (_busLine.segments.isNotEmpty ? 1 : 0))
        .map((from) {
      from.id = from.id == 0 ? -from.busStopId : from.id;
      return DataRow(
        cells: [
          DataCell(
            SizedBox(
              width: 100,
              child: Text(
                busStops.firstWhere((bs) => bs.id == from.busStopId).label,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ...List.generate(_busLine.segments.indexOf(from),
                  (index) => const DataCell(Text(''))),
          ..._busLine.segments
              .skip(_busLine.segments.indexOf(from) + 1)
              .map((to) {
            to.id = to.id == 0 ? -to.busStopId : to.id;
            return DataCell(_buildPriceInputFields(from, to));
          }),
        ],
      );
    }).toList();
  }

  Widget _buildPriceInputFields(BusLineSegment from, BusLineSegment to) {
    final segment =
    _busLine.segments.firstWhere((bs) => bs.busStopId == from.busStopId);
    final price = segment.prices?.firstWhere(
          (bs) =>
      from.id != 0 &&
          to.id != 0 &&
          bs.busLineSegmentFromId == from.id &&
          bs.busLineSegmentToId == to.id,
      orElse: () => BusLineSegmentPrice(
          id: 0,
          //busLineSegmentFromId: from.id == 0 ? -segment.busStopId : from.id,
          //busLineSegmentToId: to.id == 0 ? -segment.busStopId : to.id,
          busLineSegmentFromId: from.id,
          busLineSegmentToId: to.id,
          oneWayTicketPrice: 0.0,
          returnTicketPrice: 0.0,
          newSegmentNewPrice: from.id == 0),
    );

    return Container(
      width: 150,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPriceField(
            label: "Jednosmjerna",
            initialValue: price?.oneWayTicketPrice.toString() ?? '0.0',
            onChanged: (val) => _updatePrice(from, to, val, isOneWay: true),
          ),
          const SizedBox(height: 4),
          _buildPriceField(
            label: "Povratna",
            initialValue: price?.returnTicketPrice.toString() ?? '0.0',
            onChanged: (val) => _updatePrice(from, to, val, isOneWay: false),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceField({
    required String label,
    required String initialValue,
    required ValueChanged<String> onChanged,
  }) {
    return SizedBox(
      height: 40,
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          border: const OutlineInputBorder(),
          isDense: true,
        ),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
        ],
        validator: (value) {
          final text = value?.trim();
          if (text == null || text.isEmpty) return 'Unesite cijenu';
          final price = double.tryParse(text);
          if (price == null) return 'Unesite validan broj';
          if (price <= 0) return 'Cijena mora biti veća od 0';
          return null;
        },
        initialValue: initialValue,
        onChanged: onChanged,
      ),
    );
  }

  void _updatePrice(BusLineSegment from, BusLineSegment to, String value,
      {required bool isOneWay}) {
    final busStop =
    _busLine.segments.firstWhere((bs) => bs.busStopId == from.busStopId);
    busStop.prices ??= [];

    final price = busStop.prices!.firstWhere(
          (p) => p.busLineSegmentFromId == from.id && p.busLineSegmentToId == to.id,
      orElse: () {
        final newPrice = BusLineSegmentPrice(
          id: 0,
          busLineSegmentFromId: from.id,
          busLineSegmentToId: to.id,
          oneWayTicketPrice: 0.0,
          returnTicketPrice: 0.0,
          newSegmentNewPrice: from.id == 0,
        );
        busStop.prices!.add(newPrice);
        return newPrice;
      },
    );

    setState(() {
      if (isOneWay) {
        price.oneWayTicketPrice = double.tryParse(value) ?? 0.0;
      } else {
        price.returnTicketPrice = double.tryParse(value) ?? 0.0;
      }

      busStop.prices!.sort((a, b) {
        final fromIndexA =
        _busLine.segments.indexWhere((s) => s.id == a.busLineSegmentFromId);
        final toIndexA =
        _busLine.segments.indexWhere((s) => s.id == a.busLineSegmentToId);
        final fromIndexB =
        _busLine.segments.indexWhere((s) => s.id == b.busLineSegmentFromId);
        final toIndexB =
        _busLine.segments.indexWhere((s) => s.id == b.busLineSegmentToId);

        final orderA = fromIndexA * 1000 + toIndexA;
        final orderB = fromIndexB * 1000 + toIndexB;
        return orderA.compareTo(orderB);
      });
    });
  }

  Widget _buildTabPlaceholder({
    required IconData icon,
    required String title,
    required String message,
    required Color color,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 60, color: color.withOpacity(0.6)),
          const SizedBox(height: 20),
          Text(title, style: TextStyle(fontSize: 20, color: color)),
          const SizedBox(height: 10),
          Text(message),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Autobuska linija"),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 3,
              ),
            ),
          ),
          tabs: const [
            Tab(icon: Icon(Icons.info_outline), text: "Osnovno"),
            Tab(icon: Icon(Icons.pin_drop), text: "Stajališta"),
            Tab(icon: Icon(Icons.attach_money), text: "Cjenovnik"),
            Tab(icon: Icon(Icons.discount), text: "Popusti"),
            Tab(icon: Icon(Icons.directions_bus), text: "Vozila"),
          ],
        ),
      ),
      body: SafeArea(
        child: loading
            ? CircularProgressIndicator()
            : Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildBasicTab(),
                      _buildStopsTab(),
                      (_busLine.segments.isNotEmpty && _busLine.segments.length > 1
                          ? _buildPricingMatrix()
                          : _buildTabPlaceholder(
                        icon: Icons.price_check,
                        title: "Upravljanje cjenovnikom",
                        message:
                        "Potrebno je prvo da dodate najmanje dvije autobuske stanice da biste mogli upravljati cjenovnikom",
                        color: Colors.blue,
                      )),
                      _buildDicountsTab(),
                      _buildVehiclesTab(),
                      //_buildTabPlaceholder(
                      //  icon: Icons.directions_bus,
                      //  title: "Upravljanje vozilima",
                      //  message: "Ova funkcionalnost će biti dostupna uskoro",
                      //  color: Colors.green,
                      //),
                    ],
                  ),
                ),
                _buildBottomActionBar(),
              ],
            )
        ),
      ),
    );
  }

  Widget _buildVehiclesTab() {
    return Form(
        key: _vehicleFormKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        "Upravljanje vozilima",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      DropdownSearch<ListItem>(
                          popupProps: PopupProps.menu(
                            showSearchBox: true,
                            searchFieldProps: const TextFieldProps(
                              decoration: InputDecoration(
                                hintText: 'Pretraga kompanija',
                                prefixIcon: Icon(Icons.search),
                              ),
                            ),
                          ),
                          asyncItems: (filter) async {
                            return companies;
                          },
                          itemAsString: (item) => item.label,
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: const InputDecoration(
                              labelText: 'Kompanija',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.business),
                            ),
                          ),
                          onChanged: (selectedCompany) async {
                            if (selectedCompany != null) {
                              if (selectedCompanyId != selectedCompany.id) {
                                _busLine.vehicles = [];
                                _selectedVehicle = null;
                              }
                              setState(() {
                                selectedCompanyId = selectedCompany.id;
                              });
                              await _loadVehicles(companyId: selectedCompany.id!);
                            }
                          },
                          validator: (value) => value == null
                              ? 'Morate odabrati kompaniju'
                              : null,
                          selectedItem: companies.firstWhere(
                                  (c) => c.id == selectedCompanyId,
                              orElse: () => ListItem(id: 0, label: ''))),
                      const SizedBox(height: 20),
                      if (selectedCompanyId != null) ...[
                        Row(
                          children: [
                            Expanded(
                              child: DropdownSearch<ListItem>(
                                popupProps: PopupProps.menu(
                                  showSearchBox: true,
                                  searchFieldProps: const TextFieldProps(
                                    decoration: InputDecoration(
                                      hintText: 'Pretraga vozila',
                                      prefixIcon: Icon(Icons.search),
                                    ),
                                  ),
                                ),
                                items: vehicles
                                    .where((v) => !_busLine.vehicles
                                    .any((sv) => sv.vehicleId == v.id))
                                    .toList(),
                                itemAsString: (item) => item.label,
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: const InputDecoration(
                                    labelText: 'Dostupna vozila',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.directions_bus),
                                  ),
                                ),
                                onChanged: (selectedVehicle) {
                                  setState(() {
                                    _selectedVehicle = selectedVehicle;
                                  });
                                },
                                //validator: (value) => value == null
                                //    ? 'Morate odabrati vozilo'
                                //    : null,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 200,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_selectedVehicle != null) {
                                    setState(() {
                                      _busLine.vehicles.add(BusLineVehicle(
                                        id: 0,
                                        busLineId: _busLine.id,
                                        vehicleId: _selectedVehicle!.id!,
                                      ));
                                      _selectedVehicle = null;
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Molimo odaberite vozilo prvo'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                                child: const Text('Dodaj', style: TextStyle(color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  backgroundColor: Colors.deepPurple,
                                ),
                              ),
                            ),

                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Dodijeljena vozila:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        if (_busLine.vehicles.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Nema dodijeljenih vozila"),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _busLine.vehicles.length,
                            itemBuilder: (context, index) {
                              final assignedVehicle = _busLine.vehicles[index];
                              final vehicle = vehicles.firstWhere(
                                    (v) => v.id == assignedVehicle.vehicleId,
                                orElse: () =>
                                    ListItem(id: -1, label: 'Nepoznato vozilo'),
                              );

                              return Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                color: Colors.grey[100],
                                child: ListTile(
                                  title: Text(vehicle.label),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.remove_circle,
                                        color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        _busLine.vehicles.removeAt(index);
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              side: BorderSide(color: Theme.of(context).primaryColor),
            ),
            child: Text(
              "Otkaži",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: _saveBusLine,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColorLight,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              elevation: 2,
            ),
            child: const Text("Spasi liniju"),
          ),
        ],
      ),
    );
  }
}
