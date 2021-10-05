import 'package:flutter/material.dart';
import 'package:task_tree/models/projects.dart';
import 'package:provider/provider.dart';

import 'package:fluro/fluro.dart';
import 'package:task_tree/models/task_tree.dart';
import 'package:task_tree/routes/routes.dart';


class ProjectApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Project',
          theme: ThemeData(
            primarySwatch: Colors.indigo,
          ),
          home: ProjectScreen(),
        ),
        providers: [
          ChangeNotifierProvider(
              create: (context) => ProjectModel(),
          ),
          ChangeNotifierProvider(
              create: (context) => TreeModel(),
          ),

        ],
    );
    throw UnimplementedError();
  }
}


class ProjectScreen extends StatefulWidget{
  _ProjectScreenState createState() => _ProjectScreenState();
}


class _ProjectScreenState extends State<ProjectScreen> {
  int id = 0;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
      ),
      body: Consumer<ProjectModel>(
        builder: (BuildContext context, ProjectModel value, Widget child) {
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
                return Card(
                 child: GestureDetector(
                   child: ListTile(
                     title: Text(value.projects[index].title),
                   ),
                   onTap: () {
                     var path = '/projects/${this.id}/tree';
                     getRoutes().navigateTo(context, path);
                   },
                 )
               );
             },
            itemCount: value.projects.length,
          );

        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        foregroundColor: Colors.white,
        onPressed: () {
          var _project = Project('new Title');
          _ProjectModel.add(_project);
        },
      ),
    );
    throw UnimplementedError();
  }
}