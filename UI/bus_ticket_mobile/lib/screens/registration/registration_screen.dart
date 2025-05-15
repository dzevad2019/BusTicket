import 'package:flutter/material.dart';
import 'package:bus_ticket_mobile/models/registrationModel.dart';
import 'package:bus_ticket_mobile/providers/dropdown_provider.dart';
import 'package:bus_ticket_mobile/providers/registration_provider.dart';
import 'package:bus_ticket_mobile/screens/login/login_screen.dart';
import 'package:provider/provider.dart';
import '../../helpers/DateTimeHelper.dart';
import '../../models/listItem.dart';

class RegistrationScreen extends StatefulWidget {
  static const String routeName = "registration";

  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final addressController = TextEditingController();

  RegistrationProvider? _registrationProvider;
  DropdownProvider? _dropdownProvider;
  List<ListItem> genders = [];
  List<ListItem> cities = [];
  ListItem? selectedGender;
  ListItem? selectedCity;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  bool _isFirstSubmit = false;

  @override
  void initState() {
    super.initState();
    _dropdownProvider = context.read<DropdownProvider>();
    _registrationProvider = context.read<RegistrationProvider>();
    loadGenders();
    loadCities();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    dateOfBirthController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        dateOfBirthController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future loadGenders() async {
    var response = await _dropdownProvider?.getItems("genders");
    setState(() {
      genders = response!;
    });
  }

  Future loadCities() async {
    var response = await _dropdownProvider?.getItems("cities");
    setState(() {
      cities = response!;
    });
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      setState(() => _isFirstSubmit = true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      var newUser = RegistrationModel();
      newUser.id = 0;
      newUser.firstName = firstNameController.text;
      newUser.lastName = lastNameController.text;
      newUser.email = emailController.text;
      newUser.phoneNumber = phoneNumberController.text;
      newUser.birthDate = DateTimeHelper.stringToDateTime(dateOfBirthController.text).toLocal();
      newUser.gender = selectedGender!.key;
      newUser.cityId = selectedCity!.key;
      newUser.address = addressController.text;

      bool? result = await _registrationProvider?.registration(newUser);

      if (result != null && result) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              title: Column(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 60,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Registracija uspješna!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              content: Text(
                'Podaci za prijavu su poslani na vašu email adresu. '
                    'Molimo koristite ih za prijavu na aplikaciju.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              actions: [
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Greška prilikom registracije'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Došlo je do greške: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Registracija'),
        elevation: 0,
        backgroundColor: theme.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: _isFirstSubmit
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          child: Column(
            children: [
              // Header Section
              Image.asset(
                'assets/images/bus_logo_2.png',
                height: 50,
              ),
              SizedBox(height: 16),
              Text(
                'Kreirajte svoj račun',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Ispunite podatke za registraciju',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 24),

              // Personal Info Section
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Name Fields
                      _buildTextField(
                        controller: firstNameController,
                        label: 'Ime',
                        icon: Icons.person_outline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Molimo unesite ime';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        controller: lastNameController,
                        label: 'Prezime',
                        icon: Icons.person_outline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Molimo unesite prezime';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        controller: phoneNumberController,
                        label: 'Broj telefona',
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Molimo unesite broj telefona';
                          }
                          RegExp phoneNumberRegExp = RegExp(r'^\d{9,15}$');
                          if (!phoneNumberRegExp.hasMatch(value)) {
                            return 'Broj telefona mora imati 9-15 cifara';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        controller: emailController,
                        label: 'Email adresa',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Molimo unesite email';
                          }
                          RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailRegExp.hasMatch(value)) {
                            return 'Molimo unesite ispravan email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        controller: dateOfBirthController,
                        label: 'Datum rođenja',
                        icon: Icons.calendar_today,
                        readOnly: true,
                        onTap: () => _selectDate(context),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Molimo unesite datum rođenja';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      DropdownButtonFormField<ListItem>(
                        value: selectedGender,
                        decoration: InputDecoration(
                          labelText: "Spol",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          prefixIcon: Icon(Icons.transgender, color: theme.primaryColor),
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'Molimo odaberite spol';
                          }
                          return null;
                        },
                        items: genders.map((ListItem item) {
                          return DropdownMenuItem<ListItem>(
                            value: item,
                            child: Text(item.value),
                          );
                        }).toList(),
                        onChanged: (ListItem? newValue) {
                          setState(() => selectedGender = newValue);
                        },
                        hint: Text('Odaberite spol'),
                      ),
                      SizedBox(height: 16),
                      DropdownButtonFormField<ListItem>(
                        value: selectedCity,
                        decoration: InputDecoration(
                          labelText: "Grad",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          prefixIcon: Icon(Icons.location_city, color: theme.primaryColor),
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'Molimo odaberite grad';
                          }
                          return null;
                        },
                        items: cities.map((ListItem item) {
                          return DropdownMenuItem<ListItem>(
                            value: item,
                            child: Text(item.value),
                          );
                        }).toList(),
                        onChanged: (ListItem? newValue) {
                          setState(() => selectedCity = newValue);
                        },
                        hint: Text('Odaberite grad'),
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        controller: addressController,
                        label: 'Adresa',
                        icon: Icons.home_outlined,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Molimo unesite adresu';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Register Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4,
                  ),
                  onPressed: _isLoading ? null : _register,
                  child: _isLoading
                      ? CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  )
                      : Text(
                    'REGISTRUJ SE',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Login Link
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, LoginScreen.routeName);
                },
                child: RichText(
                  text: TextSpan(
                    text: 'Već imate račun? ',
                    style: TextStyle(color: Colors.grey.shade600),
                    children: [
                      TextSpan(
                        text: 'Prijavite se',
                        style: TextStyle(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool readOnly = false,
    String? Function(String?)? validator,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
      ),
      validator: validator,
      onTap: onTap,
    );
  }
}