import 'package:flutter/material.dart';
import 'package:ong_app/controllers/database_controller.dart';
import 'package:ong_app/controllers/login_controller.dart';
import 'package:ong_app/controllers/ong_category_controller.dart';
import 'package:ong_app/models/enums.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/ong_model.dart';
import 'main_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final Ong ong = Ong(
      id: const Uuid().v1(),
      isAdmin: false,
      image: const AssetImage(''),
      name: '',
      cnpj: '',
      description: '',
      email: '',
      password: '',
      cellNumber: '',
      pixKey: '',
      state: '',
      city: '',
      road: '',
      cep: '',
      projectList: [],
      ongCategory: OngCategory.animals,
    );

    return Scaffold(
      backgroundColor: const Color(0xfff1f1f1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const RegisterScreenBanner(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        'Registro Ong',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xff353535),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RegisterScreenInput(
                        hintText: 'Nome',
                        onChanged: (String value) {
                          ong.name = value;
                        },
                      ),
                      RegisterScreenInput(
                        hintText: 'CNPJ',
                        onChanged: (String value) {
                          ong.cnpj = value;
                        },
                      ),
                      RegisterScreenInput(
                        hintText: 'Descrição da ong',
                        onChanged: (String value) {
                          ong.description = value;
                        },
                      ),
                      RegisterScreenInput(
                        hintText: 'Email',
                        onChanged: (String value) {
                          ong.email = value;
                        },
                      ),
                      RegisterScreenInput(
                        hintText: 'Telefone',
                        onChanged: (String value) {
                          ong.cellNumber = value;
                        },
                      ),
                      const Text(
                        'Categoria da Ong',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xff353535),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      OngCategoryDropdown(ong: ong,),
                      const Text(
                        'Endereco',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xff353535),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RegisterScreenInput(
                        hintText: 'Estado',
                        onChanged: (String value) {
                          ong.state = value;
                        },
                      ),
                      RegisterScreenInput(
                        hintText: 'Cidade',
                        onChanged: (String value) {
                          ong.city = value;
                        },
                      ),
                      RegisterScreenInput(
                        hintText: 'Rua',
                        onChanged: (String value) {
                          ong.road = value;
                        },
                      ),
                      RegisterScreenInput(
                        hintText: 'CEP',
                        onChanged: (String value) {
                          ong.cep = value;
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      RegisterScreenInput(
                        hintText: 'Senha',
                        isPassword: true,
                        onChanged: (String value) {
                          ong.password = value;
                        },
                      ),
                      RegisterScreenInput(
                        hintText: 'Senha',
                        isPassword: true,
                        onChanged: (String value) {},
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Center(
                          child: RegisterButton(
                        formKey: formKey,
                        ong: ong,
                      )),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        '*Apos solicitar registro, aguarde a analise dos administradores',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff778080)),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterScreenBanner extends StatelessWidget {
  const RegisterScreenBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1158C2),
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
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
          Center(
            child: Image.asset('assets/images/splash.png'),
          ),
        ],
      ),
    );
  }
}

class RegisterScreenInput extends StatelessWidget {
  const RegisterScreenInput(
      {super.key,
      required this.hintText,
      this.isPassword = false,
      required this.onChanged});

  final String hintText;
  final bool isPassword;
  final Function(String text) onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        obscureText: isPassword,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Preencha o campo!';
          }
          return null;
        },
        onChanged: (value) {
          onChanged(value);
        },
        style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xffbbbbbb)),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none),
          filled: true,
          fillColor: Colors.white,
          label: Text(hintText,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xffbbbbbb)),
          ),
          hintStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xffbbbbbb)),
        ),
      ),
    );
  }
}

class OngCategoryDropdown extends StatelessWidget {
  const OngCategoryDropdown(
      {super.key,
        required this.ong});

  final Ong ong;

