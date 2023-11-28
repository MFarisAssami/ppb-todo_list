import 'package:flutter/material.dart';
import 'package:todo_list/database.dart';
import 'package:todo_list/todo.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  const TodoList({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TodoList();
}

class _TodoList extends State<TodoList> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _descripCtrl = TextEditingController();

  List<Todo> todoList = [];

  final dbHelper = DatabaseHelper();

  @override
  void initState(){
    super.initState();
    refresh();
  }

  void refresh() async{
    final todos = await dbHelper.getAllTodos();
    setState(() {
      todoList = todos;
    });
  }

  void additems() async{
    await dbHelper.addTodo(Todo(_nameCtrl.text, _descripCtrl.text));
    // todoList.add(Todo(_nameCtrl.text, _descripCtrl.text));
    refresh();

    _nameCtrl.text = '';
    _descripCtrl.text = '';
  }

  void updateItem(int index, bool done) async {
      todoList[index].done = done;
      await dbHelper.updateTodo(todoList[index]);
      refresh();
  }

  void deleteItems(int id) async {
      //todoList.removeAt(index);
      await dbHelper.deleteTodo(id);
      refresh();
  }

  void popUpForm(){
    showDialog(context: context, builder: (context) => AlertDialog(
      insetPadding: const EdgeInsets.all(20),
      title: const Text("Add list"),
      actions: [
        ElevatedButton(onPressed: () {
          Navigator.pop(context);
        }, 
        child: const Text("close")),
        ElevatedButton(onPressed: () {
          additems();
          Navigator.pop(context);
        }, child: const Text("add")),
      ],
      content: SizedBox(
        height: 200,
        width: MediaQuery.of(context).size.width,
        child: Column(children: [
          TextField(controller: _nameCtrl,
          decoration: const InputDecoration(hintText: "Input Name"),
          ),
          TextField(controller: _descripCtrl,
          decoration: const InputDecoration(hintText: "Input Desc"),
          ),
        ],),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo-List App"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {popUpForm();}, child: const Icon(Icons.add_box),),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: todoList[index].done 
                  ? IconButton(icon: const Icon(Icons.check_circle), onPressed: () {
                    updateItem(index, !todoList[index].done);
                  },)
                  : IconButton(icon: const Icon(Icons.radio_button_unchecked), onPressed: () {
                    updateItem(index, !todoList[index].done);

                  },)
                  ,
                  title: Text(todoList[index].nama),
                  subtitle: Text(todoList[index].deskripsi),
                  trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () {
                    deleteItems(todoList[index].id ?? 0);
                  },),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
