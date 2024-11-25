import 'package:flutter/material.dart';
import 'package:ong_app/controllers/database_controller.dart';
import 'package:ong_app/controllers/ong_controller.dart';
import 'package:ong_app/models/project.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/ong_model.dart';

class ProjectScreen extends StatelessWidget {
  const ProjectScreen({super.key, required this.ong});

  final Ong ong;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Meus projetos',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        forceMaterialTransparency: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: OngProjectList(
            ong: ong,
          ),
        ),
      ),
      backgroundColor: const Color(0xffF3F3F3),
      floatingActionButton: CreateProjectFloatingActionButton(
        ong: ong,
      ),
    );
  }
}

class CreateProjectFloatingActionButton extends StatelessWidget {
  const CreateProjectFloatingActionButton({super.key, required this.ong});

  final Ong ong;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        OngController ongController = Provider.of(context, listen: false);

        String projectId = const Uuid().v1();

        Project project =
            Project(id: projectId, name: 'nome', description: 'descricao');
        ongController.createProject(ong: ong, project: project);

        DatabaseController databaseController = DatabaseController();

        List<dynamic> databaseProjectList = [];

        for(Project project in ong.projectList){
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

        databaseController.updateOngData(email: ong.email, newData: newData);
      },
      backgroundColor: const Color(0xff1158c2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }
}

class OngProjectList extends StatelessWidget {
  const OngProjectList({super.key, required this.ong});

  final Ong ong;

  @override
  Widget build(BuildContext context) {
    return Consumer<OngController>(
      builder: (context, ongController, child) {
        final List<Project> projectList = ong.projectList;

        return (projectList.isNotEmpty)
            ? projectListWidget(context: context, projectList: projectList)
            : const Center(
                child: Text(
                  'Nenhum projeto encontrado',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff778080),
                  ),
                ),
              );
      },
    );
  }

  Widget projectListWidget(
      {required BuildContext context, required List<Project> projectList}) {
    OngController ongController = Provider.of(context, listen: false);

    return ListView.builder(
      itemCount: projectList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Dismissible(
            key: UniqueKey(),
            background: Container(
              color: Colors.red,
            ),
            direction: DismissDirection.endToStart,
            confirmDismiss: (_) async {
              dynamic userSelect = await showDialog(
                context: context,
                builder: (context) => const DeleteAlert(),
              );
              userSelect ??= false;

              return userSelect;
            },
            onDismissed: (_) {
              ongController.deleteProject(
                  ongId: ong.id, projectId: projectList[index].id);
            },
            child: OngProjectItem(
              maxLines: 3,
              project: projectList[index],
            ));
      },
    );
  }
}

class OngProjectItem extends StatelessWidget {
  const OngProjectItem(
      {super.key,
      this.maxLines = 1,
      required this.project,
      });

  final int maxLines;

  final Project project;

  @override
  Widget build(BuildContext context) {

    TextEditingController nameTextEditingController = TextEditingController();
    TextEditingController descriptionTextEditingController = TextEditingController();

    nameTextEditingController.text = project.name;
    descriptionTextEditingController.text = project.description;

    FocusNode focusNode = FocusNode();

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
            SizedBox(
              height: 20,
              child: TextFormField(
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xff778080),
                  fontWeight: FontWeight.bold,
                ),
                controller: nameTextEditingController,
                maxLines: 1,
                maxLength: 30,
                onChanged: (_){
                  project.name = nameTextEditingController.text;
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 5),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
              ),
            ),
            TextFormField(
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xffbbbbbb),
                fontWeight: FontWeight.bold,
              ),
              controller: descriptionTextEditingController,
              onChanged: (_){
                project.description = descriptionTextEditingController.text;
              },
              maxLines: 3,
              minLines: 1,
              onTapOutside: (_){
                focusNode.unfocus();
              },
              focusNode: focusNode,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DeleteAlert extends StatelessWidget {
  const DeleteAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 370,
        height: 130,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: const Color(0xfff1f1f1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Deletar este projeto?',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff778080)),
            ),
            actions(context: context),
          ],
        ),
      ),
    );
  }

  Widget actions({required BuildContext context}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: 40,
          width: 120,
          child: FilledButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            style: FilledButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                )),
            child: const Text(
              'Sim',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 40,
          width: 120,
          child: FilledButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                )),
            child: const Text(
              'Cancelar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

