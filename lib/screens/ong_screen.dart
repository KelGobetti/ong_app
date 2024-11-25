import 'package:flutter/material.dart';
import 'package:ong_app/controllers/database_controller.dart';
import 'package:ong_app/models/project.dart';
import 'package:ong_app/screens/register_screen.dart';

import '../models/ong_model.dart';


class OngScreen extends StatelessWidget {
  const OngScreen({super.key, required this.ong, this.isApproval = false});

  final Ong ong;
  final bool isApproval;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visualizacao da ONG',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xff353535)
          ),
        ),
        forceMaterialTransparency: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200,
                    width: 200,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: const Color(0xffd9d9d9),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image(image: ong.image, fit: BoxFit.cover,),
                    ),
                  ),
                  const SizedBox(height: 24,),
                  const OngInfoTitle(title: 'informacoes',),
                  OngInfoItem(title: ong.name, description: 'Nome da ong'),
                  OngInfoItem(title: ong.cellNumber, description: 'Telefone da ong'),
                  OngInfoItem(title: ong.description, description: 'Descricao da ong'),
                  OngInfoItem(title: convertOngCategoryToString(ongCategory: ong.ongCategory), description: 'Categoria'),
                  const SizedBox(height: 24,),
                  const OngInfoTitle(title: 'Endereco',),
                  OngInfoItem(title: ong.state, description: 'Estado'),
                  OngInfoItem(title: ong.city, description: 'Cidade'),
                  OngInfoItem(title: ong.road, description: 'Rua'),
                  OngInfoItem(title: ong.cep, description: 'CEP'),
                  const SizedBox(height: 24,),
                  const OngInfoTitle(title: 'Ajude esta ONG!',),
                  OngInfoItem(title: ong.pixKey, description: 'Chave pix para doacoes!'),
                  const SizedBox(height: 24,),
                  const OngInfoTitle(title: 'Projetos',),
                  OngProjectList(projectList: ong.projectList,),
                ],
              ),
              Visibility(visible: isApproval, child: Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: ApprovalButton(ong: ong,),
              ),)
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xffF3F3F3),
    );
  }
}

class OngInfoTitle extends StatelessWidget {
  const OngInfoTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title,
      style: const TextStyle(
        fontSize: 16,
        color: Color(0xff353535),
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class OngInfoItem extends StatelessWidget {
  const OngInfoItem({super.key, required this.title, required this.description, this.maxLines = 1});

  final String title;
  final String description;
  final int maxLines;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20 + (30 * maxLines.toDouble()),
      width: double.infinity,
      padding: const EdgeInsets.only(top: 5),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xfff1f1f1),
            width: 1,
          ),
        ),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(title,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xff778080),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(description,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xffbbbbbb),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OngProjectList extends StatelessWidget {
  const OngProjectList({super.key, required this.projectList});

  final List<Project> projectList;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: projectList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return OngInfoItem(title: projectList[index].name, description: projectList[index].description, maxLines: 3,);
      },
    );
  }
}

class ApprovalButton extends StatelessWidget {
  const ApprovalButton({super.key, required this.ong});

  final Ong ong;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      width: 190,
      child: FilledButton(
        onPressed: () async {
          Navigator.of(context).pop(true);

          DatabaseController databaseController = DatabaseController();

          Map<String, dynamic> newData = {
            'isVerified' : true,
          };

          databaseController.updateOngData(email: ong.email, newData: newData);
        },
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: const Color(0xFF1158C2),
        ),
        child: const Text('Aprovar',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }



}


