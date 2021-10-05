import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_tree/models/conditions.dart';

class TreeModel extends ChangeNotifier {
  SelectedMode _selectedMode = SelectedMode.None;
  int count = 0;
  int max_depth = 0;

  Node root = Node(id: -1, title: 'start');
//  全てのノード
  List<Node> all_nodes = [];
//  フロンティアノードのりすと
  List<int> frontiers = [];
//  葉のノードリスト
  List<int> goal_nodes = [];

//  ノード接続時の一時的なID
  int _tmpId = -1;


  getTmpId() {
    return this._tmpId;
  }

  setTmpId(int id) {
    this._tmpId = id;
    notifyListeners();
  }


  int findById(int id) {
    for (int idx=0; idx < all_nodes.length; idx++) {
      if (id == all_nodes[idx].id) {
        return idx;
      }
    }

    return -2;
  }

  List<int> findNodesByIds(List<int> ids) {
    List<int> idx_list = [];
    for (int idx=0; idx < all_nodes.length; idx++) {
      if (ids.contains(all_nodes[idx].id)) {
        idx_list.add(idx);
      }
    }
    return idx_list;
  }

  void addChild (int pid, Node node) {
    if (pid == -1) {
      node = root.addChild(node);
    } else {
      int idx = findById(pid);
      if (idx < 0) {
        return;
      }

      if (all_nodes[idx].isFrontier) {
        goal_nodes.remove(all_nodes[idx].id);
      }
      node = all_nodes[idx].addChild(node);
    }

    goal_nodes.add(node.id);
    all_nodes.add(node);
    count += 1;

    if (max_depth < node.depth) {
      this.max_depth = node.depth;
    }
    notifyListeners();
  }

  void addParent(int id, Node node) {
    int child_idx = findById(id);
    node.isFrontier = false;
    this.all_nodes[child_idx].parents.add(node.id);
    node.children.add(id);

    if (all_nodes[child_idx].depth > 1) {
      node.depth = all_nodes[child_idx].depth - 1;
    } else {
      node.depth = all_nodes[child_idx].depth;
      incrementDepth(id);
    }
    all_nodes.add(node);
    this.count ++;
    notifyListeners();
  }

  void connectToChild(int id, int childId) {
    int idx = findById(id);
    int childIdx = findById(childId);
//    エラー処理
//        自身のIDを参照
    if (id == childId) {
      return;
    }
//      自分の親を参照
    if (all_nodes[idx].parents.contains(childId)){
      return;
    }
//      自分の子を参照
    if (all_nodes[idx].children.contains(childId)){
      return;
    }

//
    all_nodes[idx].children.add(childId);
    all_nodes[childIdx].parents.add(id);

//    子ノードの深さが自ノードになる深さ以下であれば子ノードの深さを変更
    int increment = all_nodes[idx].depth - all_nodes[childIdx].depth + 1;
    print("increment: $increment");
    if (increment > 0){
      incrementDepth(childId, increment: increment);
    }
    releaseNodes();
    notifyListeners();
  }

  void connectToParent(int id, int parentId){
    int idx = findById(id);
    int parentIdx = findById(parentId);

    print(this.all_nodes[idx].children);
    print(this.all_nodes[idx].parents);
//    エラー処理
//        自身のIDを参照
    if (id == parentId) {
      return;
    }
//      自分の親を参照
    if (all_nodes[idx].parents.contains(parentId)){
      return;
    }
//      自分の子を参照
    if (all_nodes[idx].children.contains(parentId)){
      return;
    }

    all_nodes[idx].parents.add(parentId);
    all_nodes[parentIdx].children.add(id);

//    自ノードの深さが親ノードの深さ以下であれば親ノードの深さを変更
    int increment = all_nodes[parentIdx].depth - all_nodes[idx].depth + 1;
    print(increment);
    if (increment > 0){
      incrementDepth(id, increment: increment);
    }
    releaseNodes();
    notifyListeners();
  }

  void incrementDepth(int id, {int increment=1}) {
    print("incrementDepth");
    List<int> incrementIdxes = [];
//    all_nodesから引数idであるNodeを探す. (all_nodes[idx])
    int idx = findById(id);
    incrementIdxes.add(idx);
    List<int> children = all_nodes[idx].children;

//    ツリーからdepthのインクリメントをすべきNodeを探す
    while(children.isNotEmpty) {
      List<int> children_idxes = findNodesByIds(children);
      incrementIdxes.addAll(children_idxes);
      //childrenの更新
      List<int> newChildren = [];
      for (int i = 0; i < children.length; i++) {
        int child_idx = findById(children[i]);
        newChildren.addAll(this.all_nodes[child_idx].children);
      }
      children = newChildren;
      //childrenの重複削除
      children.toSet().toList();

    }

    for (int i=0; i< incrementIdxes.length; i++) {
      this.all_nodes[incrementIdxes[i]].depth += increment;
      if (this.max_depth < this.all_nodes[incrementIdxes[i]].depth) {
        this.max_depth = this.all_nodes[incrementIdxes[i]].depth;
      }
    }
  }

