import 'package:flutter/material.dart';

class ProjectModel extends ChangeNotifier {
  List<Project> _Projects = <Project>[
    Project("test1"),
    Project("test2"),
    Project("test3"),
  ];

  List<Project> get projects => _Projects;

  //新しいProjectを追加
  void add(Project project) {
    _Projects.add(project);
    // 変更があったことを通知する。
    notifyListeners();
  }
}

class Project {
  const Project(this.title);
  final String title;
}
