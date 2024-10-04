import 'package:flutter/material.dart';
import 'package:new_project/todo.dart';
import 'package:new_project/todo_db.dart';
import 'add_todo.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  TodoDatabase db_object = TodoDatabase();
  List<Todo> todos = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadTodos();
  }

  // Loading Todo
  _loadTodos() async {
    var todolist = await db_object.getAllTodos();
    setState(() {
      todos = todolist;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Todo App",
          style: TextStyle(color: Colors.white),
        ),
        // backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(todos[index].title),
                  subtitle: Text(
                      "${todos[index].description} - ${todos[index].date}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await db_object.deleteTodo(todos[index].id!);
                      _loadTodos();
                    },
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddTodo()),
                  ).then((_) {
                    _loadTodos();
                  });
                },
                child: const Text("Add Task"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await db_object.deleteAll();
                  _loadTodos();
                },
                child: const Text("Delete All"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