  @override
  Widget build(BuildContext context) {

    MenuController menuController = MenuController();

    return Consumer<OngCategoryController>(
      builder: (context, ongCategoryController, child) {

        OngCategory selectedOngCategory = ongCategoryController.getSelectedOngCategory();

        String dropdownTitle = convertOngCategoryToString(ongCategory: selectedOngCategory);

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: MenuAnchor(
            menuChildren: [
              MenuItemButton(
                onPressed: () {
                  ongCategoryController.setSelectedOngCategory(ongCategory: OngCategory.animals);
                  ong.ongCategory = OngCategory.animals;
                },
                child: const Text('Animais'),
              ),
              MenuItemButton(
                onPressed: () {
                  ongCategoryController.setSelectedOngCategory(ongCategory: OngCategory.education);
                  ong.ongCategory = OngCategory.education;
                },
                child: const Text('Educação'),
              ),
              MenuItemButton(
                onPressed: () {
                  ongCategoryController.setSelectedOngCategory(ongCategory: OngCategory.health);
                  ong.ongCategory = OngCategory.health;
                },
                child: const Text('Saúde'),
              ),
              MenuItemButton(
                onPressed: () {
                  ongCategoryController.setSelectedOngCategory(ongCategory: OngCategory.environment);
                  ong.ongCategory = OngCategory.environment;
                },
                child: const Text('Meio Ambiente'),
              ),
              MenuItemButton(
                onPressed: () {
                  ongCategoryController.setSelectedOngCategory(ongCategory: OngCategory.humanRights);
                  ong.ongCategory = OngCategory.humanRights;
                },
                child: const Text('Direitos Humanos'),
              ),
              MenuItemButton(
                onPressed: () {
                  ongCategoryController.setSelectedOngCategory(ongCategory: OngCategory.arts);
                  ong.ongCategory = OngCategory.arts;
                },
                child: const Text('Artes'),
              ),
              MenuItemButton(
                onPressed: () {
                  ongCategoryController.setSelectedOngCategory(ongCategory: OngCategory.technology);
                  ong.ongCategory = OngCategory.technology;
                },
                child: const Text('Tecnologia'),
              ),
            ],
            style: MenuStyle(
              backgroundColor: const WidgetStatePropertyAll<Color>(Colors.white),
              shape: WidgetStatePropertyAll<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(
                    width: 1,
                    color: Color(0x4C656565),
                  ),
                ),
              ),
            ),
            controller: menuController,
            builder: (context, controller, child) {
              return SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: (){
                    if(menuController.isOpen){
                      menuController.close();
                    } else {
                      menuController.open();
                    }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(dropdownTitle,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xffbbbbbb)),
                        ),
                        const Icon(Icons.keyboard_arrow_down, color: Color(0xffbbbbbb),)
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class RegisterButton extends StatelessWidget {
  const RegisterButton({super.key, required this.formKey, required this.ong});

  final GlobalKey<FormState> formKey;
  final Ong ong;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      width: 190,
      child: FilledButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            LoginController loginController = LoginController();
            DatabaseController databaseController = DatabaseController();

            loginController.register(ong: ong).then(
              (value) async {

                await databaseController.storeOngData(ong: ong);

                Navigator.of(context).pop();
                SnackBar snackBar = const SnackBar(content: Text('Registro solicitado com sucesso!'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ).onError(
              (error, stackTrace) {
                SnackBar snackBar = const SnackBar(
                    content: Text(
                        'Tivemos algum problema com seu registro! tente novamente'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                print(error);
              },
            );

            //solicitar registro
          }
        },
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: const Color(0xFF1158C2),
        ),
        child: const Text(
          'Solicitar Registro',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}


String convertOngCategoryToString({required OngCategory ongCategory}){
  if(ongCategory == OngCategory.technology){
    return 'Tecnologia';
  } else if(ongCategory == OngCategory.arts){
    return 'Artes';
  } else if(ongCategory == OngCategory.humanRights){
    return 'Direitos Humanos';
  } else if(ongCategory == OngCategory.environment){
    return 'Meio Ambiente';
  } else if(ongCategory == OngCategory.health){
    return 'Saúde';
  } else if(ongCategory == OngCategory.education){
    return 'Educação';
  } else {
    return 'Animais';
  }
}