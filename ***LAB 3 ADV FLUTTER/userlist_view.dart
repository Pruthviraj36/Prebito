import '../utils/import_export.dart';

class UserlistView extends StatefulWidget {
  const UserlistView({super.key});

  @override
  State<UserlistView> createState() => _UserlistViewState();
}

class _UserlistViewState extends State<UserlistView> {
  TextEditingController nameController = TextEditingController();
  UserListController listController = UserListController();
  int? editingIndex;

  @override
  Widget build(BuildContext context) {
    List<dynamic> users = listController.getUsers();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SIMPLE CRUD WITH UI DESIGN',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Enter the Name',
                hintText: 'Name',
                labelStyle: TextStyle(color: Colors.grey.shade600),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide:
                      BorderSide(color: Colors.grey.shade400, width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide:
                      BorderSide(color: Colors.grey.shade400, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  if (editingIndex != null) {
                    listController.updateUser(
                        editingIndex!, nameController.text);
                    setState(() {
                      editingIndex = null;
                    });
                  } else {
                    listController.addUser(nameController.text);
                  }
                  nameController.clear();
                  setState(() {});
                }
              },
              child: Text(editingIndex != null ? 'Update' : 'Submit'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: users.isEmpty
                  ? const Center(child: Text('No users added yet'))
                  : ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(users[index]),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Colors.cyanAccent),
                                onPressed: () {
                                  setState(() {
                                    nameController.text = users[index];
                                    editingIndex = index;
                                  });
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.redAccent),
                                onPressed: () {
                                  listController.deleteUser(index);
                                  setState(() {});
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
