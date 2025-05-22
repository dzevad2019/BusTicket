import 'dart:convert';

import 'package:bus_ticket_mobile/models/bus_line.dart';
import 'package:bus_ticket_mobile/models/bus_line_discount.dart';
import 'package:bus_ticket_mobile/models/listItem.dart';
import 'package:bus_ticket_mobile/models/ticket.dart';
import 'package:bus_ticket_mobile/providers/dropdown_provider.dart';
import 'package:bus_ticket_mobile/providers/tickets_provider.dart';
import 'package:bus_ticket_mobile/screens/others/payment_success.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart' hide Card;
import 'package:provider/provider.dart';

class Passenger {
  String name = '';
  String surname = '';
  String phone = '';
  BusLineDiscount? selectedDiscount;
  double basePrice;

  double get finalPrice => basePrice * (1 - (selectedDiscount?.value ?? 0) / 100);

  Passenger({required this.basePrice});
}

class TicketPurchasePage extends StatefulWidget {
  final BusLine route;
  final BusLine? returnRoute;
  final double basePrice;
  final bool roundTrip;
  final int busLineSegmentFromId;
  final int busLineSegmentToId;

  final int? busLineSegmentReturnFromId;
  final int? busLineSegmentReturnToId;

  final DateTime dateTime;
  final DateTime? dateTimeRoundTrip;

  const TicketPurchasePage({
    Key? key,
    required this.route,
    this.returnRoute,
    required this.roundTrip,
    required this.basePrice,
    required this.busLineSegmentFromId,
    required this.busLineSegmentToId,
    required this.busLineSegmentReturnFromId,
    required this.busLineSegmentReturnToId,
    required this.dateTime,
    required this.dateTimeRoundTrip,
  }) : super(key: key);

  @override
  _TicketPurchasePageState createState() => _TicketPurchasePageState();
}

class _TicketPurchasePageState extends State<TicketPurchasePage> {
  List<Passenger> _passengers = [];
  bool _acceptTerms = false;
  bool _subscribeNews = false;
  bool _isLoading = false;
  final List<TextEditingController> _nameControllers = [];
  final List<TextEditingController> _surnameControllers = [];
  final List<TextEditingController> _phoneControllers = [];

  late TicketsProvider _ticketsProvider;

  List<int> busySeats = [];
  int numberOfSeats = 55;
  List<int> selectedSeats = [];

  List<int> busySeatsReturnLine = [];
  int numberOfSeatsReturnLine = 55;
  List<int> selectedSeatsReturnLine = [];


  @override
  void initState() {
    super.initState();
    _ticketsProvider = context.read<TicketsProvider>();
    busySeats = widget.route.busySeats ?? [];
    numberOfSeats = widget.route.numberOfSeats ?? 0;

    busySeatsReturnLine = widget.returnRoute?.busySeats ?? [];
    numberOfSeatsReturnLine = widget.returnRoute?.numberOfSeats ?? 0;

    _addPassenger();
  }

