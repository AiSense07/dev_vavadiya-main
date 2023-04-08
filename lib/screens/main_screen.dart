import 'package:ai_sense/screens/home_modual/home_screen.dart';
import 'package:ai_sense/screens/setting_modual/setting_screen.dart';
import 'package:flutter/material.dart';

import '../helper/colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int tabIndex = 0;
  List<Widget> screens = [HomeScreen(), SettingScreen()];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.only(top: 5, bottom: MediaQuery.of(context).padding.bottom + 5),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              color: AppColors.primary,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                btn(tab: 0, icon: Icons.home_filled),
                IconButton(
                  onPressed: () {},
                  icon: Image.asset(
                    "assets/whiteLogo.png",
                    fit: BoxFit.cover,
                  ),
                ),
                btn(tab: 1, icon: Icons.settings),
              ],
            ),
          ),
        ],
      ),
      body: screens[tabIndex],
    );
  }

  Widget btn({required int tab, required IconData icon}) {
    return IconButton(
      onPressed: () {
        setState(() {
          tabIndex = tab;
        });
      },
      icon: CircleAvatar(
        backgroundColor: tabIndex == tab ? Colors.white24 : Colors.transparent,
        child: Icon(
          icon,
          color: AppColors.white,
        ),
      ),
    );
  }
}
