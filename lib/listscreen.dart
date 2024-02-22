// screens/todo_list_screen.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:provider/provider.dart';

import 'model/todo.dart';


class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  late Box<Todo> todoBox;

  @override
  void initState()  {
    super.initState();
    todoBox =  Hive.box<Todo>('todos');
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Todo List')),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ValueListenableBuilder(
        valueListenable: todoBox.listenable(),
        builder: (context, Box<Todo> box, _) {
          return ListView.separated(

            itemCount: box.length,
            itemBuilder: (context, index) {

              Todo todo = box.getAt(index)!;
              return ListTile(

                title: Text(todo.title,   style: const TextStyle(
                    color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red,),
                  onPressed: () {
                    box.deleteAt(index);
                  },
                ),

              );
            }, separatorBuilder: (BuildContext context, int index) {
            return const Divider(
              color: Colors.grey,
              height: 1,
              thickness: 2,
            );
          },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        tooltip: 'Add Todo',
        child: Icon(Icons.add),
      ),
    );
  }

  void _addTodo() {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController titleController = TextEditingController();

        return AlertDialog(
          title: Text('Add Todo'),
          content: TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'Enter Title'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String title = titleController.text.trim();

                if (title.isNotEmpty) {
                  todoBox.add(Todo(title.toString()));
                  Navigator.pop(context);
                }


              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
