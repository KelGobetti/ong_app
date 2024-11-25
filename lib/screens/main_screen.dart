import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ong_app/controllers/ong_controller.dart';
import 'package:ong_app/controllers/user_controller.dart';
import 'package:ong_app/screens/home_screen.dart';
import 'package:ong_app/screens/profile_screen.dart';
import 'package:ong_app/screens/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../controllers/bottom_app_bar_controller.dart';
import '../controllers/database_controller.dart';
import '../models/enums.dart';
import '../models/ong_model.dart';
import '../models/project.dart';
import 'ong_approval_screen.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  DatabaseController databaseController = DatabaseController();
  List<QueryDocumentSnapshot<Map<String, dynamic>>> ongList = [];
  bool isLoadingOngList = true;

  @override
  void initState() {
    super.initState();
    getOngList();
  }

  getOngList() async {

    OngController ongController = Provider.of(context, listen: false);
    ongController.clearOngList();
    ongList = await databaseController.getAllOngs();

    for(dynamic databaseOng in ongList){

      String id = const Uuid().v1();
      bool isAdmin = (databaseOng.data()['isAdmin'] == null) ? false : databaseOng.data()['isAdmin'];
      bool isVerified = (databaseOng.data()['isVerified'] == null) ? false : databaseOng.data()['isVerified'];
      String cnpj = (databaseOng.data()['cnpj'] == null) ? '' : databaseOng.data()['cnpj'];
      AssetImage image = AssetImage('assets/images/ong_image.png');
      String name = (databaseOng.data()['name'] == null) ? '' : databaseOng.data()['name'];
      String description = (databaseOng.data()['description'] == null) ? '' : databaseOng.data()['description'];
      String email = (databaseOng.data()['email'] == null) ? '' : databaseOng.data()['email'];
      String password = (databaseOng.data()['password'] == null) ? '' : databaseOng.data()['password'];
      String cellNumber = (databaseOng.data()['cellNumber'] == null) ? '' : databaseOng.data()['cellNumber'];
      String pixKey = (databaseOng.data()['pixKey'] == null) ? '' : databaseOng.data()['pixKey'];
      String state = (databaseOng.data()['state'] == null) ? '' : databaseOng.data()['state'];
      String city = (databaseOng.data()['city'] == null) ? '' : databaseOng.data()['city'];
      String road = (databaseOng.data()['road'] == null) ? '' : databaseOng.data()['road'];
      String cep = (databaseOng.data()['cep'] == null) ? '' : databaseOng.data()['cep'];
      List<dynamic> databaseProjectList = (databaseOng.data()['projectList'] == null) ? [] : databaseOng.data()['projectList'];
      OngCategory ongCategory = (databaseOng.data()['ongCategory'] == null) ? OngCategory.arts : convertStringToOngCategory(ongCategory: databaseOng.data()['ongCategory']);

      List<Project> projectList = [];

      for (dynamic databaseProject in databaseProjectList) {
        String name = databaseProject['name'];
        String description = databaseProject['description'];

        Project project = Project(
            id: const Uuid().v1(),
            name: name,
            description: description);
        projectList.add(project);
      }

      Ong ong = Ong(
        id: id,
        isAdmin: isAdmin,
        cnpj: cnpj,
        image: image,
        name: name,
        description: description,
        email: email,
        password: password,
        cellNumber: cellNumber,
        pixKey: pixKey,
        state: state,
        city: city,
        road: road,
        cep: cep,
        projectList: projectList,
        ongCategory: ongCategory,
      );

      if(isVerified){
        ongController.createOng(ong: ong);
      }
    }


    setState(() {
      isLoadingOngList = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomAppBarController>(
      builder: (context, bottomAppBarController, child) {

        ScreenType selectedScreenType = bottomAppBarController.getSelectedScreen();
        //OngController ongController = Provider.of(context, listen: false);
        //Ong ong = ongController.getOngList().first;
        UserController userController = Provider.of(context, listen: false);
        Ong? loggedOng = userController.getLoggedOng();

        Map<ScreenType, Widget> screenList = {
          ScreenType.home : const HomeScreen(),
          ScreenType.settings : SettingsScreen(ong: loggedOng,),
          ScreenType.profile : ProfileScreen(ong: loggedOng,),
        };

        return Scaffold(
          body: (isLoadingOngList) ? const Center(child: CircularProgressIndicator(),): screenList[selectedScreenType],
          bottomNavigationBar: const BottomNavigationBarCustom(),
        );
      },
    );
  }
}

class BottomNavigationBarCustom extends StatelessWidget {
  const BottomNavigationBarCustom({super.key});

  @override
  Widget build(BuildContext context) {

    IconData homeIcon = Icons.home_filled;
    IconData settingsIcon = Icons.settings;
    IconData profileIcon = Icons.person;

    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
              width: 1,
              color: Color(0xffF1F1F1)
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          bottomNavigationBarItem(title: 'Home', icon: homeIcon, screenType: ScreenType.home),
          bottomNavigationBarItem(title: 'Configuracoes', icon: settingsIcon, screenType: ScreenType.settings),
          bottomNavigationBarItem(title: 'Perfil', icon: profileIcon, screenType: ScreenType.profile),
        ],
      ),
    );

  }

  Widget bottomNavigationBarItem({required String title, required IconData icon, required ScreenType screenType}){



    return Consumer<BottomAppBarController>(
        builder: (context, bottomAppBarController, child) {

          ScreenType selectedScreen = bottomAppBarController.getSelectedScreen();

          bool isSelected = (selectedScreen == screenType);
          Color textColor = (isSelected) ? const Color(0xff1158C2) : const Color(0xff778080);

          return FilledButton(
            onPressed: (){
              bottomAppBarController.setSelectedScreen(screenType: screenType);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.transparent
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: textColor, size: 20,),
                Text(title,
                  style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12
                  ),
                ),
              ],
            ),
          );
        });

  }

}