  List<List<Node>> toList() {
    List<List<Node>> node_tree = [];
    for (int i = 1; i <= max_depth; i++){
      node_tree.add([]);
    }

    for (int i = 0; i < all_nodes.length; i++) {
      node_tree[all_nodes[i].depth-1].add(all_nodes[i]);
    }


    List<List<int>> id_tree = [];
    for (int i = 0; i < node_tree.length; i++) {
      var t = id_list(node_tree[i]);
      id_tree.add(t);
    }
    print(id_tree);
    return node_tree;
  }

  List<int> id_list(List<Node> nodes) {
    List<int> result = [];
    for (int i = 0; i < nodes.length; i++) {
      result.add(nodes[i].id);
    }
    return result;
  }


//  Conditions関係
  void addCondition(int id, Condition condition) {
    int idx = findById(id);
    this.all_nodes[idx].addCondition(condition);
    notifyListeners();
  }

  void incrementCondition(int node_id, int condition_id, {bool isDecrement=false}){
    int increment = isDecrement ? -1 : 1;
    int idx = findById(node_id);
    int cIdx = this.all_nodes[idx].findConditionById(condition_id);
    if (this.all_nodes[idx].conditions[cIdx].contentType == ContentType.num) {
      this.all_nodes[idx].conditions[cIdx].increment(increment);
    }
    notifyListeners();
  }

  void toggleCondition(int node_id, int condition_id) {
    int idx = findById(node_id);
    int cIdx = this.all_nodes[idx].findConditionById(condition_id);
    if (this.all_nodes[idx].conditions[cIdx].contentType == ContentType.check) {
      this.all_nodes[idx].conditions[cIdx].toggle();
    }
    notifyListeners();
  }


//  Node Connect 関係
  SelectedMode getSelectedMode(){
    return _selectedMode;
  }

  void setSelectedMode(SelectedMode selectedMode) {
    this._selectedMode = selectedMode;
    notifyListeners();
  }

  void setNodesTappedConnect (int id) {
    int idx = findById(id);
    Node node = this.all_nodes[idx];
    List<int> ids = findRelativesByIdx(idx);
    for (int i=0; i < this.all_nodes.length; i++) {
      if (ids.contains(this.all_nodes[i].id)) {
        this.all_nodes[i].setCanTapped(false);
      }
    }
    notifyListeners();
  }

  void releaseNodes() {
    for (int i=0; i < this.all_nodes.length; i++) {
      this.all_nodes[i].setCanTapped(true);
    }
  }


  List<int> findRelativesByIdx(int idx) {
    Node node = this.all_nodes[idx];
    List<int> results = [];
    List<int> children = node.children;
    List<int> parents = node.parents;

//    results.add(node.id);
    results.addAll(children);
    results.addAll(parents);

    while (children.length > 0) {
      List<int> tmps = [];
      List<int> idxes = findNodesByIds(children);
      for (int i in idxes) {
        tmps.addAll(this.all_nodes[i].children);
      }
      tmps.toSet().toList();
      children = tmps;
      results.addAll(children);
    }


    while (parents.length > 0) {
      List<int> tmps = [];
      List<int> idxes = findNodesByIds(parents);
      for (int i in idxes) {
        tmps.addAll(this.all_nodes[i].parents);
      }
      tmps.toSet().toList();
      parents = tmps;
      results.addAll(parents);
    }

    return results;
  }

  void nodeConnect (int id, int targetId) {
    int idx = findById(id);
    int targetIdx = findById(targetId);
    switch (this._selectedMode) {
      case SelectedMode.None:
        return;
      case SelectedMode.childConnect:
        connectToChild(id, targetId);
        break;
      case SelectedMode.parentConnect:
        connectToParent(id, targetId);
        break;
    }


  }


}

class Node {
  int id;
  String title;
  bool isFrontier = true;
  List<Condition>  conditions = [];
  bool canTapped = true;

  List<int> children = [];
  List<int> parents = [];
  int depth = 0;

  bool get isCompleted {
    if (conditions.length == 0) {
      return false;
    }
    for (int i=0; i < conditions.length; i++) {
      if (!conditions[i].isCompleted) {
        return false;
      }
    }
    return true;
  }


  Node({@required this.id, this.title});


  setCanTapped(bool b) {
    this.canTapped = b;
  }

  Node addChild (Node node) {
    children.add(node.id);
    this.isFrontier = false;
    if (this.id != -1) {
      node.parents.add(this.id);
    }
    node.depth = this.depth + 1;
    return node;
  }


  void addCondition (Condition condition) {
    conditions.add(condition);
  }

  int findConditionById(int id) {
    for (int idx =0; idx < this.conditions.length; idx++) {
      if (id == this.conditions[idx].id) {
        return idx;
      }
    }
    return -1;
  }

}

enum SelectedMode {
  None,
  childConnect,
  parentConnect,
}