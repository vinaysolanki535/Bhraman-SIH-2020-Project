import 'package:bhrammanbeta/Screens/signup.dart';
import 'package:bhrammanbeta/Widgets/widgets.dart';
import 'package:bhrammanbeta/database/auth.dart';
import 'package:bhrammanbeta/database/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'main_screen.dart';

class Login extends StatefulWidget {

  final String type;
  Login({this.type});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController emailTEC = TextEditingController();
  TextEditingController passwordTEC = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool passwordShow = true;

  AuthService _auth =  AuthService();
  
  bool clicked = false;
  bool clickedGoogle = false;

  DatabaseService databaseService = DatabaseService();
  
  Widget login() {
    if(clicked ==  false) {
       return MaterialButton(
        minWidth: double.infinity,
        color: Colors.blue,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(58.0),
        ),
        onPressed: () async{

          if(!_formKey.currentState.validate()) {
            print(emailTEC.text);
            print(passwordTEC.text);
          }
          else {
            setState(() {
              clicked = true;
            });

             dynamic result = await _auth.signInUserWithEmailAndPassword(emailTEC.text, passwordTEC.text);


               if(result!=null) {
                 dynamic userData = await databaseService.getUserDataFromFireStore(userId: result.toString());

                 saveDataToSharedPrefStorage(userName: userData['name'], userId: result.toString(), profilePhoto: userData['profilePic']);


                 Navigator.pushReplacement(context,  MaterialPageRoute(
                     builder:  (context) => MainScreen()
                 ));
               }



          }
        },
        height: 50.0,
        child: Text("Login", style: TextStyle(
          fontSize: 20.0,
          color: Colors.white,
          fontFamily: 'actor',
        ),),
      );
    }
    return CircularProgressIndicator();
  }


  void saveDataToSharedPrefStorage({String userName, String userId, String profilePhoto}) async {
    await AuthService.saveUserIdSharedPref(userId);
    await  AuthService.saveUserNameSharedPref(userName);
    await AuthService.saveUserLoggedInSharedPref(true);
    await AuthService.saveProfilePhotoSharedPref(profilePhoto);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,

      //main Container
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(

            child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 20,),
                    Column(
                      children: <Widget>[
                        Text('Login', style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 35.0,fontFamily: 'sf_pro_bold'
                        ),),
                        SizedBox(height: 10.0),
                        Text('Login to your ${widget.type!=null ? "business " : ''}account', style: TextStyle(
                            fontSize: 18.0, color: Colors.black45
                         ),
                        ),
                      ],
                    ),
                    //Login head..

                    //Text Field
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[

                            MakeInput(
                                validator: (val) {
                                  if(val.isEmpty) {
                                    return "Email is empty";
                                  }
                                   if(!RegExp(r"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$").hasMatch(val)) {
                                    return "Invalid Email";
                                  }
                                    return null;
                                },
                                label: "Email",
                                textController: emailTEC,
                                inputType: TextInputType.emailAddress
                            ),//email field

                            MakeInput(
                                validator: (val) {

                                  if(val.isEmpty) {
                                    return "Password Is Empty";
                                  }
                                  if(val.length < 6 ) {
                                    return 'Password must of at least 6 characters';
                                  }
                                  return null;

                                },
                                label: "Password",
                                obscureText: passwordShow,
                                textController: passwordTEC,
                                inputType: TextInputType.text,
                                iconPass: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if(passwordShow == true) {
                                        passwordShow =false;
                                      }
                                      else{
                                        passwordShow= true;
                                      }
                                    });
                                  },
                                  child: Icon(
                                    Icons.remove_red_eye,
                                  ),
                                )
                            ),//password field

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text('forgot password?', style: TextStyle(
                                    fontSize: 15.0, color: Colors.blueAccent),),
                              ],
                            ),

                            //Login Button
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(58.0),
                                ),
                                child: login(),
                              ),
                            ),
                            //Login Button
                          ],
                        ),
                      ),
                    ),
                    //Text Field



                    //Sign up...
                    Container(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Don\'t have an account ? | ', style: TextStyle(
                              fontSize: 16.0, color: Colors.black45),),
                          GestureDetector(
                              onTap: () {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> SignUp()));
                              },
                              child: Text('Sign Up',
                                style: TextStyle(fontSize: 16.0, color: Colors
                                    .blueAccent,),
                              )
                          ),
                        ],
                      ),
                    ),
                    //Sign up...

                    SizedBox(height: 5,),

                    //login with social account..
                    Text("--------OR--------",
                      style: TextStyle(fontSize: 16.0, color: Colors.black45),),
                    SizedBox(height: 5,),
                    Text("Login With",
                      style: TextStyle(fontSize: 16.0, color: Colors.black45),),
                    SizedBox(height: 8,),

                    clickedGoogle==true ? CircularProgressIndicator() :
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        //login with google..
                        GestureDetector(
                          onTap: () async{
                             setState(() {
                               clickedGoogle  = true;
                             });

                             await _auth.googleSignIn().then((value){
                               if(value!=null) {
                                 saveDataToSharedPrefStorage(userName: value.displayName,userId : value.uid,profilePhoto : value.photoUrl);
                                 Navigator.pushReplacement(context,  MaterialPageRoute(
                                     builder:  (context) => MainScreen()
                                 ));
                               }

                             });

                          },
                          child: Image(
                            height: 45.0,
                            width: 45.0,
                            image: AssetImage('assets/images/google.png'),
                          ),
                        ),
                        //login with google..

                        SizedBox(width: 10,),

                      ],
                    ),

                    SizedBox(height:10),
                    //Last Image...
                    Container(
                      height:230,
                      child: Image(
                        image: AssetImage('assets/images/loginpic.png'),
                      ),

                    ),
                  ],
                ),
                //login with social account..
          ),
        ),
      ),
    );
  }
}

