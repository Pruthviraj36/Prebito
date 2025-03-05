import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mat_app/profile.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class ProfileDetailPage extends StatefulWidget {
  final Profile profile;

  const ProfileDetailPage({required this.profile, super.key});

  @override
  State<ProfileDetailPage> createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.profile.name),
        actions: [
          IconButton(
            icon: Icon(
              Provider.of<ProfileManager>(context, listen: true).isFavorite(widget.profile)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: () async {
              await Provider.of<ProfileManager>(context, listen: false)
                  .toggleFavorite(widget.profile);
              setState(() {}); // Refresh UI after update
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: widget.profile.imageUrl.isNotEmpty
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.profile.imageUrl,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              )
                  : const Icon(
                Icons.person,
                size: 150,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            _buildDetailRow("Name", widget.profile.name),
            _buildDetailRow("Email", widget.profile.email),
            _buildDetailRow("Mobile Number", widget.profile.mobileNumber),
            _buildDetailRow(
              "Date of Birth",
              widget.profile.dateOfBirth.isNotEmpty
                  ? DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.profile.dateOfBirth))
                  : 'Not specified',
            ),
            _buildDetailRow("Age", "${widget.profile.age} years"),
            _buildDetailRow("Location", widget.profile.location),
            _buildDetailRow("Gender", widget.profile.gender),
            _buildDetailRow(
              "Hobbies",
              widget.profile.hobbies.isNotEmpty
                  ? widget.profile.hobbies.split(',').join(", ") // Fix hobbies display
                  : "No hobbies specified",
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                ),
                onPressed: () {
                  Provider.of<ProfileManager>(context, listen: false)
                      .toggleFavorite(widget.profile);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        Provider.of<ProfileManager>(context)
                            .isFavorite(widget.profile)
                            ? 'Added to Favorites'
                            : 'Removed from Favorites',
                      ),
                    ),
                  );
                  setState(() {}); // Refresh the UI
                },
                icon: Icon(
                  Provider.of<ProfileManager>(context)
                      .isFavorite(widget.profile)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.white,
                ),
                label: Text(
                  Provider.of<ProfileManager>(context)
                      .isFavorite(widget.profile)
                      ? 'Remove from Favorites'
                      : 'Add to Favorites',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Divider(
            color: Colors.grey.shade300,
            thickness: 1,
          ),
        ],
      ),
    );
  }
}