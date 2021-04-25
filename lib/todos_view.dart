import 'dart:ffi';

import 'package:flutter/material.dart';

class TodosView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _navBar(),
      body: _emptyTodosView(),
      floatingActionButton: _floatingActionButton(),
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

  Widget _floatingActionButton() {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {},
    );
  }
}
