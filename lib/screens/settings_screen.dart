import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ong_app/controllers/database_controller.dart';

import '../models/ong_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.ong});

  final Ong? ong;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Configuracoes',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        forceMaterialTransparency: true,
      ),
      body: (ong != null)
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SettingsScreenOngPicture(
                      ong: ong!,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SettingsScreenOngData(
                      ong: ong!,
                    ),
                  ],
                ),
              ),
            )
          : const Center(
              child: Text(
                'Faca login para ver as configuracoes',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xff778080),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
      backgroundColor: const Color(0xffF3F3F3),
    );
  }
}

class SettingsScreenOngPicture extends StatefulWidget {
  const SettingsScreenOngPicture({super.key, required this.ong});

  final Ong ong;

  @override
  State<SettingsScreenOngPicture> createState() => _SettingsScreenOngPictureState();
}

class _SettingsScreenOngPictureState extends State<SettingsScreenOngPicture> {
  
  File? file;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        ImagePicker imagePicker = ImagePicker();
        XFile? imageFile = await imagePicker.pickImage(source: ImageSource.gallery);

        if(imageFile != null){
          setState(() {
            file = File(imageFile.path);
          });
        }
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
            color: const Color(0xffd9d9d9),
            borderRadius: BorderRadius.circular(16)),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image(
              image: (file == null) ? const AssetImage('assets/images/ong_image.png') : FileImage(file!),
              fit: BoxFit.cover,
            )),
      ),
    );
  }
}

class SettingsScreenOngData extends StatefulWidget {
  const SettingsScreenOngData({super.key, required this.ong});

  final Ong ong;

  @override
  State<SettingsScreenOngData> createState() => _SettingsScreenOngDataState();
}

