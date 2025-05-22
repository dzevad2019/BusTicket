import 'package:bus_ticket_mobile/models/listItem.dart';
import 'package:bus_ticket_mobile/models/user_upsert_model.dart';
import 'package:bus_ticket_mobile/providers/base_provider.dart';
import 'package:bus_ticket_mobile/providers/dropdown_provider.dart';
import 'package:bus_ticket_mobile/providers/users_provider.dart';
import 'package:bus_ticket_mobile/utils/authorization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:provider/provider.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({Key? key}) : super(key: key);

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _oldPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;

  DropdownProvider? _dropdownProvider;
  UsersProvider? _usersProvider;
  DateTime? _birthDate;
  ListItem? _selectedGender;
  String? _profilePhoto;
  String? _networkProfilePhoto;
  List<ListItem> genders = [];
  bool _isPasswordSectionExpanded = false;
  bool _enableNotificationEmail = false;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _dropdownProvider = context.read<DropdownProvider>();
    _usersProvider = context.read<UsersProvider>();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    loadUser();
  }

  Future<void> loadUser() async {

    setState(() {
      _isLoading = true;
    });
    await loadGenders();

    var response = await _usersProvider!.getById(Authorization.id, null);
    setState(() {
      _firstNameController.text = response.firstName;
      _lastNameController.text = response.lastName;
      _emailController.text = response.email;
      _phoneController.text = response.phoneNumber;
      _addressController.text = response.address;
      _birthDate = response.birthDate;
      _selectedGender = genders.isNotEmpty ? genders.firstWhere((x) => x.key == response.gender) : null;
      _networkProfilePhoto = response.profilePhoto;
      _enableNotificationEmail = response.enableNotificationEmail;
      _isLoading = false;
    });
  }

  Future<void> loadGenders() async {
    var response = await _dropdownProvider!.getItems("genders");
    setState(() {
      genders = response! ?? [];
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _profilePhoto = base64Encode(bytes);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Colors.white,
              surface: Theme.of(context).cardColor,
              onSurface: Theme.of(context).textTheme.bodyLarge!.color!,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

        final updatedUser = UserUpsertModel(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          phoneNumber: _phoneController.text,
          birthDate: _birthDate,
          profilePhoto: _profilePhoto,
          address: _addressController.text,
            newPassword: _newPasswordController.text.isNotEmpty ? _newPasswordController.text : null,
          oldPassword: _oldPasswordController.text.isNotEmpty ? _oldPasswordController.text : null,
          gender: _selectedGender!.key,
          enableNotificationEmail: _enableNotificationEmail
        );

        var success = await _usersProvider!.update(updatedUser);

        if (success){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Profil uspješno ažuriran'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
        else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Dogodila se greška prilikom ažuriranja profila'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }

      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final surfaceColor = theme.colorScheme.surface;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
        decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.primaryColor, theme.primaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: _isLoading
              ? Center(child: CircularProgressIndicator(strokeWidth: 2, color: Colors.purple))
              : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile photo section
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: _profilePhoto != null
                        ? MemoryImage(base64Decode(_profilePhoto!))
                        : (_networkProfilePhoto != null && _networkProfilePhoto!.isNotEmpty
                        ? NetworkImage("${BaseProvider.apiUrl}/${_networkProfilePhoto!}")
                        : null) as ImageProvider?,
                    child: (_profilePhoto == null &&
                        (_networkProfilePhoto == null || _networkProfilePhoto!.isEmpty))
                        ? Icon(Icons.person, size: 40, color: Colors.grey)
                        : null,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Personal info section
              _buildSectionTitle('Lični podaci', theme),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildTextFormField(
                      controller: _firstNameController,
                      label: 'Ime',
                      icon: Icons.person_outline,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZšđčćžŠĐČĆŽ\s]')),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Molimo unesite vaše ime';
                        }
                        if (value.length < 2) {
                          return 'Ime mora imati najmanje 2 karaktera';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextFormField(
                      controller: _lastNameController,
                      label: 'Prezime',
                      icon: Icons.person_outline,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZšđčćžŠĐČĆŽ\s]')),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Molimo unesite vaše prezime';
                        }
                        if (value.length < 2) {
                          return 'Prezime mora imati najmanje 2 karaktera';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildTextFormField(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email_outlined,
                enabled: false,
                filled: true,
              ),
              const SizedBox(height: 16),

              _buildTextFormField(
                controller: _phoneController,
                label: 'Broj telefona',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Molimo unesite vaš broj telefona';
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
              const SizedBox(height: 16),

              Row(
                children: [
                    Expanded(
                    child: InkWell(
                    onTap: () => _selectDate(context),
                    borderRadius: BorderRadius.circular(12),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Datum rođenja',
                        prefixIcon: Icon(
                          Icons.calendar_today_outlined,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: theme.dividerColor),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        isDense: true,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              _birthDate != null
                                  ? '${_birthDate!.day.toString().padLeft(2, '0')}.${_birthDate!.month.toString().padLeft(2, '0')}.${_birthDate!.year}'
                                  : 'Odaberite datum',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: _birthDate != null
                                    ? theme.textTheme.bodyMedium?.color
                                    : theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.arrow_drop_down,
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  ),
                  const SizedBox(width: 12), // Slightly reduced spacing
                  Expanded(
                    child: DropdownButtonFormField<ListItem>(
                      value: _selectedGender,
                      decoration: InputDecoration(
                        labelText: 'Spol',
                        prefixIcon: Icon(Icons.transgender_outlined,
                            color: theme.colorScheme.onSurface.withOpacity(0.6)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: theme.dividerColor),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12), // Reduced padding
                        isDense: true, // Makes the field more compact
                      ),
                      dropdownColor: surfaceColor,
                      borderRadius: BorderRadius.circular(12),
                      icon: Icon(Icons.arrow_drop_down,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                          size: 20), // Smaller icon
                      items: genders.map((gender) {
                        return DropdownMenuItem<ListItem>(
                          value: gender,
                          child: Text(
                            gender.value,
                            style: theme.textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis, // Handle overflow
                          ),
                        );
                      }).toList(),
                      onChanged: (ListItem? value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Molimo odaberite spol';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Address
              _buildTextFormField(
                controller: _addressController,
                label: 'Adresa',
                icon: Icons.home_outlined,
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Molimo unesite vašu adresu';
                  }
                  if (value.length < 5) {
                    return 'Adresa mora imati najmanje 5 karaktera';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Notification preferences
              _buildSectionTitle('Postavke obavještenja', theme),
              const SizedBox(height: 16),

              CheckboxListTile(
                title: Text('Omogući slanje obavijesti putem email-a',
                    style: theme.textTheme.bodyMedium),
                value: _enableNotificationEmail,
                onChanged: (bool? value) {
                  setState(() {
                    _enableNotificationEmail = value ?? false;
                  });
                },
                secondary: Icon(Icons.email_outlined,
                    color: theme.colorScheme.onSurface.withOpacity(0.6)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                activeColor: theme.colorScheme.primary,
                checkColor: Colors.white,
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
              ),
              const SizedBox(height: 16),

              // Password change section
              Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: theme.dividerColor.withOpacity(0.3),
                  ),
                ),
                child: Theme(
                  data: theme.copyWith(
                    dividerColor: Colors.transparent,
                  ),
                  child: ExpansionTile(
                    title: Text('Promijeni lozinku',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        )),
                    initiallyExpanded: false,
                    onExpansionChanged: (expanded) {
                      setState(() {
                        _isPasswordSectionExpanded = expanded;
                      });
                    },
                    trailing: Icon(
                      _isPasswordSectionExpanded ? Icons.expand_less : Icons.expand_more,
                      color: primaryColor,
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Column(
                          children: [
                            _buildTextFormField(
                              controller: _oldPasswordController,
                              label: 'Trenutna lozinka',
                              icon: Icons.lock_outline,
                              obscureText: true,
                              validator: (value) {
                                if (_isPasswordSectionExpanded && (value == null || value.isEmpty)) {
                                  return 'Molimo unesite trenutnu lozinku';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            _buildTextFormField(
                              controller: _newPasswordController,
                              label: 'Nova lozinka',
                              icon: Icons.lock_outline,
                              obscureText: true,
                              validator: (value) {
                                if (_isPasswordSectionExpanded) {
                                  if (value == null || value.isEmpty) {
                                    return 'Molimo unesite novu lozinku';
                                  }
                                  if (value.length < 6) {
                                    return 'Lozinka mora imati najmanje 6 karaktera';
                                  }
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            _buildTextFormField(
                              controller: _confirmPasswordController,
                              label: 'Potvrdi novu lozinku',
                              icon: Icons.lock_outline,
                              obscureText: true,
                              validator: (value) {
                                if (_isPasswordSectionExpanded) {
                                  if (value == null || value.isEmpty) {
                                    return 'Molimo potvrdite novu lozinku';
                                  }
                                  if (value != _newPasswordController.text) {
                                    return 'Lozinke se ne podudaraju';
                                  }
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Save button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  shadowColor: Colors.black.withOpacity(0.2),
                ),
                onPressed: _isLoading ? null : _submitForm,
                child: _isLoading
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Text(
                  'SPREMI PROMJENE',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Row(
      children: [
        Container(
          height: 24,
          width: 4,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    bool enabled = true,
    bool filled = false,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters
  }) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: theme.colorScheme.onSurface.withOpacity(0.6)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.error, width: 1.5),
        ),
        filled: filled,
        fillColor: filled ? theme.colorScheme.surfaceVariant.withOpacity(0.3) : null,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        isDense: true,
      ),
      obscureText: obscureText,
      enabled: enabled,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      inputFormatters: inputFormatters,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: enabled ? theme.textTheme.bodyMedium?.color : theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
      ),
    );
  }
}