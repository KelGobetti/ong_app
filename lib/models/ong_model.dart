


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ong_app/models/enums.dart';
import 'package:ong_app/models/project.dart';

class Ong {

  String id;
  //File image;
  bool isAdmin;
  String cnpj;
  String name;
  String description;
  String email;
  String password;
  String cellNumber;
  String pixKey;
  String state;
  String city;
  String road;
  String cep;
  //String projects;
  OngCategory ongCategory;
  AssetImage image;
  List<Project> projectList;

  Ong({
    required this.id,
    required this.isAdmin,
    required this.cnpj,
    required this.image,
    required this.name,
    required this.description,
    required this.email,
    required this.password,
    required this.cellNumber,
    required this.pixKey,
    required this.state,
    required this.city,
    required this.road,
    required this.cep,
    required this.projectList,
    required this.ongCategory,
  });

}