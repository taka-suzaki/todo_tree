import 'package:flutter/material.dart';
import 'package:task_tree/models/task_tree.dart';
import 'package:provider/provider.dart';

import 'package:fluro/fluro.dart';
import 'package:task_tree/routes/routes.dart';
import 'package:task_tree/widgets/arrow.dart';
import 'package:task_tree/widgets/node.dart';


class TreeScreen extends StatefulWidget {
  _TreeScreenState createState() => _TreeScreenState();
}

class _TreeScreenState extends State<TreeScreen> {
  int cnt = 0;
  @override
  Widget build(BuildContext context) {
    var _TreeModel = Provider.of<TreeModel>(context);
    print("ddddd");

    return Consumer<TreeModel>(
        builder: (BuildContext context, TreeModel value, Widget child) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Tree'),
            ),
            body: InteractiveViewer(
              constrained: false,
              child: TreeWidget(value),
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: (){
                int id;
                if (value.all_nodes.length > 0) {
                  id = cnt;
                } else {
                  id = -1;
                }
                Node node = Node(id: value.count + 1, title: 'A');
                value.addChild(-1, node);
                cnt++;
              },
            ),
          );
        }
    );
    throw UnimplementedError();
  }


  Widget TreeWidget(TreeModel value) {
    print("@@@@@@@@@@@@@@@@@@@@");
    Size screenSize = MediaQuery.of(context).size;
    double width = 0, height = 0;

    var nodeTree = value.toList();
    double margin = 15;
    double nodeWidth = 120;
    double nodeHeight = 60;
    int depth = nodeTree.length;
    if (depth > 0) {
      int maxWidth = nodeTree[getDepthMaxWidth(nodeTree)].length;
      width = maxWidth * nodeWidth + margin*(maxWidth-1);
      height = (2 * depth - 1) * nodeHeight;
    }
//    width = (width < screenSize.width) ? screenSize.width : width;
//    height = (height < screenSize.height) ? screenSize.height : height;

    List<Widget> widgets = drawTree(nodeTree: nodeTree, width: width, height: height, nodeWidth: nodeWidth, nodeHeight: nodeHeight);
    print("@@@@@@@@@@@@@@@@@@");
    return Container(
      width: width,
      height: height,
      color: Colors.red,
      child: Stack(
        children: widgets,
      ),
    );
  }

