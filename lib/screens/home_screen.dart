import 'package:flutter/material.dart';
import 'package:ong_app/controllers/filter_ong_category_controller.dart';
import 'package:ong_app/controllers/ong_controller.dart';
import 'package:ong_app/models/enums.dart';
import 'package:ong_app/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

import '../models/ong_model.dart';
import 'ong_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xffF3F3F3),
      body: SafeArea(
        child: Column(
          children: [
            HomeScreenBanner(),
            SizedBox(height: 20,),
            HorizontalCategoryList(),
            SizedBox(height: 20,),
            VerticalOngList(),
          ],
        ),
      ),
    );
  }
}

class HomeScreenBanner extends StatelessWidget {
  const HomeScreenBanner({super.key});

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

class HorizontalCategoryList extends StatelessWidget {
  const HorizontalCategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: TitleText(title: 'Categorias'),
        ),
        const SizedBox(height: 10,),
        horizontalList(),
      ],
    );
  }

  Widget horizontalList(){

    List<Map<String, dynamic>> categoryList = [
      {'category' : 'Educacao', 'icon' : const Icon(Icons.menu_book_sharp, color: Color(0xff778080),), 'ongCategory' : OngCategory.education},
      {'category' : 'Saude', 'icon' : const Icon(Icons.health_and_safety, color: Color(0xff778080),), 'ongCategory' : OngCategory.health},
      {'category' : 'Meio Amb.', 'icon' : const Icon(Icons.recycling, color: Color(0xff778080),), 'ongCategory' : OngCategory.environment},
      {'category' : 'Prot. Animal', 'icon' : const Icon(Icons.pets, color: Color(0xff778080),), 'ongCategory' : OngCategory.animals},
      {'category' : 'Direitos H.', 'icon' : const Icon(Icons.balance, color: Color(0xff778080),), 'ongCategory' : OngCategory.humanRights},
      {'category' : 'Cultura e Arte', 'icon' : const Icon(Icons.sports_martial_arts, color: Color(0xff778080),), 'ongCategory' : OngCategory.arts},
      {'category' : 'Tecn. e Inov.', 'icon' : const Icon(Icons.computer, color: Color(0xff778080),), 'ongCategory' : OngCategory.technology},
    ];

    return SizedBox(
      height: 100,
      width: double.infinity,
      child: ListView.builder(
        itemCount: categoryList.length,
        padding: const EdgeInsets.only(left: 20),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return HorizontalCategoryItem(categoryMap: categoryList[index],);
        },
      ),
    );
  }

}

class TitleText extends StatelessWidget {
  const TitleText({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class HorizontalCategoryItem extends StatelessWidget {
  const HorizontalCategoryItem({super.key, required this.categoryMap});

  final Map<String, dynamic> categoryMap;

  @override
  Widget build(BuildContext context) {
    return Consumer<FilterOngCategoryController>(
      builder: (context, filterOngCategoryController, child) {

        List<OngCategory> ongCategoryList = filterOngCategoryController.getOngCategoryList();
        bool isSelected = ongCategoryList.contains(categoryMap['ongCategory']!);

        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: GestureDetector(
            onTap: (){
              filterOngCategoryController.switchOngCategory(ongCategory: categoryMap['ongCategory']!);
            },
            child: Column(
              children: [
                Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: (isSelected ) ? const Color(0x331158c2) : const Color(0xffD9D9D9),
                    border: Border.all(
                      color: (isSelected ) ? const Color(0xff1158c2) : Colors.transparent,
                      width: 1
                    ),
                  ),
                  child: categoryMap['icon'],
                ),
                Text(categoryMap['category']!,
                  style: TextStyle(
                      color: (isSelected) ? const Color(0xff1158c2) : const Color(0xff778080),
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class VerticalOngList extends StatelessWidget {
  const VerticalOngList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TitleText(title: 'Lista de ongs em: '),
                CitySelectTextButton(),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            verticalOngList(),
          ],
        ),
      ),
    );
  }

  Widget verticalOngList(){
    return Consumer<OngController>(
      builder: (context, ongController, child) {

        List<Ong> ongList = ongController.getOngList();
        FilterOngCategoryController filterOngCategoryController = Provider.of(context, listen: true);
        List<OngCategory> ongCategoryList = filterOngCategoryController.getOngCategoryList();

        if(ongCategoryList.isNotEmpty){
          ongList = ongList.where((Ong ong) => (ongCategoryList.contains(ong.ongCategory)),).toList();
        }

        return Expanded(
          child: (ongList.isEmpty) ? const Text('Nenhuma ong encontrada',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xff778080)
            ),
          ) : ListView.builder(
            itemCount: ongList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: VerticalOngItem(ong: ongList[index],),
              );
            },
          ),
        );
      },
    );
  }
}

class CitySelectTextButton extends StatelessWidget {
  const CitySelectTextButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        showDialog(context: context,
          builder: (context) => const CityAlert(),
        );
      },
      child: const Row(
        children: [
          Text('São Marcos',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xff1158C2),
              fontWeight: FontWeight.bold,
            ),
          ),
          Icon(Icons.keyboard_arrow_down,
            color: Color(0xff1158C2),
            size: 18,
          )
        ],
      ),
    );
  }
}

class VerticalOngItem extends StatelessWidget {
  const VerticalOngItem({super.key, required this.ong});

  final Ong ong;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OngScreen(ong: ong,),
          ),
        );
      },
      child: Container(
        height: 75,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16)
        ),
        padding: const EdgeInsets.only(right: 10),
        child: Row(
          children: [
            image(),
            Expanded(child: ongInfo()),
            const Icon(Icons.keyboard_arrow_right,
              color: Color(0xff778080),
            )
          ],
        ),
      ),
    );
  }

  Widget image(){
    return Container(
      height: 75,
      width: 75,
      decoration: BoxDecoration(
        color: const Color(0xffD9D9D9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(16), child: Image(image: ong.image, fit: BoxFit.cover,)),
    );
  }

  Widget ongInfo(){
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(ong.name,
            style: const TextStyle(
              color: Color(0xff778080),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(ong.description,
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