  @override
  void dispose() {
    for (var controller in _nameControllers) {
      controller.dispose();
    }
    for (var controller in _surnameControllers) {
      controller.dispose();
    }
    for (var controller in _phoneControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addPassenger() {
    setState(() {
      final newPassenger = Passenger(basePrice: widget.basePrice);
      _passengers = [..._passengers, newPassenger];

      _nameControllers.add(TextEditingController());
      _surnameControllers.add(TextEditingController());
      _phoneControllers.add(TextEditingController());
    });
  }

  void _removePassenger(int index) {
    if (_passengers.length > 1) {
      setState(() {
        _passengers.removeAt(index);
        _nameControllers[index].dispose();
        _surnameControllers[index].dispose();
        _phoneControllers[index].dispose();
        _nameControllers.removeAt(index);
        _surnameControllers.removeAt(index);
        _phoneControllers.removeAt(index);
      });
    }
  }

  double get _totalPrice {
    return _passengers.fold(0, (sum, passenger) => sum + passenger.finalPrice);
  }

  bool _validatePhoneNumber(String phone) {
    return phone.length >= 6 && RegExp(r'^[0-9]+$').hasMatch(phone);
  }

  createPaymentIntent(double amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': (amount * 100).toStringAsFixed(0),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization':
            'Bearer ${dotenv.env['STRIPE_SECRET']}',
            'Content-Type': 'application/x-www-form-urlencoded'
          });

      return jsonDecode(response.body);
    } catch (err) {
      print(err);
      //silent
    }
  }

  showPaymentSheet(List<TicketPerson> ticketPersons, double price) async {
    setState(() {
      _isLoading = true;
    });
    var paymentIntentData = await createPaymentIntent(price, 'BAM');
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntentData['client_secret'],
        merchantDisplayName: 'BusTicket Plaćanje',
        appearance: const PaymentSheetAppearance(
          primaryButton: PaymentSheetPrimaryButtonAppearance(
              colors: PaymentSheetPrimaryButtonTheme(
                  light: PaymentSheetPrimaryButtonThemeColors(
                      background: Colors.cyan)
              )
          ),
        ),
      ),
    ).then((value) {
      print(value);
    }).onError((error, stackTrace) {
      print(error);
      //showDialog(
      //    context: context,
      //    builder: (_) => AlertDialog(
      //      content: Text(error.toString()),
      //    )
      //);
    });

    try {
      await Stripe.instance.presentPaymentSheet();

      List<TicketSegment> ticketSegments = [];

      ticketSegments.add(TicketSegment(
        busLineSegmentFromId: widget.busLineSegmentFromId,
        busLineSegmentToId: widget.busLineSegmentToId,
        dateTime: widget.dateTime,
      ));

      if (widget.roundTrip){
        ticketSegments.add(TicketSegment(
          busLineSegmentFromId: widget.busLineSegmentReturnFromId!,
          busLineSegmentToId: widget.busLineSegmentReturnToId!,
          dateTime: widget.dateTimeRoundTrip!,
        ));
      }

      final ticket = Ticket(
          id: 0,
          //roundTrip: widget.roundTrip,
          //busLineSegmentFromId: widget.busLineSegmentFromId,
          //busLineSegmentToId: widget.busLineSegmentToId,
          transactionId: paymentIntentData['id'],
          persons: ticketPersons,
          ticketSegments: ticketSegments

          //dateTime: widget.dateTime,
          //dateTimeRoundTrip: widget.dateTimeRoundTrip,
      );

      await _ticketsProvider.insert(ticket);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PaymentSuccess(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Greška pri plaćanju: $e'),
        ),
      );
    }
    finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kupovina karte', style: TextStyle(color: Colors.white)),
        backgroundColor: theme.primaryColor,
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator()) : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Baggage info
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.luggage, size: 20),
                        SizedBox(width: 8),
                        Text('Besplatan ručni prtljag do 5kg'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.payments, size: 20),
                        SizedBox(width: 8),
                        Text('Dodatni prtljag možete platiti u autobusu'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Passenger info sections
            ...List.generate(_passengers.length, (index) {
              final passenger = _passengers[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (index > 0) const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Putnik ${index + 1}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (index > 0)
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removePassenger(index),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    'Ime*',
                    _nameControllers[index],
                    onChanged: (value) => passenger.name = value,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    'Prezime*',
                    _surnameControllers[index],
                    onChanged: (value) => passenger.surname = value,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _phoneControllers[index],
                    decoration: const InputDecoration(
                      labelText: 'Broj telefona*',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (value) {
                      passenger.phone = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Molimo unesite broj telefona';
                      }
                      if (!_validatePhoneNumber(value)) {
                        return 'Unesite ispravan broj telefona';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  if (widget.route.discounts.isNotEmpty)// Discount selection for this passenger
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Vrsta popusta'),
                      DropdownButton<BusLineDiscount>(
                        value: passenger.selectedDiscount,
                        hint: const Text('Osnovni cjenovnik'),
                        items: [
                          // Basic price option
                          const DropdownMenuItem(
                            value: null,
                            child: Text('Osnovni cjenovnik'),
                          ),
                          // Discount options from bus line
                          ...widget.route.discounts.map((discount) {
                            return DropdownMenuItem(
                              value: discount,
                              child: Text(
                                '${discount.discount!.name} (${discount.value}%)',
                              ),
                            );
                          }).toList(),
                        ],
                        onChanged: (discount) {
                          setState(() {
                            passenger.selectedDiscount = discount;
                          });
                        },
                      ),
                    ],
                  ),

                  // Price for this passenger
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Cijena:'),
                      Text(
                        '${passenger.finalPrice.toStringAsFixed(2)} KM',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  if (index < _passengers.length - 1) const Divider(height: 32),
                ],
              );
            }),

            const SizedBox(height: 16),

            // Add passenger button
            Center(
              child: OutlinedButton(
                onPressed: _addPassenger,
                child: const Text('DODAJ JOŠ JEDNOG PUTNIKA'),
              ),
            ),
            const SizedBox(height: 16),

            // ... existing passenger sections ...

            const SizedBox(height: 24),
            //Center(
            //  child: _buildBusSeatLayout(),
            //),
            _buildBusSeatLayout(numberOfSeats, busySeats, selectedSeats),
            const SizedBox(height: 16),

            if (widget.returnRoute != null)
              Column(
                children: [
                  Divider(),
                  Center(child: Text("Sjedište u povratku")),
                  _buildBusSeatLayout(numberOfSeatsReturnLine, busySeatsReturnLine, selectedSeatsReturnLine),
                ],
              ),



            // Total summary
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Broj putnika:'),
                        Text('${_passengers.length}'),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Ukupno za plaćanje:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('${_totalPrice.toStringAsFixed(2)} KM',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Checkboxes
            CheckboxListTile(
              title: const Text('Prijavite se za naše novosti'),
              value: _subscribeNews,
              onChanged: (value) {
                setState(() {
                  _subscribeNews = value ?? false;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              title: const Text('Slažem se sa uslovima korištenja'),
              value: _acceptTerms,
              onChanged: (value) {
                setState(() {
                  _acceptTerms = value ?? false;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _acceptTerms ? () async {
                  bool allValid = true;
                  List<String> validationErrors = [];

                  for (int i = 0; i < _passengers.length; i++) {
                    if (_nameControllers[i].text.isEmpty) {
                      allValid = false;
                      validationErrors.add('Ime za putnika ${i + 1}');
                    }
                    if (_surnameControllers[i].text.isEmpty) {
                      allValid = false;
                      validationErrors.add('Prezime za putnika ${i + 1}');
                    }
                    if (_phoneControllers[i].text.isEmpty) {
                      allValid = false;
                      validationErrors.add('Telefon za putnika ${i + 1}');
                    } else if (!_validatePhoneNumber(_phoneControllers[i].text)) {
                      allValid = false;
                      validationErrors.add('Ispravan telefon za putnika ${i + 1}');
                    }
                  }

                  if (selectedSeats.length != _passengers.length) {
                    allValid = false;
                    validationErrors.add('Morate odabrati sjedišta za sve putnike');
                  }

                  if (allValid) {
                    final ticketPersons = _passengers.asMap().map((index, passenger) {
                      return MapEntry(index, TicketPerson(
                        id: 0,
                        ticketId: 0,
                        firstName: passenger.name,
                        lastName: passenger.surname,
                        phoneNumber: passenger.phone,
                        discountId: passenger.selectedDiscount?.discount?.id ?? null,
                        amount: passenger.finalPrice,
                        numberOfSeat: selectedSeats[index],
                        numberOfSeatRoundTrip: selectedSeatsReturnLine.isNotEmpty ? selectedSeatsReturnLine[index] : null,
                      ));
                    }).values.toList();

                    await showPaymentSheet(ticketPersons, _totalPrice);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Popravite sljedeće: ${validationErrors.join(', ')}',
                          maxLines: 2,
                        ),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                } : null,
                child: Text(
                  'PLATI ${_totalPrice.toStringAsFixed(2)} KM',
                  style: const TextStyle(
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
    );
  }

  Widget _buildTextField(
      String label,
      TextEditingController controller, {
        ValueChanged<String>? onChanged,
      }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      onChanged: onChanged,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZšđčćžŠĐČĆŽ\s]')),
      ],
    );
  }

  void _toggleSeatSelection(List<int> selectedSeats, int seatNumber) {
    setState(() {
      if (selectedSeats.contains(seatNumber)) {
        selectedSeats.remove(seatNumber);
      } else {
        if (selectedSeats.length < _passengers.length) {
          selectedSeats.add(seatNumber);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Možete odabrati samo ${_passengers.length} sjedišta'),
            ),
          );
        }
      }
    });
  }

  Widget _buildBusSeatLayout(int numOfSeats, List<int> selectedSeats, List<int> busySeats) {
    const int seatsPerRow = 4;
    int rows = (numOfSeats / seatsPerRow).ceil();
    int doorRow = (rows / 2).floor();
    int seatNumber = 1;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Odaberite sjedišta:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Odabrana sjedišta: ${busySeats.isEmpty ? "Nema odabranih" : busySeats.join(", ")}',
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),

          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(rows, (rowIndex) {
              final isDoorRow = rowIndex == doorRow;
              final isLastRow = rowIndex == rows - 1;

              return Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Redni broj reda
                      //Container(
                      //  width: 24,
                      //  alignment: Alignment.center,
                      //  child: Text('${rowIndex + 1}'),
                      //),
                      //const SizedBox(width: 8),

                      // Lijeva strana (2 sjedišta)
                      if (seatNumber <= numOfSeats) ...[
                        _buildSeat(seatNumber++, selectedSeats, busySeats),
                      ],
                      const SizedBox(width: 4),
                      if (seatNumber <= numOfSeats) ...[
                        _buildSeat(seatNumber++, selectedSeats, busySeats),
                      ],

                      // Hodnik ili dodatno sjedište
                      if (isLastRow && seatNumber <= numOfSeats) ...[
                        const SizedBox(width: 4),
                        _buildSeat(seatNumber++, selectedSeats, busySeats),
                        const SizedBox(width: 4),
                      ] else ...[
                        const SizedBox(width: 16),
                        Container(
                          width: 16,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.transparent),
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],

                      // Desna strana (2 sjedišta ili vrata)
                      if (!isDoorRow) ...[
                        if (seatNumber <= numOfSeats) ...[
                          _buildSeat(seatNumber++, selectedSeats, busySeats),
                        ],
                        const SizedBox(width: 4),
                        if (seatNumber <= numOfSeats) ...[
                          _buildSeat(seatNumber++, selectedSeats, busySeats),
                        ],
                      ] else ...[
                        Container(
                          width: 83,
                          height: 20,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red, width: 2),
                          ),
                          child: const Center(
                            child: Text(
                              'VRATA',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSeat(int seatNumber, List<int> busySeats, List<int> selectedSeats) {
    final isBusy = busySeats.contains(seatNumber);
    final isSelected = selectedSeats.contains(seatNumber);

    return GestureDetector(
      onTap: isBusy ? null : () => _toggleSeatSelection(selectedSeats, seatNumber),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isBusy
              ? Colors.red
              : isSelected
              ? Theme.of(context).primaryColor
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColorDark
                : Colors.grey,
          ),
        ),
        child: Center(
          child: Text(
            seatNumber.toString(),
            style: TextStyle(
              color: isBusy || isSelected
                  ? Colors.white
                  : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}