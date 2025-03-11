class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final ApiService apiService = ApiService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<Map<String, dynamic>> tasks = [];
  String? _editingTaskId;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  // Load tasks from the API
  Future<void> _loadTasks() async {
    final fetchedTasks = await apiService.fetchTasks();
    setState(() {
      tasks = fetchedTasks;
    });
  }

  // Add a new task to the API
  Future<void> _addTask() async {
    final title = _titleController.text;
    final description = _descriptionController.text;
    if (title.isNotEmpty && description.isNotEmpty) {
      await apiService.addTask(title, description);
      _loadTasks();
      _titleController.clear();
      _descriptionController.clear();
    }
  }

  // Update an existing task on the API
  Future<void> _updateTask() async {
    if (_editingTaskId != null) {
      final title = _titleController.text;
      final description = _descriptionController.text;
      if (title.isNotEmpty && description.isNotEmpty) {
        await apiService.updateTask(_editingTaskId!, title, description);
        _loadTasks(); // Reload tasks after updating
        _titleController.clear();
        _descriptionController.clear();
        setState(() {
          _editingTaskId = null; // Reset to show Add Task
        });
      }
    }
  }

  // Delete a task from the API
  Future<void> _deleteTask(String id) async {
    await apiService.deleteTask(id);
    _loadTasks();
  }

  // Start editing a task
  void _startEditing(Map<String, dynamic> task) {
    setState(() {
      _editingTaskId = task['id'];
      _titleController.text = task['title'];
      _descriptionController.text = task['description'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Task Manager')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input fields for title and description
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Task Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Task Description'),
            ),
            SizedBox(height: 16),

            // Add or Save button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _editingTaskId == null ? _addTask : _updateTask,
                  child: Text(_editingTaskId == null ? 'Add Task' : 'Save Task'),
                ),
                if (_editingTaskId != null)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _editingTaskId = null;
                        _titleController.clear();
                        _descriptionController.clear();
                      });
                    },
                    child: Text('Cancel'),
                    style: ElevatedButton.styleFrom(primary: Colors.grey),
                  ),
              ],
            ),
            SizedBox(height: 16),

            // Display tasks
            Expanded(
              child: FutureBuilder(
                future: apiService.fetchTasks(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  tasks = snapshot.data ?? [];

                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(task['title'], style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(task['description']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _startEditing(task),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteTask(task['id']),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
