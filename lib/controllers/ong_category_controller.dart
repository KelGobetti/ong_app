import 'package:flutter/material.dart';
import 'package:ong_app/models/enums.dart';




class OngCategoryController extends ChangeNotifier {

  OngCategory _ongCategory = OngCategory.arts;

  OngCategory getSelectedOngCategory(){
    return _ongCategory;
  }

  setSelectedOngCategory({required OngCategory ongCategory}){
    _ongCategory = ongCategory;
    notifyListeners();
  }
}