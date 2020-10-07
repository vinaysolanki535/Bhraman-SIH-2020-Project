import 'dart:ui';

import 'package:bhrammanbeta/Screens/profile/profile.dart';

import 'essence/essence.dart';

import 'package:bhrammanbeta/data/data.dart';
import 'package:bhrammanbeta/database/auth.dart';
import 'package:bhrammanbeta/database/firestore.dart';
import 'package:bhrammanbeta/resource/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'ar_lens.dart';

import 'explore.dart';
import 'home_page.dart';

class MainScreen extends StatefulWidget {



  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {




   final List<Widget> _widgetOptions = <Widget>[
     HomePage(),
     Explore(),
     ArLens(),
     Essence(),
     Profile(),
  ];

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAccountType();

  }


  Future<bool> onBackPressed() async{

      if(_selectedIndex != 0)  {

         setState(() {
           _selectedIndex = 0;
         });
         return false;
      }
      else{

        return true;
      }

  }

  bool accountType;
   getAccountType()async{
     AuthService.getBusinessAccount().then((value) {
         setState(() {
           accountType = value;
         });
     });
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(

      onWillPop: onBackPressed,

      child: Scaffold(

        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.lightBlue,
          selectedLabelStyle: TextStyle(color: blueGreen,fontWeight: FontWeight.w700),
          unselectedItemColor:black,
          unselectedLabelStyle: TextStyle(color: black,fontWeight: FontWeight.w700),
          showUnselectedLabels: true,
          currentIndex:  _selectedIndex,
          onTap: _onItemTapped,

          items: [
            BottomNavigationBarItem(
              icon:Icon(Icons.home,),
              title:Text("Home"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              title:Text("Explore"),
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.camera),
              title:Text("S-LENS"),
            ),

           accountType== true ?  BottomNavigationBarItem(
                icon: Icon(Icons.business_center),
                title: Text("Business",)

            ) : BottomNavigationBarItem(
               icon: Icon(Icons.local_florist),
               title: Text("Essence",)

           ),

            BottomNavigationBarItem(
              icon: Icon(Icons.perm_identity),
              title:Text("Profile"),
            ),



          ],
        ),

        body: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }
}



