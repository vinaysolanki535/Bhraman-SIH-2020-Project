import 'package:bhrammanbeta/Screens/main_screen.dart';
import 'package:bhrammanbeta/Widgets/widgets.dart';
import 'package:bhrammanbeta/database/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import 'login.dart';


class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  TextEditingController emailTEC = TextEditingController();
  TextEditingController passwordTEC = TextEditingController();
  TextEditingController nameTEC = TextEditingController();
  TextEditingController confirmPasswordTEC = TextEditingController();
  TextEditingController phoneTEC = TextEditingController();


  final _formKey = GlobalKey<FormState>();

  bool passwordShow = true;

  AuthService _auth =  AuthService();

  bool clicked = false;

  Widget signUp() {
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

            await _auth.registerWithEmailAndPassword(
              email: emailTEC.text,password: passwordTEC.text,phone: phoneTEC.text,name: nameTEC.text)
            .then((value) {


               Navigator.pushReplacement(context, MaterialPageRoute(
                 builder:   (context) => MainScreen(),
               ));

            });



          }
        },
        height: 50.0,
        child: Text("Sign Up", style: TextStyle(
          fontSize: 20.0,
          color: Colors.white,
          fontFamily: 'actor',
        ),),
      );
    }
    return CircularProgressIndicator();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              SizedBox(height: 50,),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text('Sign Up',style: TextStyle(
                          fontWeight: FontWeight.bold,fontSize: 35.0
                      ),),
                      SizedBox(height:10.0),
                    ],
                  ),



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
                                  return "Field Is Empty";
                                }
                                return null;
                              },
                              label: "Name",
                              textController: nameTEC,
                              inputType: TextInputType.name
                          ),//name

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
                                  return "Field is empty";
                                }
                                if(val.length<10 || val.length>10) {
                                  return 'Invalid Phone Number';
                                }
                                return null;
                              },
                              label: "Phone Number",
                              textController: phoneTEC,
                              inputType: TextInputType.number
                          ),//phone

                          MakeInput(
                              validator: (val) {
                                if(val.isEmpty) {
                                  return "Field Is Empty";
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

                          MakeInput(
                              textController: confirmPasswordTEC,
                              validator: (val) {
                                if(val.isEmpty) {
                                  return "Field Is Empty";
                                }
                                if(val != passwordTEC.text ) {
                                  return 'Both password should match';

                                }

                                return null;
                              },
                              obscureText: true,
                              label: "Confirm Password",
                              inputType: TextInputType.text,
                          ),//confirmPassword field



                          //Sign UP Button
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 5),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(58.0),

                              ),
                              child: signUp(),
                            ),
                          ),
                          //Sign Up Button

                        ],
                      ),
                    ),
                  ),
                  //Text Field

                  GestureDetector(
                    onTap:() {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) => Login()
                      ));
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Already have an account? | ',
                          style: TextStyle(fontSize: 15,color: Colors.grey),),
                          Text('Log In',style:TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 15
                          ),)
                        ],
                      ),
                    ),
                  ),


                //last image//
                Container(
                height: 150,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/sign_up_pic.png'),
                    )
                ),
              ), //last image//
            ],
          ),
      ],
       ),
        ),
      )
    );
  }
}


