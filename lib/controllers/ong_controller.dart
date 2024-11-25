import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:ong_app/models/enums.dart';
import 'package:ong_app/models/project.dart';

import '../models/ong_model.dart';

class OngController extends ChangeNotifier {

  final List<Ong> _ongList = [];

  createOng({required Ong ong}){
    _ongList.add(ong);
    notifyListeners();
  }

  List<Ong> getOngList(){
    return _ongList;
  }

  createProject({required Ong ong, required Project project}){
    ong.projectList.add(project);
    notifyListeners();
  }

  deleteProject({required String ongId, required String projectId}){
    Ong ong = _ongList.singleWhere((Ong ong) => ong.id == ongId,);
    ong.projectList.removeWhere((Project project) => project.id == projectId,);
    notifyListeners();
  }
}