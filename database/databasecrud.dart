import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late Database _database;
  List<Map<String, dynamic>> _users = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  int? _editingId;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'users.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT, age INTEGER)",
        );
      },
      version: 1,
    );
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final List<Map<String, dynamic>> users = await _database.query('users');
    setState(() {
      _users = users;
    });
  }

  Future<void> _addOrUpdateUser() async {
    final name = _nameController.text;
    final email = _emailController.text;
    final age = int.tryParse(_ageController.text) ?? 0;

    if (_editingId == null) {
      await _database
          .insert('users', {'name': name, 'email': email, 'age': age});
    } else {
      await _database.update(
        'users',
        {'name': name, 'email': email, 'age': age},
        where: 'id = ?',
        whereArgs: [_editingId],
      );
      _editingId = null;
    }

    _nameController.clear();
    _emailController.clear();
    _ageController.clear();
    _fetchUsers();
  }

  Future<void> _deleteUser(int id) async {
    await _database.delete('users', where: 'id = ?', whereArgs: [id]);
    _fetchUsers();
  }

  void _editUser(Map<String, dynamic> user) {
    setState(() {
      _editingId = user['id'];
      _nameController.text = user['name'];
      _emailController.text = user['email'];
      _ageController.text = user['age'].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Users CRUD')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name')),
                TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email')),
                TextField(
                    controller: _ageController,
                    decoration: InputDecoration(labelText: 'Age'),
                    keyboardType: TextInputType.number),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _addOrUpdateUser,
                  child: Text(_editingId == null ? 'Add User' : 'Update User'),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return ListTile(
                  title: Text(user['name']),
                  subtitle: Text('${user['email']} - Age: ${user['age']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _editUser(user)),
                      IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteUser(user['id'])),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
