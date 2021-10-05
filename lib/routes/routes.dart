import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:task_tree/screens/conditions.dart';

import 'package:task_tree/screens/projects.dart';
import 'package:task_tree/screens/ex_line.dart';
import 'package:task_tree/screens/task_tree.dart';

var projectsHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return ProjectScreen();
});

var lineHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return LineScreen();
});

var treeHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return TreeScreen();
});

var conditionHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
//  var nodeId = int.parse(params['nodeId']);
  var nodeId = int.parse(params['nodeId'][0]);
  print(nodeId);
  return ConditionsScreen(nodeId);
});


void defineRoutes(FluroRouter router) {
  router.define("/projects/", handler: projectsHandler);
//  router.define("/projects/:id/line", handler: lineHandler);
  router.define("/projects/:id/tree", handler: treeHandler);
  router.define("project/:id/tree/:nodeId/condition", handler: conditionHandler);
  // it is also possible to define the route transition to use
  // router.define("users/:id", handler: usersHandler, transitionType: TransitionType.inFromLeft);
}

FluroRouter getRoutes(){
  final router = FluroRouter();
  defineRoutes(router);
  return router;
}

class MyRoute {
  final router = FluroRouter();
  MyRoute(){
    defineRoutes(this.router);
  }

}