//  List<Widget> drawTree({@required var nodeTree, double nodeWidth, double nodeHeight}){
//    double width = 600;
//    double height = 1000;
//    double node_width = 120;
//    double node_height = 60;
//    double space = 15;
//
//    int maxDepth = getDepthMaxWidth(nodeTree);
//    double center_x, center_y;
//    double left, top;
//
//
//    List<Widget> widgets = [];
//    List<Widget> arrowList = [];
//
//    for (int i = 0; i < nodeTree.length; i++) {
//      int node_len = nodeTree[i].length;
//      center_y = space/2 + (space + node_height) * (i + 1.0);
//      for (int j = 0; j < nodeTree[i].length; j++) {
//        center_x = width/(node_len+1) * (j + 1);
//
//        left = center_x - node_width/2;
//        top = center_y - node_height/2;
//        Widget nodeWidget = NodeWidget(model: nodeTree[i][j], left: left, top: top, height: node_height, width: node_width, );
//        widgets.add(nodeWidget);
//        List parents = nodeTree[i][j].parents;
////        List address = value.findNodesByIds(parents);
//        List<Widget> arrows = drawArrow(nodeWidget, widgets, parents);
//        arrowList.addAll(arrows);
//      }
//
//    }
//
//    widgets.addAll(arrowList);
//
//  }

  List<Widget> drawTree({
    @required List<List<Node>> nodeTree,
    @required double width,
    @required double height,
    double nodeWidth=120,
    double nodeHeight=60,
    double margin = 15,
  }){
    List<Widget> widgets = [];
    List<Widget> arrowList = [];
    List<NodeWidget> nodeWidgetList = [];

    int depth = nodeTree.length;
    if (depth == 0) {
      return widgets;
    }
    int baseDepth = getDepthMaxWidth(nodeTree) + 1;
    double left = 0;
    double top = 2 * (baseDepth-1) * nodeHeight;
    List<Node> nodes = nodeTree[baseDepth - 1];
    List<Widget> parentNodes = [];

    for (Node node in nodes) {
      Widget nodeWidget = NodeWidget(model: node, left: left, top: top, height: nodeHeight, width: nodeWidth, );
      NodeWidget nodeWidget2 = NodeWidget(model: node, left: left, top: top, height: nodeHeight, width: nodeWidth, );

      left += nodeWidth + margin;
      parentNodes.add(nodeWidget);
      nodeWidgetList.add(nodeWidget2);
    }
    List<Widget> childNodes = parentNodes;

    widgets.addAll(parentNodes);

    int childDepth = baseDepth + 1;
    int parentDepth = baseDepth - 1;

    while (0 < parentDepth ) {
      left = 0;
      top = 2 * (parentDepth - 1) * nodeHeight;
      nodes = nodeTree[parentDepth - 1];
      List<Widget> nodeWidgets = [];
      for (Node node in nodes) {
//        ノードの描画
        NodeWidget nodeWidget = NodeWidget(model: node, left: left, top: top, height: nodeHeight, width: nodeWidth,);
        NodeWidget nodeWidget2 = NodeWidget(model: node, left: left, top: top, height: nodeHeight, width: nodeWidth, );
        nodeWidgets.add(nodeWidget);
        nodeWidgetList.add(nodeWidget2);
        left += nodeWidth + margin;

      }
      widgets.addAll(nodeWidgets);

      childNodes = nodeWidgets;
      parentDepth -= 1;
    }

    while (childDepth < depth+1) {
      nodes = nodeTree[childDepth-1];
      left = 0;
      top = 2 * (childDepth-1) * nodeHeight;
      List<Widget> nodeWidgets = [];
      for (Node node in nodes) {
//      ノードの描画
        Widget nodeWidget = NodeWidget(model: node, left: left, top: top, height: nodeHeight, width: nodeWidth, );
        NodeWidget nodeWidget2 = NodeWidget(model: node, left: left, top: top, height: nodeHeight, width: nodeWidth, );
        nodeWidgets.add(nodeWidget);
        nodeWidgetList.add(nodeWidget2);
        left += nodeWidth + margin;
      }

      widgets.addAll(nodeWidgets);
      parentNodes = nodeWidgets;
      childDepth += 1;
    }

    //      辺の描画
    for (int i = 0; i < nodeWidgetList.length; i++) {
      //        辺の描画
      List<int> children = nodeWidgetList[i].model.children;
      var childNodes = findNodeWidgetsByIds(children, widgets);
      List<Widget> arrows = drawArrow(nodeWidgetList[i], childNodes, children, isReverse: false);
      arrowList.addAll(arrows);
    }
    widgets.addAll(arrowList);
    List<Widget> results = widgets;
    return results;
  }


//  上からしたに線ひく(isReverse=true -> 逆)
  List<Widget> drawArrow(NodeWidget fromNode, List toNodes, List<int> ids, {bool isReverse=false}) {
    List<Widget> lines = [];

    for (NodeWidget toNode in toNodes) {
      if (ids.contains(toNode.model.id)) {
        Widget arrow;
        if (isReverse) {
          arrow = Arrow(x1: toNode.output_x, y1: toNode.output_y, x2: fromNode.input_x, y2: fromNode.input_y,);
        } else {
          arrow = Arrow(x1: fromNode.output_x, y1: fromNode.output_y, x2: toNode.input_x, y2: toNode.input_y,);
        }
        lines.add(arrow);
      }
    }
    return lines;
  }

  int getDepthMaxWidth(List<List<Node>> nodeTree) {
    int maxIdx = 0;
    for (int idx = 1; idx < nodeTree.length; idx++) {
      if (nodeTree[maxIdx].length < nodeTree[idx].length) {
        maxIdx = idx;
      }
    }
    return maxIdx;
  }

  List findNodeWidgetsByIds (List<int> ids, List nodeWidgets) {
    var results = [];
    for (int i = 0; i < nodeWidgets.length; i++) {
      if (ids.contains(nodeWidgets[i].model.id)) {
        results.add(nodeWidgets[i]);
      }
    }
    return nodeWidgets;
  }



}

