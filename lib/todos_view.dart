import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_aws/loading_view.dart';
import 'package:todo_aws/todo_cubit.dart';

import 'models/Todo.dart';

class TodosView extends StatefulWidget {
  @override
  _TodosViewState createState() => _TodosViewState();
}

class _TodosViewState extends State<TodosView> {
  TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _navBar(),
      body: BlocBuilder<TodoCubit, TodoState>(
        builder: (context, state) {
          if (state is ListTodosFailed) {
            return Center(
              child: Text(state.exception.toString()),
            );
          } else if (state is ListTodosSuccess) {
            return state.todos.isEmpty
                ? _emptyTodosView()
                : _todosListView(state.todos);
          } else {
            return LoadingView();
          }
        },
      ),
      floatingActionButton: _floatingActionButton(),
    );
  }

  Widget _todosListView(List<Todo> todos) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return Card(
          child: CheckboxListTile(
            title: Text(
              todo.title,
            ),
            value: todo.isCompleted,
            onChanged: (value) {
              context.read<TodoCubit>().updateTodoIsComplete(
                    todo,
                    value,
                  );
            },
          ),
        );
      },
    );
  }

  Widget _emptyTodosView() {
    return Center(
      child: Text('No todos yet'),
    );
  }

  AppBar _navBar() {
    return AppBar(
      title: Text('Todos'),
      centerTitle: true,
    );
  }

  Widget newTodoView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextField(
            controller: _titleController,
            decoration: InputDecoration(hintText: 'Enter todo title'),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<TodoCubit>().createTodo(_titleController.text);
            _titleController.text = "";
            Navigator.of(context).pop();
          },
          child: Text('Save Todo'),
        ),
      ],
    );
  }

  Widget _floatingActionButton() {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => newTodoView(),
        );
      },
    );
  }
}
