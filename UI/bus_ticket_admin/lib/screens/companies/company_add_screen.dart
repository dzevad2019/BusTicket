import 'dart:convert';
import 'package:bus_ticket_admin/providers/base_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bus_ticket_admin/models/company.dart';
import 'package:bus_ticket_admin/models/company_upsert.dart';
import 'package:bus_ticket_admin/models/listItem.dart';
import 'package:bus_ticket_admin/providers/companies_provider.dart';
import 'package:bus_ticket_admin/providers/enum_provider.dart';
import 'package:bus_ticket_admin/screens/companies/company_list_screen.dart';
import 'dart:io';
import 'package:flutter/services.dart';

import 'package:bus_ticket_admin/widgets/master_screen.dart';

class CompanyAddScreen extends StatefulWidget {
  final int? companyId;

  CompanyAddScreen({this.companyId, Key? key}) : super(key: key);

  @override
  _CompanyAddScreenState createState() => _CompanyAddScreenState();
}

class _CompanyAddScreenState extends State<CompanyAddScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  final picker = ImagePicker();

  final _enumProvider = new EnumProvider();
  final _companyProvider = new CompanyProvider();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController webPageController = TextEditingController();
  final TextEditingController taxNumberController = TextEditingController();
  final TextEditingController identificationNumberController =
      TextEditingController();

  bool isActive = true;
  int? selectedCity;
  List<ListItem> cities = [];

  Company? company;

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<String> fileToBase64(File file) async {
    List<int> fileBytes = await file.readAsBytes();
    String base64String = base64Encode(fileBytes);
    return base64String;
  }

  void _saveCompany() async {
    if (_formKey.currentState!.validate()) {
      var companyUpsert = new CompanyUpsert(
          id: company?.id ?? 0,
          phoneNumber: phoneController.text,
          email: emailController.text,
          active: isActive,
          cityId: selectedCity!,
          identificationNumber: identificationNumberController.text,
          webPage: webPageController.text,
          name: nameController.text,
          taxNumber: taxNumberController.text,
          image: _selectedImage != null
              ? await fileToBase64(_selectedImage!)
              : '');

      if (companyUpsert.id == 0) {
        await _companyProvider.insert(companyUpsert);
      } else {
        await _companyProvider.update(companyUpsert.id, companyUpsert);
      }

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CompanyListScreen(),
        ),
      );
    }
  }

  Future _loadCities() async {
    var response = await _enumProvider?.getEnumItems("Cities");
    setState(() {
      cities = response ?? [];
    });
  }

  Future _loadCompany() async {
    if (widget.companyId != null) {
      company = await _companyProvider.getById(widget.companyId!, null);
      setState(() {
        nameController.text = company!.name;
        phoneController.text = company!.phoneNumber;
        emailController.text = company!.email;
        webPageController.text = company!.webPage;
        taxNumberController.text = company!.taxNumber;
        identificationNumberController.text = company!.identificationNumber;
        selectedCity = company!.cityId;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCities();
    _loadCompany();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Dodavanje kompanije'),
        centerTitle: true,
        //backgroundColor: Colors.blue.shade700,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Card(
          elevation: 6,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : (company?.logoUrl != null &&
                                  company!.logoUrl!.isNotEmpty
                              ? NetworkImage(
                                  "${BaseProvider.apiUrl}${company!.logoUrl!}")
                              : null) as ImageProvider?,
                      child: (_selectedImage == null &&
                              (company?.logoUrl == null ||
                                  company!.logoUrl!.isEmpty))
                          ? Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                          : null,
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildInput(
                      nameController, 'Naziv kompanije', Icons.business),
                  _buildInput(phoneController, 'Broj telefona', Icons.phone),
                  _buildInput(emailController, 'Email', Icons.email),
                  _buildInput(webPageController, 'Web stranica', Icons.web),
                  _buildInput(taxNumberController, 'Porezni broj',
                      Icons.confirmation_number),
                  _buildInput(identificationNumberController,
                      'Identifikacijski broj', Icons.perm_identity),
                  SizedBox(height: 16),
                  SwitchListTile(
                    title: Text("Aktivna"),
                    value: isActive,
                    onChanged: (val) {
                      setState(() {
                        isActive = val;
                      });
                    },
                    activeColor: Colors.blue,
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: 'Grad',
                      prefixIcon: Icon(Icons.location_city),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    value: selectedCity,
                    items: cities.map((city) {
                      return DropdownMenuItem(
                          value: city.id, child: Text(city.label));
                    }).toList(),
                    onChanged: (val) => setState(() => selectedCity = val),
                    validator: (val) => val == null ? 'Odaberite grad' : null,
                  ),
                  SizedBox(height: 24),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _saveCompany,
                    icon: Icon(Icons.save),
                    label: Text("Spremi", style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }

  Widget _buildInput(
      TextEditingController controller, String label, IconData icon) {
    bool isNumberField = label == 'Broj telefona' ||
        label == 'Porezni broj' ||
        label == 'Identifikacijski broj';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumberField
            ? TextInputType.number
            : label == 'Email' ? TextInputType.emailAddress : TextInputType.text,
        inputFormatters: isNumberField
            ? [
          FilteringTextInputFormatter.digitsOnly,
          if (label == 'Porezni broj' || label == 'Identifikacijski broj')
            LengthLimitingTextInputFormatter(13),
        ]
            : null,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Unesite $label';
          }

          if (label == 'Porezni broj' || label == 'Identifikacijski broj') {
            if (value.length != 13) {
              return 'Mora sadržavati tačno 13 cifara';
            }
          }

          if (label == 'Email') {
            final emailRegex = RegExp(
              r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
            );
            if (!emailRegex.hasMatch(value)) {
              return 'Unesite validnu email adresu';
            }
          }

          return null;
        },
      ),
    );
  }

}
