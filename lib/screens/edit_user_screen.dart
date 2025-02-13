import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import 'package:intl/intl.dart';

class EditUserScreen extends StatefulWidget {
  final User user;

  const EditUserScreen({super.key, required this.user});

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _mobileNumberController;
  late TextEditingController _dateOfBirthController;
  String? _selectedGender;
  final List<String> _selectedHobbies = [];
  final List<String> _cities = [
    'New York',
    'Los Angeles',
    'Chicago',
    'Houston',
    'Phoenix'
  ];
  String? _selectedCity;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.user.fullName);
    _emailController = TextEditingController(text: widget.user.email);
    _mobileNumberController =
        TextEditingController(text: widget.user.mobileNumber);
    _dateOfBirthController =
        TextEditingController(text: widget.user.dateOfBirth);
    _selectedCity = widget.user.city;
    _selectedGender = widget.user.gender;
    _selectedHobbies.addAll(widget.user.hobbies);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _mobileNumberController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  Future<void> _saveUser() async {
    if (_formKey.currentState!.validate()) {
      User updatedUser = User(
        id: widget.user.id,
        fullName: _fullNameController.text,
        email: _emailController.text,
        mobileNumber: _mobileNumberController.text,
        dateOfBirth: _dateOfBirthController.text,
        city: _selectedCity ?? '',
        gender: _selectedGender ?? '',
        hobbies: _selectedHobbies,
        password: widget.user.password,
        isFavorite: widget.user.isFavorite,
      );

      Provider.of<UserProvider>(context, listen: false).updateUser(updatedUser);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User  updated successfully!')),
      );
// Close the edit screen
      Navigator.pop(context);
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this user?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Provider.of<UserProvider>(context, listen: false)
                    .deleteUser(widget.user.id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User deleted successfully!')),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _confirmDelete,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                  'Full Name', _fullNameController, TextInputType.name),
              _buildTextField(
                  'Email', _emailController, TextInputType.emailAddress),
              _buildTextField('Mobile Number', _mobileNumberController,
                  TextInputType.phone),
              _buildDatePickerField('Date of Birth', _dateOfBirthController),
              _buildDropdownField('City', _selectedCity, _cities, (value) {
                setState(() {
                  _selectedCity = value;
                });
              }),
              _buildGenderRadioButtons(),
              _buildHobbiesCheckboxes(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveUser,
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      TextInputType keyboardType,
      {bool isPassword = false}) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          if (label == 'Email' &&
              !RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]$').hasMatch(value)) {
            return 'Enter a valid email';
          }
          if (label == 'Mobile Number' &&
              !RegExp(r'^[0-9]{10}$').hasMatch(value)) {
            return 'Enter a valid 10-digit mobile number';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDatePickerField(String label, TextEditingController controller) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
          suffixIcon: Icon(Icons.calendar_today),
        ),
        onTap: () => _selectDate(context),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          return null;
        },
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateOfBirthController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Widget _buildDropdownField(String label, String? selectedValue,
      List<String> items, Function(String?) onChanged) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildGenderRadioButtons() {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Gender',
                style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            Row(
              children: [
                Radio<String>(
                  value: 'Male',
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                ),
                Text('Male'),
                Radio<String>(
                  value: 'Female',
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                ),
                Text('Female'),
                Radio<String>(
                  value: 'Other',
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                ),
                Text('Other'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHobbiesCheckboxes() {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hobbies',
                style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            Wrap(
              children:
                  ['Reading', 'Traveling', 'Cooking', 'Sports'].map((hobby) {
                return CheckboxListTile(
                  title: Text(hobby),
                  value: _selectedHobbies.contains(hobby),
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        _selectedHobbies.add(hobby);
                      } else {
                        _selectedHobbies.remove(hobby);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
