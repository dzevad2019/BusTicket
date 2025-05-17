import 'dart:convert';

import 'package:bus_ticket_admin/models/listItem.dart';
import 'package:bus_ticket_admin/models/user_role.dart';
import 'package:bus_ticket_admin/models/user_upsert_model.dart';
import 'package:bus_ticket_admin/providers/enum_provider.dart';
import 'package:bus_ticket_admin/providers/users_provider.dart';
import 'package:bus_ticket_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UserAddScreen extends StatefulWidget {
  final int? userId;

  const UserAddScreen({Key? key, this.userId}) : super(key: key);

  @override
  State<UserAddScreen> createState() => _UserAddScreenState();
}

class _UserAddScreenState extends State<UserAddScreen> {
  final _formKey = GlobalKey<FormState>();
  late UsersProvider _userProvider;
  late EnumProvider _enumProvider;

  List<ListItem> genders = [];
  ListItem? _selectedGender;

  List<ListItem> roles = [];
  ListItem? _selectedRole;

  UserUpsertModel _user = UserUpsertModel(
    firstName: '',
    lastName: '',
    userName: '',
    email: '',
    phoneNumber: '',
    address: '',
  );
  bool _isLoading = true;
  DateTime? _selectedBirthDate;
  int? _selectedRoleId;
  final TextEditingController _birthDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UsersProvider>(context, listen: false);
    _enumProvider = Provider.of<EnumProvider>(context, listen: false);
    _initializeData();
  }

  Future<void> _initializeData() async {
    await loadGenders();
    await loadRoles();

    if (widget.userId != null) {
      await _loadUser();
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> loadGenders() async {
    var response = await _enumProvider!.getEnumItems("genders");
    setState(() {
      genders = response! ?? [];
    });
  }

  Future<void> loadRoles() async {
    var response = await _enumProvider!.getEnumItems("roles");
    setState(() {
      roles = response! ?? [];
    });
  }

  Future<void> _loadUser() async {
    try {
      var user = await _userProvider.getById(widget.userId!, null);
      setState(() {
        // print(jsonEncode(user));
        _user = user;
        _selectedBirthDate = user.birthDate;

        _selectedGender = genders.isNotEmpty && user.gender != null
            ? genders.firstWhere((x) => x.id == user.gender)
            : null;
        _selectedRole = roles.isNotEmpty && user.userRoles != null
            ? roles.firstWhere((x) => x.id == user.userRoles?.first?.roleId)
            : null;

        if (_selectedBirthDate != null) {
          _birthDateController.text =
              DateFormat('dd.MM.yyyy').format(_selectedBirthDate!);
        }
        _isLoading = false;
      });
    } catch (e) {
      //Fluttertoast.showToast(msg: "Greška pri učitavanju korisnika");
      //Navigator.pop(context);
    }
  }

  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedBirthDate) {
      setState(() {
        _selectedBirthDate = picked;
        _birthDateController.text = DateFormat('dd.MM.yyyy').format(picked);
      });
    }
  }

  Future<void> _saveUser() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _user.birthDate = _selectedBirthDate;
      _user.gender = _selectedGender!.id;

      if (_user.userRoles == null) {
        _user.userRoles = [];
        _user.userRoles!.add(UserRoleModel(
            id: 0, userId: _user.id ?? 0, roleId: _selectedRole!.id));
      } else {
        _user.userRoles!.first!.roleId = _selectedRole!.id;
      }

      try {

        String message = "";
        print(_user.toJson());
        _user.profilePhoto = null;
        if (widget.userId == null) {
          await _userProvider.insert(_user);
          message = "Korisnik je uspješno dodan. Pristupni podaci su poslani na korisnikovu email adresu.";
        } else {
          await _userProvider.update(widget.userId!, _user);
          message = "Podaci su uspješno spremljeni";
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Dogodila se greška prilikom spremljanja podataka"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              widget.userId == null ? "Dodaj korisnika" : "Uredi korisnika"),
          centerTitle: true,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.save, color: Colors.white),
              onPressed: _saveUser,
              tooltip: 'Spremi',
            ),
          ],
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSectionHeader("Osnovni podaci"),
                _buildCard([
                  _buildTextFormField(
                    label: "Ime",
                    icon: Icons.person,
                    initialValue: _user.firstName,
                    validator: (value) =>
                    value?.isEmpty ?? true ? "Unesite ime" : null,
                    onSaved: (value) => _user.firstName = value!,
                  ),
                  SizedBox(height: 16),
                  _buildTextFormField(
                    label: "Prezime",
                    icon: Icons.person_outline,
                    initialValue: _user.lastName,
                    validator: (value) =>
                    value?.isEmpty ?? true ? "Unesite prezime" : null,
                    onSaved: (value) => _user.lastName = value!,
                  ),
                  SizedBox(height: 16),
                  _buildBirthDateField(),
                  SizedBox(height: 16),
                  _buildGenderDropdown(),
                ]),
                SizedBox(height: 24),
                _buildSectionHeader("Račun korisnika"),
                _buildCard([
                  if (_user.id != 0 && _user.id != null) ...[
                    _buildTextFormField(
                        label: "Korisničko ime",
                        icon: Icons.account_circle,
                        initialValue: _user.userName,
                        validator: (value) => value?.isEmpty ?? true
                            ? "Unesite korisničko ime"
                            : null,
                        onSaved: (value) => _user.userName = value!,
                        enabled: _user.id == 0 || _user.id == null
                    ),
                    SizedBox(height: 16),
                  ],
                  _buildTextFormField(
                      label: "Email",
                      icon: Icons.email,
                      initialValue: _user.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                      value?.isEmpty ?? true ? "Unesite email" : null,
                      onSaved: (value) => _user.email = value!,
                      enabled: _user.id == 0 || _user.id == null
                  ),
                  SizedBox(height: 16),
                  _buildRoleDropdown(),
                ]),
                SizedBox(height: 24),
                _buildSectionHeader("Kontakt podaci"),
                _buildCard([
                  _buildTextFormField(
                    label: "Telefon",
                    icon: Icons.phone,
                    initialValue: _user.phoneNumber,
                    keyboardType: TextInputType.phone,
                    onSaved: (value) => _user.phoneNumber = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Unesite broj telefona';
                      }
                      if (!RegExp(r'^[0-9+]+$').hasMatch(value)) {
                        return 'Broj telefona može sadržavati samo brojeve';
                      }
                      if (value.length < 8) {
                        return 'Broj telefona mora imati najmanje 8 cifara';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  _buildTextFormField(
                    label: "Adresa",
                    icon: Icons.home,
                    initialValue: _user.address,
                    onSaved: (value) => _user.address = value!,
                  ),
                ]),
                SizedBox(height: 24),
                _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildTextFormField(
      {required String label,
        required String? initialValue,
        IconData? icon,
        TextInputType? keyboardType,
        String? Function(String?)? validator,
        required void Function(String?) onSaved,
        bool? enabled}) {
    return TextFormField(
      enabled: enabled == null || enabled == true,
      initialValue: initialValue,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }

  Widget _buildBirthDateField() {
    return TextFormField(
      controller: _birthDateController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: "Datum rođenja",
        prefixIcon: Icon(Icons.cake),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: () => _selectBirthDate(context),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      onTap: () => _selectBirthDate(context),
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<ListItem>(
      value: _selectedGender,
      decoration: InputDecoration(
        labelText: "Spol",
        prefixIcon: Icon(Icons.transgender),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      items: genders.map((gender) {
        return DropdownMenuItem<ListItem>(
          value: gender,
          child: Text(gender.label),
        );
      }).toList(),
      onChanged: (ListItem? value) {
        setState(() {
          _selectedGender = value;
        });
      },
      validator: (value) => value == null ? 'Obavezno polje' : null,
      borderRadius: BorderRadius.circular(12),
    );
  }

  Widget _buildRoleDropdown() {
    return DropdownButtonFormField<ListItem>(
      value: _selectedRole,
      decoration: InputDecoration(
        labelText: "Uloga",
        prefixIcon: Icon(Icons.verified_user),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      items: roles.map((role) {
        return DropdownMenuItem<ListItem>(
          value: role,
          child: Text(role.label),
        );
      }).toList(),
      validator: (value) => value == null ? 'Obavezno polje' : null,
      onChanged: (ListItem? value) {
        setState(() {
          _selectedRole = value;
        });
      },
      borderRadius: BorderRadius.circular(12),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _saveUser,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          "SPREMI",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(vertical: 0),
      ),
    );
  }
}
