import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_aws/models/Todo.dart';
import 'package:todo_aws/todo_repository.dart';

abstract class TodoState {}

class LoadingTodos extends TodoState {}

class ListTodosSuccess extends TodoState {
  final List<Todo> todos;

  ListTodosSuccess({this.todos});
}

class ListTodosFailed extends TodoState {
  final Exception exception;

  ListTodosFailed({this.exception});
}

class TodoCubit extends Cubit<TodoState> {
  TodoCubit() : super(LoadingTodos());

  final _todoRepository = TodoRepository();

  void getTodos() async {
    if (state is ListTodosSuccess == false) {
      emit(LoadingTodos());
    }
    try {
      List<Todo> todos = await _todoRepository.getTodos();
      emit(ListTodosSuccess(todos: todos));
    } catch (e) {
      emit(ListTodosFailed(exception: e));
    }
  }

  void createTodo(String title) async {
    emit(LoadingTodos());
    try {
      await (_todoRepository.createTodo(title));
      getTodos();
    } catch (e) {
      emit(ListTodosFailed(exception: e));
    }
  }

  void updateTodoIsComplete(Todo todo, bool isComplete) async {
    emit(LoadingTodos());
    try {
      await _todoRepository.updateTodoIsComplete(todo, isComplete);
      getTodos();
    } catch (e) {
      emit(ListTodosFailed(exception: e));
    }
  }
}
