import 'package:flutter/material.dart';
import 'package:ong_app/controllers/bottom_app_bar_controller.dart';
import 'package:ong_app/controllers/filter_city_controller.dart';
import 'package:ong_app/models/enums.dart';
import 'package:ong_app/screens/home_screen.dart';
import 'package:ong_app/screens/login_screen.dart';
import 'package:ong_app/screens/main_screen.dart';
import 'package:ong_app/screens/register_screen.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WelcomeScreenBanner(),
              WelcomeScreenText(),
              SizedBox(
                width: 190,
                child: Column(
                  children: [
                    CitySelectButton(),
                    SizedBox(
                      height: 10,
                    ),
                    ViewOngButton(),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        EnterButton(),
                        SizedBox(width: 5,),
                        RegisterButton(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WelcomeScreenBanner extends StatelessWidget {
  const WelcomeScreenBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
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
          Center(child: Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Image.asset('assets/images/splash.png'),
          )),
          const Center(child: Padding(
            padding: EdgeInsets.only(bottom: 40),
            child: Text('Bem-vindo ao',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          )),
        ],
      ),
    );
  }
}

class WelcomeScreenText extends StatelessWidget {
  const WelcomeScreenText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('Faça um mundo melhor',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Color(0xFF1158C2),
          ),
        ),
        Text('sem sair de casa!',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Color(0xFF1158C2),
          ),
        ),
      ],
    );
  }
}

class CitySelectButton extends StatelessWidget {
  const CitySelectButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FilterCityController>(
      builder: (context, filterCityController, child) {

        bool isCitySelected = (filterCityController.getCitySelected() != '');
        return SizedBox(
          height: 35,
          width: 190,
          child: FilledButton(
            onPressed: () async {
              dynamic userSelect = await showDialog(context: context,
                builder: (context) => const CityAlert(),
              );

              userSelect ??= false;

              if(userSelect){
                filterCityController.setCitySelected(city: 'São Marcos');
              }
            },
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: const Color(0xFF1158C2),
            ),
            child: Text((isCitySelected) ? 'São Marcos' : 'Selecione sua cidade',
              maxLines: 1,
              style: const TextStyle(
                overflow: TextOverflow.ellipsis,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}

class ViewOngButton extends StatelessWidget {
  const ViewOngButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      width: 190,
      child: FilledButton(
        onPressed: (){
          FilterCityController filterCityController = Provider.of(context, listen: false);
          bool isCitySelected = (filterCityController.getCitySelected() != '');

          if(isCitySelected){
            BottomAppBarController bottomAppBarController = Provider.of(context, listen: false);
            bottomAppBarController.setSelectedScreen(screenType: ScreenType.home);

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const MainScreen(),),
            );
          } else {
            SnackBar snackBar = const SnackBar(content: Text('Selecione sua cidade!'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }

        },
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: const Color(0xFF1158C2),
        ),
        child: const Text('Visualizar ongs',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class EnterButton extends StatelessWidget {
  const EnterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          )
        );
      },
      child: const Text('entrar',
        style: TextStyle(
          fontSize: 14,
          color: Color(0xFF1158C2),
        ),
      ),
    );
  }
}

class RegisterButton extends StatelessWidget {
  const RegisterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const RegisterScreen(),
          ),
        );
      },
      child: const Text('registrar',
        style: TextStyle(
          fontSize: 14,
          color: Color(0xFF1158C2),
        ),
      ),
    );
  }
}

class CityAlert extends StatelessWidget {
  const CityAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 150,
        width: 400,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0XFFF1F1F1),
          borderRadius: BorderRadius.circular(16),

        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text('Selecione sua cidade:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff778080)
              ),
            ),
            const Divider(
              color: Color(0xffbbbbbb)
            ),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      child: TextButton(
                        onPressed: (){
                          Navigator.of(context).pop(true);
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                        child: const Text('São Marcos',
                          style: TextStyle(
                            fontSize: 16,
                              color: Color(0xff778080)
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



