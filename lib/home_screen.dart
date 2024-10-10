import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoHomePage extends StatefulWidget {

  @override
  _TodoHomePageState createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  List<Map<String, dynamic>> _todoList = [];
  TextEditingController _textController = TextEditingController();
  int? _editingIndex; // Track the index of the task being edited
  bool _isEditing = false; // Track if we are in editing mode

  @override
  void initState() {
    super.initState();
    _loadTodoList(); // Load the saved tasks when the app starts
  }

  // Function to save tasks to shared_preferences
  void _saveTodoList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonTodoList = jsonEncode(_todoList); // Convert list to JSON string
    prefs.setString('todoList', jsonTodoList); // Save JSON string to preferences
  }

  // Function to load tasks from shared_preferences
  void _loadTodoList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonTodoList = prefs.getString('todoList');
    if (jsonTodoList != null) {
      setState(() {
        _todoList = List<Map<String, dynamic>>.from(
            jsonDecode(jsonTodoList)); // Convert JSON string back to list
      });
    }
  }

  // Function to add or edit a task
  void _addOrEditTodoItem(String task) {
    if (task.isNotEmpty) {
      setState(() {
        if (_isEditing && _editingIndex != null) {
          // Update the task if editing
          _todoList[_editingIndex!] = {'task': task, 'isChecked': false};
          _isEditing = false;
          _editingIndex = null;
        } else {
          // Add a new task
          _todoList.add({'task': task, 'isChecked': false});
        }
        _saveTodoList(); // Save tasks whenever a new task is added or edited
      });
      _textController.clear(); // Clear the text field
    }
  }

  // Function to remove a task
  void _removeTodoItem(int index) {
    setState(() {
      _todoList.removeAt(index);
      _saveTodoList(); // Save tasks whenever a task is removed
    });
  }

  // Function to toggle checkbox
  void _toggleCheckbox(bool? value, int index) {
    setState(() {
      _todoList[index]['isChecked'] = value;
      _saveTodoList(); // Save tasks whenever a task is checked/unchecked
    });
  }

  // Function to edit a task
  void _editTodoItem(int index) {
    setState(() {
      _textController.text = _todoList[index]['task']; // Set the text field with the task's current value
      _isEditing = true; // Enable editing mode
      _editingIndex = index; // Store the index of the task being edited
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('To - Do App'),
      ),
      body: Column(
        children: [
          Expanded(child: _buildTodoList()), // Task list
          _buildTaskInputField(), // Input field
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        onPressed: () => _addOrEditTodoItem(_textController.text),
        child: Icon(_isEditing ? Icons.edit : Icons.add), // Show 'edit' icon if editing, 'add' otherwise
      ),
    );
  }

  // Widget to build the task input field
  Widget _buildTaskInputField() {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 80, bottom: 15),
      child: TextField(
        controller: _textController,
        decoration: InputDecoration(
          labelText: _isEditing ? 'Edit task' : 'Enter a new task', // Change label when editing
          labelStyle: TextStyle(color: Colors.blueGrey),
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder( // Border when not focused
            borderSide: BorderSide(color: Colors.blueGrey),
          ),
          focusedBorder: OutlineInputBorder( // Border when focused
            borderSide: BorderSide(color: Colors.blueGrey, width: 2.0), // Change to your desired color and thickness
          ),
        ),
        onSubmitted: _addOrEditTodoItem,
      ),
    );
  }

  // Widget to build the list of tasks
  Widget _buildTodoList() {
    return ListView.builder(
      itemCount: _todoList.length,
      itemBuilder: (context, index) {
        return _buildTodoItem(index);
      },
    );
  }

  // Widget to build each ToDo item
  Widget _buildTodoItem(int index) {
    final todo = _todoList[index];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
          leading: Checkbox(
            value: todo['isChecked'],
            onChanged: (value) => _toggleCheckbox(value, index),
          ),
          title: Text(
            todo['task'],
            style: TextStyle(
              decoration: todo['isChecked']
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue),
                onPressed: () => _editTodoItem(index), // Edit the task when the edit button is pressed
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => _removeTodoItem(index), // Delete the task
              ),
            ],
          ),
        ),
      ),
    );
  }
}