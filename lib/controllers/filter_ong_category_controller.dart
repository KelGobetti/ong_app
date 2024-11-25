import 'package:flutter/cupertino.dart';
import 'package:ong_app/models/enums.dart';

class FilterOngCategoryController extends ChangeNotifier {

  final List<OngCategory> _ongCategoryList = [];

  switchOngCategory({required OngCategory ongCategory}){
    if(_ongCategoryList.contains(ongCategory)){
      _ongCategoryList.remove(ongCategory);
    } else {
      _ongCategoryList.add(ongCategory);
    }
    notifyListeners();
  }

  List<OngCategory> getOngCategoryList(){
    return _ongCategoryList;
  }
}