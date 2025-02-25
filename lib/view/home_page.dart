import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // get the box
  final _todobox = Hive.box('todo_box');

  // text controller for the text field
  final _textController = TextEditingController();

  // list of todos
  List todos = [];

  @override
  void initState() {
    // get the todos, if none then set an empty list
    todos = _todobox.get('TODOS') ?? [];
    super.initState();
  }

  // open new todo dialog
  void _openDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Add a new todo'),
              content: TextField(
                autofocus: true,
                controller: _textController,
              ),
              actions: [
                // cancel button
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _textController.clear();
                    },
                    child: const Text('Cancel')),

                // save/add button
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      addToDo();
                    },
                    child: const Text('Add')),
              ],
            ));
  }

  // add new todo
  void addToDo() {
    String todo = _textController.text;
    setState(() {
      todos.add(todo);
      _textController.clear();
    });
  }

  // delete todo
  void deleteTodo(int index) {
    setState(() {
      todos.removeAt(index);
    });
    saveToDatabase();
  }

  // save to database to HIVE
  void saveToDatabase() {
    _todobox.put('TODOS', todos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        // todo add button
        floatingActionButton: FloatingActionButton(
          onPressed: _openDialog,
          child: const Icon(Icons.add),
        ),

        // disply list of todos
        body: ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              // get the todos
              final todo = todos[index];

              return ListTile(
                title: Text(todo),
                trailing: IconButton(
                  onPressed: () => deleteTodo(index),
                  icon: const Icon(Icons.delete),
                ),
              );
            }));
  }
}
