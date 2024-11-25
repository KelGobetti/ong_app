import 'package:flutter/material.dart';

import '../models/ong_model.dart';


class UserController extends ChangeNotifier {

  Ong? _loggedOng;

  Ong? getLoggedOng(){
    return _loggedOng;
  }

  setLoggedOng({required Ong? ong}){
    _loggedOng = ong;
  }

}