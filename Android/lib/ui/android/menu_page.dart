import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/ui/android/widget/color_material.dart';
import 'package:flutter_template/ui/android/widget/pixel.dart';
import 'package:flutter_template/ui/android/menu/home_page.dart';
import 'package:flutter_template/ui/android/menu/maps_page.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  PersistentTabController controller;
  List<PersistentBottomNavBarItem> navBarItem = [
    PersistentBottomNavBarItem(
      icon: Icon(Icons.home),
      title: 'Beranda',
      activeColor: ColorMaterial.secondary,
      inactiveColor: Colors.white,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(Icons.map),
      title: 'Peta',
      activeColor: ColorMaterial.secondary,
      inactiveColor: Colors.white,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    Pixel().init(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        color: ColorMaterial.main,
        child: SafeArea(
          child: PersistentTabView(
            controller: controller,
            screens: [
              HomePage(),
              MapsPage(),
            ],
            items: navBarItem,
            confineInSafeArea: true,
            backgroundColor: ColorMaterial.main,
            handleAndroidBackButtonPress: true,
            resizeToAvoidBottomInset: true,
            stateManagement: true,
            hideNavigationBarWhenKeyboardShows: true,
            decoration: NavBarDecoration(
              colorBehindNavBar: ColorMaterial.main,
            ),
            popAllScreensOnTapOfSelectedTab: true,
            itemAnimationProperties: ItemAnimationProperties(
              duration: Duration(
                milliseconds: 200,
              ),
              curve: Curves.ease,
            ),
            screenTransitionAnimation: ScreenTransitionAnimation(
              animateTabTransition: true,
              curve: Curves.ease,
              duration: Duration(milliseconds: 200),
            ),
            navBarStyle: NavBarStyle.simple,
          ),
        ),
      ),
    );
  }
}
