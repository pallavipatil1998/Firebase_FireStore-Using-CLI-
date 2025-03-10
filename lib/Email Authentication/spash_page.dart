import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_fire_cli/Email%20Authentication/login_page.dart';
import 'package:flutter_fire_cli/Email%20Authentication/note_home_page.dart';
import 'package:flutter_fire_cli/Email%20Authentication/user_preference.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 4), () async {
      String uid = await UserPreferences().getUID();
      print("UserPreference Uid: ${uid}");
      Widget nextPage;
      if (uid != "") {
        nextPage = NoteHomePage(id:uid);
      } else {
        nextPage = LoginPage();
      }

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => nextPage,
          ));


    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent.shade100,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.edit_note_sharp,size: 200,color: Colors.blue.shade800,),
            Text("Notes App",style: TextStyle(fontSize: 50,color: Colors.blue.shade800,fontWeight: FontWeight.bold,))
          ],
        ),
      ),
    );
  }
}
