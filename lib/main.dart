import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
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
        create: (context) => TodoCubit()
          ..getTodos()
          ..observeTodo(),
        child: !_amplifyConfigured ? LoadingView() : TodosView(),
      ),
    );
  }

  void _configureAmplify() async {
    try {
      Future.wait([
        Amplify.addPlugin(
          AmplifyDataStore(
            modelProvider: ModelProvider.instance,
          ),
        ),
        Amplify.addPlugin(AmplifyAPI()),
        Amplify.addPlugin(AmplifyAuthCognito()),
      ]);
      await Amplify.configure(amplifyconfig);
      setState(() {
        _amplifyConfigured = true;
      });
    } catch (e) {
      print(e);
    }
  }
}
