import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/services/firebase_db.dart';
import 'package:flutter_template/services/service_init.dart';
import 'package:flutter_template/ui/android/widget/my_colors.dart';
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
      activeColor: MyColors.secondary,
      inactiveColor: Colors.white,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(Icons.map),
      title: 'Peta',
      activeColor: MyColors.secondary,
      inactiveColor: Colors.white,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    Pixel().init(context);
    ServiceInit.init();
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        color: MyColors.main,
        child: SafeArea(
          child: PersistentTabView(
            controller: controller,
            screens: [
              HomePage(),
              MapsPage(),
            ],
            items: navBarItem,
            confineInSafeArea: true,
            backgroundColor: MyColors.main,
            handleAndroidBackButtonPress: true,
            resizeToAvoidBottomInset: true,
            stateManagement: true,
            hideNavigationBarWhenKeyboardShows: true,
            decoration: NavBarDecoration(
              colorBehindNavBar: MyColors.main,
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
            floatingActionButton: FloatingActionButton(
              onPressed: () => FirebaseDb.addData(),
            ),
          ),
        ),
      ),
    );
  }
}
