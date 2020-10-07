import 'package:bhrammanbeta/database/auth.dart';
import 'package:bhrammanbeta/resource/color.dart';
import 'package:flutter/material.dart';

import '../login.dart';

class BeforeLoginPage extends StatefulWidget {
  @override
  _BeforeLoginPageState createState() => _BeforeLoginPageState();
}

class _BeforeLoginPageState extends State<BeforeLoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: EdgeInsets.only(left: 18.0,top: 15.0,right: 18.0),
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("Welcome",style: TextStyle(fontFamily: 'sf_pro_bold',fontSize: 30.0,),
                    ),

                    SizedBox(height: 10.0,),
                    Text("Let's Bhraman INDIA",style: TextStyle(
                        fontSize: 24.0,color: Colors.black45,fontFamily: 'normal_font'),),
                  ],
                ),

                Container(
                    height: MediaQuery.of(context).size.height*0.30,
                 child :  Image(

                    image: AssetImage('assets/images/mainpic.png',),
                  )
                ),

                Column(
                  children: [
                    Container(
                      height:50,
                      width: MediaQuery.of(context).size.width*0.80,
                      child: MaterialButton(
                        onPressed: ()async {
                          await AuthService.setBusinessAccount(false);
                          Navigator.pushReplacement(context, MaterialPageRoute(
                              builder: (context) => Login(),
                          ));
                        },
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        color: Colors.lightBlue,
                        child: Text("Login As User",style: TextStyle(color: white,fontSize: 20, fontFamily: 'normal_font')),
                      ),
                    ),

                    SizedBox(height: 10,),

                    Container(
                      height:50,
                      width: MediaQuery.of(context).size.width*0.80,
                      child: MaterialButton(
                        onPressed: ()async{
                           await AuthService.setBusinessAccount(true);
                           Navigator.pushReplacement(context, MaterialPageRoute(
                             builder: (context) => Login(type : "Business"),
                           ));
                        },
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        color: Colors.green,
                        child: Text("Login As Business",
                            style: TextStyle(color: white,fontSize: 20, fontFamily: 'normal_font')
                        ),
                      ),
                    ),
                  ],
                )



              ],
            ),
          ),
        ),
      ),
    );
  }
}
