import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ong_app/controllers/database_controller.dart';
import 'package:ong_app/controllers/ong_approval_controller.dart';
import 'package:ong_app/models/enums.dart';
import 'package:ong_app/models/project.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/ong_model.dart';
import 'ong_screen.dart';

class OngApprovalScreen extends StatefulWidget {
  const OngApprovalScreen({super.key});

  @override
  State<OngApprovalScreen> createState() => _OngApprovalScreenState();
}

class _OngApprovalScreenState extends State<OngApprovalScreen> {

  DatabaseController databaseController = DatabaseController();
  List<QueryDocumentSnapshot<Map<String, dynamic>>> ongList = [];
  bool isLoadingOngList = true;

  @override
  void initState() {
    super.initState();
    getOngList();
  }

  getOngList() async {
    ongList = await databaseController.getAllOngs();
    setState(() {
      isLoadingOngList = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OngApprovalController>(
      builder: (context, ongApprovalController, child) {

        List<QueryDocumentSnapshot<Map<String, dynamic>>> ongListFiltered = [];

        ongListFiltered = ongList.where(
              (map) {
            if (map['isVerified'] != null) {
              if (!map['isVerified']) {
                return true;
              }
            }
            return false;
          },
        ).toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Aprovação Registro Ongs',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            forceMaterialTransparency: true,
          ),
          body: (isLoadingOngList) ? const Center(child: CircularProgressIndicator()) : (ongListFiltered.isNotEmpty)
              ? Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: ListView.builder(
              itemCount: ongListFiltered.length,
              itemBuilder: (context, index) {

                String id = index.toString();
                bool isAdmin = (ongListFiltered[index].data()['isAdmin'] == null) ? false : ongListFiltered[index].data()['isAdmin'];
                bool isVerified = (ongListFiltered[index].data()['isVerified'] == null) ? false : ongListFiltered[index].data()['isVerified'];
                String cnpj = (ongListFiltered[index].data()['cnpj'] == null) ? '' : ongListFiltered[index].data()['cnpj'];
                AssetImage image = AssetImage('assets/images/ong_image.png');
                String name = (ongListFiltered[index].data()['name'] == null) ? '' : ongListFiltered[index].data()['name'];
                String description = (ongListFiltered[index].data()['description'] == null) ? '' : ongListFiltered[index].data()['description'];
                String email = (ongListFiltered[index].data()['email'] == null) ? '' : ongListFiltered[index].data()['email'];
                String password = (ongListFiltered[index].data()['password'] == null) ? '' : ongListFiltered[index].data()['password'];
                String cellNumber = (ongListFiltered[index].data()['cellNumber'] == null) ? '' : ongListFiltered[index].data()['cellNumber'];
                String pixKey = (ongListFiltered[index].data()['pixKey'] == null) ? '' : ongListFiltered[index].data()['pixKey'];
                String state = (ongListFiltered[index].data()['state'] == null) ? '' : ongListFiltered[index].data()['state'];
                String city = (ongListFiltered[index].data()['city'] == null) ? '' : ongListFiltered[index].data()['city'];
                String road = (ongListFiltered[index].data()['road'] == null) ? '' : ongListFiltered[index].data()['road'];
                String cep = (ongListFiltered[index].data()['cep'] == null) ? '' : ongListFiltered[index].data()['cep'];
                List<dynamic> databaseProjectList = (ongListFiltered[index].data()['projectList'] == null) ? [] : ongListFiltered[index].data()['projectList'];
                OngCategory ongCategory =
                (ongListFiltered[index].data()['ongCategory'] == null) ? OngCategory.arts : convertStringToOngCategory(ongCategory: ongListFiltered[index].data()['ongCategory']);

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

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: VerticalOngItem(
                    ong: ong,
                    isApproval: true,
                  ),
                );
              },
            ),
          )
              : const Center(
            child: Text(
              'Nenhuma ong pendente!',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xff778080),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          backgroundColor: const Color(0xffF3F3F3),
        );
      },
    );


  }


}

