import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/services/firebase_db.dart';
import 'package:flutter_template/services/service_init.dart';
import 'package:flutter_template/ui/android/menu/home_page.dart';
import 'package:flutter_template/ui/android/widget/my_colors.dart';
import 'package:flutter_template/ui/android/widget/pixel.dart';

class MenuNoBottomPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Pixel().init(context);
    ServiceInit.init();
    return Container(
      color: MyColors.main,
      child: SafeArea(
        child: Scaffold(
          body: HomePage(),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: MyColors.secondary,
            onPressed: () => FirebaseDb.addData(),
          ),
        ),
      ),
    );
  }
}
