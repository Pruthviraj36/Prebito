import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseCrud extends StatefulWidget {
  const DatabaseCrud({super.key});

  @override
  State<DatabaseCrud> createState() => _DatabaseCrudState();
}

class _DatabaseCrudState extends State<DatabaseCrud> {
  late Database _database;
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  List<Map<String, dynamic>> userData = [];

  Future<void> _createDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'pruthviraj.db'),
      onCreate: (db, version) {
        return db.execute(
          """
            CREATE TABLE database_crud(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT,
              age INTEGER
            )
          """,
        );
      },
      version: 1,
    );
  }

  Future<void> _fetchUserData() async {
    final data = await _database.query('database_crud');
    setState(() {
      userData = data;
    });
  }

  Future<void> _addUser() async {
    if (nameController.text.isNotEmpty && ageController.text.isNotEmpty) {
      await _database.insert(
        'database_crud',
        {
          'name': nameController.text,
          'age': int.parse(ageController.text),
        },
      );
      nameController.clear();
      ageController.clear();
      _fetchUserData();
    }
  }

  Future<void> _deleteUser(int id) async {
    await _database.delete(
      'database_crud',
      where: 'id = ?',  // Fixed the typo here
      whereArgs: [id],
    );
    _fetchUserData();  // Refresh data after deletion
  }

  @override
  void initState() {
    super.initState();
    _createDatabase().then((_) => _fetchUserData());
  }

  @override
  Widget build(BuildContext context) {
    void _editUser(int id) async {
      nameController.text = userData.firstWhere((user) => user['id'] == id)['name'];
      ageController.text = userData.firstWhere((user) => user['id'] == id)['age'].toString();

      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Edit User'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: ageController,
                  decoration: const InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  if (nameController.text.isNotEmpty &&
                      ageController.text.isNotEmpty) {
                    await _database.update(
                      'database_crud',
                      {
                        'name': nameController.text,
                        'age': int.parse(ageController.text),
                      },
                      where: 'id = ?',
                      whereArgs: [id],
                    );
                    nameController.clear();
                    ageController.clear();
                    _fetchUserData();
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Database CRUD')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: _addUser,
              child: const Text('Add User'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: userData.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(userData[index]['name']),
                    subtitle: Text('Age: ${userData[index]['age']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Edit icon
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _editUser(userData[index]['id']);
                          },
                        ),
                        // Delete icon
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Are you sure?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        _deleteUser(userData[index]['id']);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Delete'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
