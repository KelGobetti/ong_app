import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ong_app/controllers/user_controller.dart';
import 'package:ong_app/models/enums.dart';
import 'package:ong_app/screens/login_screen.dart';
import 'package:ong_app/screens/ong_approval_screen.dart';
import 'package:ong_app/screens/project_screen.dart';
import 'package:ong_app/screens/register_screen.dart';
import 'package:ong_app/screens/settings_screen.dart';
import 'package:ong_app/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

import '../controllers/bottom_app_bar_controller.dart';
import '../controllers/database_controller.dart';
import '../models/ong_model.dart';
import '../models/project.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.ong});

  final Ong? ong;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                ProfileCard(ong: ong,),
                const SizedBox(height: 16,),
                ProfileActionItem(title: 'Temas', description: 'Meus temas', onPressed: (){},),
                ProfileActionItem(title: 'Dados da Conta', description: 'Meus dados', onPressed: (){
                  BottomAppBarController bottomAppBarController = Provider.of(context, listen: false);
                  bottomAppBarController.setSelectedScreen(screenType: ScreenType.settings);
                },),
                ProfileActionItem(title: 'Projetos', description: 'Meus projetos', onPressed: () async {
                  if(ong != null){
                    await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProjectScreen(ong: ong!,),
                        )
                    );

                    DatabaseController databaseController = DatabaseController();

                    List<dynamic> databaseProjectList = [];

                    for(Project project in ong!.projectList){
                      databaseProjectList.add(
                          {
                            'name' : project.name,
                            'description' : project.description,
                          }
                      );
                    }

                    Map<String, dynamic> newData = {
                      'projectList' : databaseProjectList,
                    };

                    databaseController.updateOngData(email: ong!.email, newData: newData);

                  }
                },),
                Visibility(visible: checkIsAdmin(ong: ong), child: ProfileActionItem(title: 'Ongs Pendentes', description: 'Ongs pendentes de aprovação', onPressed: () async {

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => OngApprovalScreen(),
                    ),
                  );
                },),),
                Visibility(
                  visible: (ong != null),
                  child: ProfileActionItem(title: 'Sair', description: 'Sair da conta', onPressed: (){
                    
                    UserController userController = Provider.of(context, listen: false);
                    userController.setLoggedOng(ong: null);

                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const WelcomeScreen(),
                      ),
                    );
                  },),
                ),
              ],
            ),
            const AppInfo(),
          ],
        ),
      ),
      backgroundColor: const Color(0xffF3F3F3),
    );
  }
  bool checkIsAdmin({required Ong? ong}){
    if(ong != null){
      if(ong.isAdmin){
        return true;
      }
      return false;
    }
    return false;
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key, required this.ong});

  final Ong? ong;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xffd9d9d9),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.only(left: 26),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ProfilePicture(ong: ong,),
          const SizedBox(width: 34,),
          ProfileCardActions(ong: ong,),
        ],
      ),
    );
  }
}

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({super.key, required this.ong});

  final Ong? ong;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xffbbbbbb),
      ),
      padding: const EdgeInsets.all(2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: (ong != null) ? Image(image: ong!.image, fit: BoxFit.cover,)  : Icon(Icons.person)),
    );
  }
}

class ProfileCardActions extends StatelessWidget {
  const ProfileCardActions({super.key, required this.ong});

  final Ong? ong;

  @override
  Widget build(BuildContext context) {
    return (ong != null) ? loggedUserActions() : loggedOutUserActions(context: context);
  }

  Widget loggedUserActions(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(ong!.name,
          style: const TextStyle(
            color: Color(0xff778080),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10,),
        Text(ong!.email,
          style: const TextStyle(
            color: Color(0xff778080),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget loggedOutUserActions({required BuildContext context}){
    return Row(
      children: [
        cardButton(label: 'entrar', onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        }),
        cardButton(label: 'registrar', onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const RegisterScreen(),
            ),
          );
        }),
      ],
    );
  }

  Widget cardButton({required String label, required Function onPressed}){
    return TextButton(
      onPressed: (){
        onPressed();
      },
      child: Text(label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xff1158c2)
        ),
      ),
    );
  }
}

class ProfileActionItem extends StatelessWidget {
  const ProfileActionItem({super.key, required this.title, required this.description, required this.onPressed});

  final String title;
  final String description;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: FilledButton(
        onPressed: (){
          onPressed();
        },
        style: FilledButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            shape: LinearBorder.bottom(
                side: const BorderSide(
                  color: Color(0xfff1f1f1),
                  width: 1,
                )
            )
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xff778080),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(description,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xffbbbbbb),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppInfo extends StatelessWidget {
  const AppInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('Atividade Extensionista IV Uninter',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xffbbbbbb),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text('App desenvolvido por: Kelvin Gobetti Paim',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xffbbbbbb),
            fontWeight: FontWeight.bold,
          ),
        ),

      ],
    );
  }
}

