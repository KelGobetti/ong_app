import 'package:flutter/material.dart';
import 'package:ong_app/models/enums.dart';


class BottomAppBarController extends ChangeNotifier {

  ScreenType _selectedScreen = ScreenType.home;

  ScreenType getSelectedScreen(){
    return _selectedScreen;
  }

  setSelectedScreen({required ScreenType screenType}){
    _selectedScreen = screenType;
    notifyListeners();
  }

}