class SettingsScreenOngPicture extends StatelessWidget {
  const SettingsScreenOngPicture({super.key, required this.ong});

  final Ong ong;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
          color: const Color(0xffd9d9d9),
          borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image(
            image: ong.image,
            fit: BoxFit.cover,
          )),
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
            });
          },
        ),
        SettingsActionItem(
          title: widget.ong.description,
          description: 'Descricao da ong',
          onSaveEditPressed: ({required String newValue}) {
            setState(() {
              widget.ong.description = newValue;
            });
          },
        ),
        SettingsActionItem(
          title: widget.ong.email,
          description: 'Email da conta',
          onSaveEditPressed: ({required String newValue}) {
            setState(() {
              widget.ong.email = newValue;
            });
          },
        ),
        SettingsActionItem(
          title: '*' * ongPasswordLettersQuantity,
          description: 'Senha da conta',
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
            });
          },
        ),
        SettingsActionItem(
          title: widget.ong.pixKey,
          description: 'Chave pix para receber doacoes',
          onSaveEditPressed: ({required String newValue}) {
            setState(() {
              widget.ong.pixKey = newValue;
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
            });
          },
        ),
        SettingsActionItem(
          title: widget.ong.city,
          description: 'Cidade da ong',
          onSaveEditPressed: ({required String newValue}) {
            setState(() {
              widget.ong.city = newValue;
            });
          },
        ),
        SettingsActionItem(
          title: widget.ong.road,
          description: 'Rua da ong',
          onSaveEditPressed: ({required String newValue}) {
            setState(() {
              widget.ong.road = newValue;
            });
          },
        ),
        SettingsActionItem(
          title: widget.ong.cep,
          description: 'CEP da ong',
          onSaveEditPressed: ({required String newValue}) {
            setState(() {
              widget.ong.cep = newValue;
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
      required this.onSaveEditPressed});

  final String title;
  final String description;
  final Function({required String newValue}) onSaveEditPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: FilledButton(
        onPressed: () {
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
              const Icon(
                Icons.edit,
                color: Color(0xff778080),
                size: 16,
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

class VerticalOngItem extends StatelessWidget {
  const VerticalOngItem(
      {super.key, required this.ong, this.isApproval = false});

  final Ong ong;
  final bool isApproval;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        dynamic userSelect = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OngScreen(
              ong: ong,
              isApproval: isApproval,
            ),
          ),
        );

        userSelect ??= false;

        if(userSelect){
          Navigator.of(context).pop();
        }

      },
      child: Container(
        height: 75,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.only(right: 10),
        child: Row(
          children: [
            image(),
            Expanded(child: ongInfo()),
            const Icon(
              Icons.keyboard_arrow_right,
              color: Color(0xff778080),
            )
          ],
        ),
      ),
    );
  }

  Widget image() {
    return Container(
      height: 75,
      width: 75,
      decoration: BoxDecoration(
        color: const Color(0xffD9D9D9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image(
            image: ong.image,
            fit: BoxFit.cover,
          )),
    );
  }

  Widget ongInfo() {
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ong.name,
            style: const TextStyle(
              color: Color(0xff778080),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            ong.description,
            style: const TextStyle(
              color: Color(0xffBBBBBB),
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }
}

OngCategory convertStringToOngCategory({required String ongCategory}) {
  if (ongCategory == 'animals') {
    return OngCategory.animals;
  } else if (ongCategory == 'education') {
    return OngCategory.education;
  } else if (ongCategory == 'health') {
    return OngCategory.health;
  } else if (ongCategory == 'environment') {
    return OngCategory.environment;
  } else if (ongCategory == 'humanRights') {
    return OngCategory.humanRights;
  } else if (ongCategory == 'arts') {
    return OngCategory.arts;
  } else {
    return OngCategory.technology;
  }
}