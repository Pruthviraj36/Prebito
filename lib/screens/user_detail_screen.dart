import 'package:flutter/material.dart';
import '../models/user.dart';

class UserDetailScreen extends StatelessWidget {
  final User user;

  const UserDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final age = _calculateAge(user.dateOfBirth);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: Icon(Icons.person, color: Colors.blueAccent),
                  title: Text(user.fullName,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  subtitle: Text(user.email, style: TextStyle(fontSize: 16, color: Colors.grey)),
                ),
                Divider(),
                _buildInfoRow(Icons.phone, "Mobile Number", user.mobileNumber),
                _buildInfoRow(Icons.cake, "Date of Birth", "${user.dateOfBirth} (Age: $age)"),
                _buildInfoRow(Icons.location_city, "City", user.city),
                _buildInfoRow(Icons.wc, "Gender", user.gender),
                _buildInfoRow(Icons.sports_soccer, "Hobbies", user.hobbies.join(", ")),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent),
          SizedBox(width: 12),
          Text("$label: ", style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(value, style: TextStyle(color: Colors.grey[700])),
          ),
        ],
      ),
    );
  }

  int _calculateAge(String birthDateString) {
    try {
      List<String> parts = birthDateString.split("/");
      if (parts.length != 3) return 0;

      String formattedDate = "${parts[2]}-${parts[1]}-${parts[0]}";
      DateTime birthDate = DateTime.parse(formattedDate);

      DateTime today = DateTime.now();
      int age = today.year - birthDate.year;
      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      return age;
    } catch (e) {
      return 0;
    }
  }
}
