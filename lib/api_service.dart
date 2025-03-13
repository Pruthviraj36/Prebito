import 'dart:convert';
import 'package:http/http.dart' as http;
import 'profile.dart';

class ApiService {
  static const String baseUrl = 'https://67c589e1351c081993fa6ae6.mockapi.io/users';

  Future<List<Profile>> getProfiles() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      print("API Response: $data"); // Log the API response

      return data.map((json) => Profile.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load profiles');
    }
  }

  Future<List<Profile>> getFavorites() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      // Filter profiles where isFavorite is true
      return data
          .where((json) => json['isFavorite'] == true)
          .map((json) => Profile.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load favorites');
    }
  }

  Future<void> addProfile(Profile profile) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(profile.toJson()), // Sending Base64 image
    );
    if (response.statusCode != 201) {
      print("Failed to add profile. Status code: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to add profile');
    } else {
      print("Profile added successfully!");
    }
  }

  Future<void> updateProfile(Profile profile) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${profile.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(profile.toJson()), // Sending Base64 image
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update profile');
    }
  }

  Future<void> deleteProfile(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete profile');
    }
  }

  Future<void> toggleFavorite(Profile profile) async {
    final updatedProfile = Profile(
      id: profile.id,
      name: profile.name,
      email: profile.email,
      mobileNumber: profile.mobileNumber,
      age: profile.age,
      location: profile.location,
      gender: profile.gender,
      hobbies: profile.hobbies,
      imageUrl: profile.imageUrl,
      dateOfBirth: profile.dateOfBirth,
      isFavorite: !profile.isFavorite,
      password: profile.password,
      isOptap: profile.isOptap,
    );

    final response = await http.put(
      Uri.parse('$baseUrl/${profile.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedProfile.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to toggle favorite');
    }
  }

  Future<void> toggleOptap(Profile profile) async {
    final updatedProfile = Profile(
      id: profile.id,
      name: profile.name,
      email: profile.email,
      mobileNumber: profile.mobileNumber,
      age: profile.age,
      location: profile.location,
      gender: profile.gender,
      hobbies: profile.hobbies,
      imageUrl: profile.imageUrl,
      dateOfBirth: profile.dateOfBirth,
      isFavorite: profile.isFavorite,
      password: profile.password,
      isOptap: !profile.isOptap,
    );

    final response = await http.put(
      Uri.parse('$baseUrl/${profile.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedProfile.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to toggle optap status');
    }
  }
}