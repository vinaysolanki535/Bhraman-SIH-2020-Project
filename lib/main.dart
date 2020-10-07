import 'package:bhrammanbeta/Screens/before_login/before_login.dart';
import 'package:bhrammanbeta/Screens/main_screen.dart';
import 'package:bhrammanbeta/Screens/on_boarding_screen/landing.dart';
import 'package:bhrammanbeta/database/auth.dart';
import 'package:bhrammanbeta/resource/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



import 'Screens/login.dart';

void main() {
  runApp(
      MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool loggedIn = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOnBoardingSeen();
    checkLogIn();
    Future.delayed(
      Duration(seconds: 3),
        () {


          if(loggedIn == true) {
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => MainScreen(),
            ));
          }
          else if(onBoarding == false && loggedIn == false) {
            Navigator.pushReplacement(context,MaterialPageRoute(
              builder: (context) => OnBoarding(),
            ));
          }
          else{
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => BeforeLoginPage(),
            ));
          }


        },
    );
  }

  checkLogIn() async {
    await FirebaseAuth.instance.currentUser().then((value){
       if(value != null  ) {
         setState(() {
           loggedIn = true;
         });
       }
    });
  }

  bool onBoarding = false;
  getOnBoardingSeen() async {
    await AuthService.getOnBoardingScreenSeenSharedPref().then((value) {

      if(value!=null) {
        setState(() {
          onBoarding = value;
        });
      }


    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashScreen(),
    );
  }
}
//loggedIn ? MainScreen() : Login()