class _SettingsScreenOngDataState extends State<SettingsScreenOngData> {
  @override
  Widget build(BuildContext context) {
    int ongPasswordLettersQuantity = widget.ong.password.length;
    DatabaseController databaseController = DatabaseController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title(text: 'Dados da conta'),
        SettingsActionItem(
          title: widget.ong.name,
          description: 'Nome da ong',
          onSaveEditPressed: ({required String newValue}) {
            setState(() {
              widget.ong.name = newValue;

              Map<String, dynamic> newData = {
                'name' : newValue,
              };

              databaseController.updateOngData(email: widget.ong.email, newData: newData);
            });
          },
        ),
        SettingsActionItem(
          title: widget.ong.cnpj,
          description: 'cnpj da ong',
          onSaveEditPressed: ({required String newValue}) {
            setState(() {
              widget.ong.cnpj = newValue;

              Map<String, dynamic> newData = {
                'cnpj' : newValue,
              };

              databaseController.updateOngData(email: widget.ong.email, newData: newData);
            });
          },
        ),
        SettingsActionItem(
          title: widget.ong.description,
          description: 'Descricao da ong',
          onSaveEditPressed: ({required String newValue}) {
            setState(() {
              widget.ong.description = newValue;

              Map<String, dynamic> newData = {
                'description' : newValue,
              };

              databaseController.updateOngData(email: widget.ong.email, newData: newData);
            });
          },
        ),
        SettingsActionItem(
          title: widget.ong.email,
          description: 'Email da conta',
          isEditable: false,
          onSaveEditPressed: ({required String newValue}) {
            setState(() {
              widget.ong.email = newValue;
            });
          },
        ),
        SettingsActionItem(
          title: '*' * ongPasswordLettersQuantity,
          description: 'Senha da conta',
          isEditable: false,
          onSaveEditPressed: ({required String newValue}) {
            setState(() {
              widget.ong.password = newValue;
            });
          },
        ),
        SettingsActionItem(
          title: widget.ong.cellNumber,
          description: 'Telefone da ong',
          onSaveEditPressed: ({required String newValue}) {
            setState(() {
              widget.ong.cellNumber = newValue;

              Map<String, dynamic> newData = {
                'cellNumber' : newValue,
              };

              databaseController.updateOngData(email: widget.ong.email, newData: newData);
            });
          },
        ),
        SettingsActionItem(
          title: widget.ong.pixKey,
          description: 'Chave pix para receber doacoes',
          onSaveEditPressed: ({required String newValue}) {
            setState(() {
              widget.ong.pixKey = newValue;

              Map<String, dynamic> newData = {
                'pixKey' : newValue,
              };

              databaseController.updateOngData(email: widget.ong.email, newData: newData);
            });
          },
        ),
        const SizedBox(
          height: 17,
        ),
        title(text: 'Endereco'),
        SettingsActionItem(
          title: widget.ong.state,
          description: 'Estado da ong',
          onSaveEditPressed: ({required String newValue}) {
            setState(() {
              widget.ong.state = newValue;

              Map<String, dynamic> newData = {
                'state' : newValue,
              };

              databaseController.updateOngData(email: widget.ong.email, newData: newData);
            });
          },
        ),
        SettingsActionItem(
          title: widget.ong.city,
          description: 'Cidade da ong',
          onSaveEditPressed: ({required String newValue}) {
            setState(() {
              widget.ong.city = newValue;

              Map<String, dynamic> newData = {
                'city' : newValue,
              };

              databaseController.updateOngData(email: widget.ong.email, newData: newData);
            });
          },
        ),
        SettingsActionItem(
          title: widget.ong.road,
          description: 'Rua da ong',
          onSaveEditPressed: ({required String newValue}) {
            setState(() {
              widget.ong.road = newValue;

              Map<String, dynamic> newData = {
                'road' : newValue,
              };

              databaseController.updateOngData(email: widget.ong.email, newData: newData);
            });
          },
        ),
        SettingsActionItem(
          title: widget.ong.cep,
          description: 'CEP da ong',
          onSaveEditPressed: ({required String newValue}) {
            setState(() {
              widget.ong.cep = newValue;

              Map<String, dynamic> newData = {
                'cep' : newValue,
              };

              databaseController.updateOngData(email: widget.ong.email, newData: newData);
            });
          },
        ),
      ],
    );
  }

  Widget title({required String text}) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class SettingsActionItem extends StatelessWidget {
  const SettingsActionItem(
      {super.key,
      required this.title,
      required this.description,
      required this.onSaveEditPressed,
      this.isEditable = true,
      });

  final String title;
  final String description;
  final bool isEditable;
  final Function({required String newValue}) onSaveEditPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: FilledButton(
        onPressed: () {
          if(isEditable){
            showDialog(
              context: context,
              builder: (context) => DialogEditActionItem(
                dataToEdit: title,
              ),
            ).then(
                  (newValue) {
                if (newValue != null) {
                  onSaveEditPressed(newValue: newValue);
                }
              },
            );
          }
        },
        style: FilledButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            shape: LinearBorder.bottom(
                side: const BorderSide(
              color: Color(0xfff1f1f1),
              width: 1,
            ))),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xff778080),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xffbbbbbb),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Opacity(
                opacity: (isEditable) ? 1 : 0,
                child: const Icon(
                  Icons.edit,
                  color: Color(0xff778080),
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DialogEditActionItem extends StatelessWidget {
  const DialogEditActionItem({super.key, required this.dataToEdit});

  final String dataToEdit;

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();
    textEditingController.text = dataToEdit;

    return Dialog(
      child: Container(
        height: 180,
        decoration: BoxDecoration(
            color: const Color(0xfff1f1f1),
            borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 36),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title(),
            textInput(textEditingController: textEditingController),
            saveButton(
                textEditingController: textEditingController, context: context),
          ],
        ),
      ),
    );
  }

  Widget title() {
    return const Text(
      'Editar informacao:',
      style: TextStyle(
        fontSize: 12,
        color: Color(0xff778080),
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget textInput({required TextEditingController textEditingController}) {
    return TextFormField(
      controller: textEditingController,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Color(0xffbbbbbb),
        fontSize: 12,
      ),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        hintText: 'Escreva nova informacao',
        hintStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xffbbbbbb),
          fontSize: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget saveButton(
      {required TextEditingController textEditingController,
      required BuildContext context}) {
    return SizedBox(
      height: 40,
      width: double.infinity,
      child: FilledButton(
        onPressed: () {
          Navigator.of(context).pop(textEditingController.text);
        },
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xff1158c2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text(
          'Salvar',
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
      ),
    );
  }
}
