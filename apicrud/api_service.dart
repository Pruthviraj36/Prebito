import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = "https://67cfaf0b823da0212a830258.mockapi.io/tasks/tasks/";

  // Add new task
  Future<void> addTask(String title, String desc) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-type': 'application/json'},
      body: jsonEncode({
        "title": title,
        "description": desc,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add task');
    }
  }

  // Fetch all tasks
  Future<List<Map<String, dynamic>>> fetchTasks() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      return data.map((task) {
        return {
          'id': task['id']?.toString() ?? "",
          'title': task['title']?.toString() ?? "",
          'description': task['description']?.toString() ?? "",
        };
      }).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  // Update a specific task
  Future<void> updateTask(String id, String title, String desc) async {
    final response = await http.put(
      Uri.parse('$baseUrl$id'),
      headers: {'Content-type': 'application/json'},
      body: jsonEncode({
        "title": title,
        "description": desc,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update task');
    }
  }

  // Delete a specific task
  Future<void> deleteTask(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }
}
