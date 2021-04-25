import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_aws/loading_view.dart';
import 'package:todo_aws/models/ModelProvider.dart';
import 'package:todo_aws/todo_cubit.dart';
import 'package:todo_aws/todos_view.dart';
import './amplifyconfiguration.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _amplifyConfigured = false;

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider<TodoCubit>(
        create: (context) => TodoCubit()..getTodos(),
        child: !_amplifyConfigured ? LoadingView() : TodosView(),
      ),
    );
  }

  void _configureAmplify() async {
    Amplify.addPlugin(AmplifyDataStore(modelProvider: ModelProvider.instance));

    try {
      await Amplify.configure(amplifyconfig);
    } catch (e) {
      print(e);
    }
    setState(() {
      _amplifyConfigured = true;
    });
  }
}
