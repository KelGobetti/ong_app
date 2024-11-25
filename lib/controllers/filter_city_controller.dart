import 'package:flutter/material.dart';


class FilterCityController extends ChangeNotifier {

  String _citySelected = '';

  String getCitySelected(){
    return _citySelected;
  }

  setCitySelected({required String city}){
    _citySelected = city;
    notifyListeners();
  }

}