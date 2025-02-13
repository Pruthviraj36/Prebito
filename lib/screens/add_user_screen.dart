import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import 'package:intl/intl.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _cityController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add User'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
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
              _buildTextField('Password', _passwordController,
                  TextInputType.visiblePassword,
                  isPassword: true),
              _buildTextField('Confirm Password', _confirmPasswordController,
                  TextInputType.visiblePassword,
                  isPassword: true),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newUser = User(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      fullName: _fullNameController.text,
                      email: _emailController.text,
                      mobileNumber: _mobileNumberController.text,
                      dateOfBirth: _dateOfBirthController.text,
                      city: _selectedCity ?? '',
                      gender: _selectedGender ?? '',
                      hobbies: _selectedHobbies,
                      password: _passwordController.text,
                    );

                    Provider.of<UserProvider>(context, listen: false)
                        .addUser(newUser);
                    Navigator.pop(context);
                  }
                },
                child: Text('Submit'),
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
              !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
            return 'Enter a valid email';
          }
          if (label == 'Mobile Number' &&
              !RegExp(r'^[0-9]{10}$').hasMatch(value)) {
            return 'Enter a valid 10-digit mobile number';
          }
          if (label == 'Password' && value.length < 6) {
            return 'Password must be at least 6 characters';
          }
          if (label == 'Confirm Password' &&
              value != _passwordController.text) {
            return 'Passwords do not match';
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
