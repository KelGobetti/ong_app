import 'package:flutter/material.dart';
import 'package:ong_app/controllers/database_controller.dart';
import 'package:ong_app/controllers/login_controller.dart';
import 'package:ong_app/controllers/user_controller.dart';
import 'package:ong_app/screens/home_screen.dart';
import 'package:ong_app/screens/main_screen.dart';
import 'package:ong_app/screens/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/enums.dart';
import '../models/ong_model.dart';
import '../models/project.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff1f1f1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const LoginScreenBanner(),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                height: 150,
                child: Image.asset('assets/images/app_icon2.png'),
              ),
              const SizedBox(
                height: 60,
              ),
              const UserFormInputs(),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginScreenBanner extends StatelessWidget {
  const LoginScreenBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1158C2),
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 5,
            spreadRadius: 4,
          ),
        ],
        //image: const DecorationImage(image: AssetImage('assets/images/splash.png'),),
      ),
      child: Stack(
        children: [
          Center(child: Image.asset('assets/images/splash.png'),),
        ],
      ),
    );
  }
}

class UserFormInputs extends StatefulWidget {
  const UserFormInputs({super.key});

  @override
  State<UserFormInputs> createState() => _UserFormInputsState();
}

class _UserFormInputsState extends State<UserFormInputs> {

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Form(
      key: _formKey,
      child: Column(
        children: [
          input(hintText: 'Email*', textEditingController: emailTextEditingController),
          const SizedBox(
            height: 10,
          ),
          input(hintText: 'Senha*', isPassword: true, textEditingController: passwordTextEditingController),
          const Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 40),
                child: RegisterButton(),
              )),
          const SizedBox(height: 60,),
          enterButton(email: emailTextEditingController.text, password: passwordTextEditingController.text),
        ],
      ),
    );
  }

  Widget input({bool isPassword = false, required String hintText, required TextEditingController textEditingController}){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: TextFormField(
        obscureText: isPassword,
        onChanged: (value){
          setState(() {
            textEditingController.text = value;
          });
        },
        validator: (value){
          if(value == null || value.isEmpty){
            return 'Preencha o campo!';
          }
          return null;
        },
        style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xffbbbbbb)
        ),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none
          ),
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xffbbbbbb)
          ),
        ),
      ),
    );
  }

  Widget enterButton({required String email, required String password}){
    return SizedBox(
      height: 35,
      width: 190,
      child: FilledButton(
        onPressed: () async {
          if(_formKey.currentState!.validate()){

            LoginController loginController = LoginController();
            DatabaseController databaseController = DatabaseController();

            SnackBar snackBar = const SnackBar(content: Text('Verifique suas credenciais!'));

            loginController.login(email: email, password: password).then((value) async {

              UserController userController = Provider.of(context, listen: false);

              bool isVerified = false;

              isVerified = await loginController.checkIsVerified(email: email);

              if(isVerified){

                Map<String, dynamic> ongData = await databaseController.getOngData(email: email);


                List<dynamic> databaseProjectList = ongData['projectList'];

                List<Project> projectList = [];

                for(Map<String, dynamic> databaseProject in databaseProjectList){
                  String name = databaseProject['name'];
                  String description = databaseProject['description'];
                  Project project = Project(id: const Uuid().v1(), name: name, description: description);
                  projectList.add(project);
                }

                OngCategory ongCategory = getOngCategory(stringOngCategory: ongData['ongCategory']);

                Ong ong = Ong(
                  id: '1',
                  isAdmin: ongData['isAdmin'],
                  cnpj: ongData['cnpj'],
                  image: const AssetImage('assets/images/ong_image.png'),
                  name: ongData['name'],
                  email: email,
                  description: ongData['description'],
                  password: password,
                  cellNumber: ongData['cellNumber'],
                  pixKey: ongData['pixKey'],
                  state: ongData['state'],
                  city: ongData['city'],
                  road: ongData['road'],
                  cep: ongData['cep'],
                  projectList: projectList,
                  ongCategory: ongCategory,
                );

                userController.setLoggedOng(ong: ong);

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const MainScreen(),
                  ),
                );
              } else {
                SnackBar snackBar = const SnackBar(content: Text('Usuario ainda nao foi verificado!'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },).onError((error, stackTrace) {
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              print(error);
            },);
          }
        },
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: const Color(0xFF1158C2),
        ),
        child: const Text('Entrar',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  OngCategory getOngCategory({required String stringOngCategory}){
    switch(stringOngCategory){
      case 'animals': return OngCategory.animals;
      case 'education' : return OngCategory.education;
      case 'health' : return OngCategory.health;
      case 'environment': return OngCategory.environment;
      case 'humanRights': return OngCategory.humanRights;
      case 'arts': return OngCategory.arts;
      case 'technology': return OngCategory.technology;
      default: return OngCategory.arts;
    }
  }
}