import 'package:bus_ticket_mobile/models/listItem.dart';
import 'package:bus_ticket_mobile/providers/bus_lines_provider.dart';
import 'package:bus_ticket_mobile/providers/dropdown_provider.dart';
import 'package:bus_ticket_mobile/screens/bus-line/bus_routes_list.dart';
import 'package:bus_ticket_mobile/screens/notification/notification_page.dart';
import 'package:bus_ticket_mobile/screens/ticket/user_tickets_page.dart';
import 'package:bus_ticket_mobile/screens/user/profile_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const String routeName = "home";
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? _fromStationId;
  int? _toStationId;
  DateTime? _selectedDate;
  DateTime? _returnDate;
  int _passengerCount = 1;
  bool _isRoundTrip = false;
  int _currentIndex = 0;

  bool _isLoading = false;

  List<ListItem> busStops = [];
  List<ListItem> filteredBusStops = [];

  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  late final DropdownProvider _dropdownProvider;
  late final BusLinesProvider _busLinesProvider;

  Future<void> _pickDate({bool isReturnDate = false}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isReturnDate
          ? _returnDate ?? (_selectedDate ?? DateTime.now()).add(Duration(days: 1))
          : _selectedDate ?? DateTime.now(),
      firstDate: isReturnDate
          ? (_selectedDate ?? DateTime.now()).add(Duration(days: 1))
          : DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        if (isReturnDate) {
          _returnDate = picked;
        } else {
          _selectedDate = picked;
          // Reset return date if departure date changes
          if (_returnDate != null && _returnDate!.isBefore(picked)) {
            _returnDate = null;
          }
        }
      });
    }
  }

  void _searchBuses() async {
    if (_fromStationId != null &&
        _toStationId != null &&
        _selectedDate != null &&
        (!_isRoundTrip || (_isRoundTrip && _returnDate != null))) {

      setState(() {
        _isLoading = true;
      });

      final results = await _busLinesProvider.getAvailableLines(
          _fromStationId!,
          _toStationId!,
          _selectedDate!,
          _isRoundTrip ? _returnDate : null
      );

      if (results.isNotEmpty) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.9,
              padding: const EdgeInsets.only(top: 16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      'Dostupne linije',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height * 0.9 - 50, // Oduzimamo visinu naslova i dividera
                      ),
                      child: BusRoutesList(
                        routes: results,
                        fromStationId: _fromStationId!,
                        toStationId: _toStationId!,
                        isRoundTrip: _isRoundTrip,
                        dateTime: _selectedDate!,
                        dateTimeRoundTrip: _returnDate
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Nema dostupnih linija za odabrane parametre")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Molimo odaberite sve podatke")),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _swapStations() {
    setState(() {
      final temp = _fromController.text;
      _fromController.text = _toController.text;
      _toController.text = temp;

      final tempId = _fromStationId;
      _fromStationId = _toStationId;
      _toStationId = tempId;
    });
  }

  Future<void> _loadBusStops() async {
    final response = await _dropdownProvider.getItems("Bus-Stops");
    if (mounted) {
      setState(() {
        busStops = response ?? [];
        print(busStops.length);
        filteredBusStops = List.from(busStops);
      });
    }
  }

  void _filterBusStops(String query) {
    setState(() {
      filteredBusStops = busStops
          .where((station) =>
          station.value.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    _dropdownProvider = context.read<DropdownProvider>();
    _busLinesProvider = context.read<BusLinesProvider>();
    super.initState();
    _loadBusStops();
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/bus_logo.png',
          height: 40,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator()) : SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: theme.primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Pronađite autobusku liniju',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ChoiceChip(
                                label: Text("Jedan smjer"),
                                selected: !_isRoundTrip,
                                onSelected: (selected) {
                                  setState(() {
                                    _isRoundTrip = !selected;
                                  });
                                },
                                selectedColor: theme.primaryColor.withOpacity(0.2),
                                labelStyle: TextStyle(
                                  color: !_isRoundTrip ? theme.primaryColor : Colors.grey,
                                ),
                              ),
                              ChoiceChip(
                                label: Text("Povratna karta"),
                                selected: _isRoundTrip,
                                onSelected: (selected) {
                                  setState(() {
                                    _isRoundTrip = selected;
                                  });
                                },
                                selectedColor: theme.primaryColor.withOpacity(0.2),
                                labelStyle: TextStyle(
                                  color: _isRoundTrip ? theme.primaryColor : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),

                          _buildStationField(
                            controller: _fromController,
                            label: "Polazna stanica",
                            icon: Icons.location_on,
                            isFromStation: true,
                          ),
                          SizedBox(height: 8),
                          IconButton(
                            icon: Icon(Icons.swap_vert, color: theme.primaryColor),
                            onPressed: _swapStations,
                          ),
                          SizedBox(height: 8),
                          _buildStationField(
                            controller: _toController,
                            label: "Dolazna stanica",
                            icon: Icons.location_on,
                            isFromStation: false,
                          ),
                          SizedBox(height: 16),

                          _buildDateField(
                            label: "Datum polaska",
                            date: _selectedDate,
                            onTap: () => _pickDate(),
                          ),

                          if (_isRoundTrip) ...[
                            SizedBox(height: 16),
                            _buildDateField(
                              label: "Datum povratka",
                              date: _returnDate,
                              onTap: () => _pickDate(isReturnDate: true),
                            ),
                          ],
                          SizedBox(height: 16),

                          _buildPassengerField(),
                          SizedBox(height: 16),

                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: _searchBuses,
                              child: Text(
                                "Pretraži",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Popularne destinacije',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildPopularDestination("Sarajevo", Icons.location_city),
                        _buildPopularDestination("Mostar", Icons.location_city),
                        _buildPopularDestination("Banja Luka", Icons.location_city),
                        _buildPopularDestination("Tuzla", Icons.location_city),
                        _buildPopularDestination("Zenica", Icons.location_city),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Posebne ponude
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Posebne ponude',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildSpecialOffer(
                    "Popust 20% za studentske karte",
                    Icons.school,
                    theme.primaryColor,
                  ),
                  SizedBox(height: 8),
                  _buildSpecialOffer(
                    "Besplatna prtljaga u maju",
                    Icons.card_travel,
                    Colors.orange,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 1) { //
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationPage()),
            );
          }
          else if (index == 2) { //
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TicketsPage()),
            );
          }
          else if (index == 3){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileEditPage()),
            );
          }
          setState(() => _currentIndex = index);
        },
        selectedItemColor: theme.primaryColor,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Početna',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Notifikacije',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_number), // Ikona za karte
            label: 'Karte',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  Widget _buildStationField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isFromStation,
  }) {
    return InkWell(
      onTap: () {
        _showStationPicker(context, isFromStation: isFromStation);
      },
      child: TextField(
        controller: controller,
        enabled: false,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
      ),
    );
  }

  void _showStationPicker(BuildContext context, {required bool isFromStation}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Pretraži stanice',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: _filterBusStops,
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredBusStops.length,
                      itemBuilder: (context, index) {
                        final station = filteredBusStops[index];
                        return ListTile(
                          leading: Icon(Icons.location_on),
                          title: Text(station.value),
                          onTap: () {
                            setState(() {
                              if (isFromStation) {
                                _fromController.text = station.value;
                                _fromStationId = station.key;
                              } else {
                                _toController.text = station.value;
                                _toStationId = station.key;
                              }
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: Theme.of(context).primaryColor),
            SizedBox(width: 16),
            Text(
              date == null ? 'Odaberite datum' : DateFormat('dd.MM.yyyy').format(date),
              style: TextStyle(
                color: date == null ? Colors.grey : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPassengerField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.person, color: Theme.of(context).primaryColor),
          SizedBox(width: 16),
          Text("Putnici"),
          Spacer(),
          IconButton(
            icon: Container(
              decoration: BoxDecoration(
                color: _passengerCount > 1 ? Theme.of(context).primaryColor : Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.remove, color: Colors.white),
            ),
            onPressed: _passengerCount > 1
                ? () => setState(() => _passengerCount--)
                : null,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              "$_passengerCount",
              style: TextStyle(fontSize: 18),
            ),
          ),
          IconButton(
            icon: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add, color: Colors.white),
            ),
            onPressed: () => setState(() => _passengerCount++),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularDestination(String city, IconData icon) {
    return Container(
      margin: EdgeInsets.only(right: 12),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Icon(icon, color: Theme.of(context).primaryColor),
          ),
          SizedBox(height: 8),
          Text(city),
        ],
      ),
    );
  }

  Widget _buildSpecialOffer(String title, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}