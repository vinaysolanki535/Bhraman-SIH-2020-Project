

import 'dart:io';

import 'package:bhrammanbeta/Widgets/form_field.dart';
import 'package:bhrammanbeta/database/auth.dart';
import 'package:bhrammanbeta/database/firestore.dart';
import 'package:bhrammanbeta/resource/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddMonumentsForm extends StatefulWidget {
  @override
  _AddMonumentsFormState createState() => _AddMonumentsFormState();
}

class _AddMonumentsFormState extends State<AddMonumentsForm> {

  final monumentName = TextEditingController();
  final about = TextEditingController();
  final history = TextEditingController();
  final location = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final entryFee = TextEditingController();
  final shortDescription = TextEditingController();



  initState(){
    super.initState();
    getUserId();
    getUserName();
  }

  bool warning  = false;
  final _formKey = GlobalKey<FormState>();
  DatabaseService databaseService = DatabaseService();
  bool clicked = false;
  String userName;

  getUserName() async{
    await AuthService.getUserNameSharePref().then((value) {
      setState(() {
        userName  = value;
      });
    });
  }



  String userId;
  getUserId() async {
    await AuthService.getUserIdSharedPref().then((value){
      setState(() {
        userId = value.toString();
      });
    });
  }

  File file;

  Widget submitBtn() {
    if(clicked ==  false) {
      return MaterialButton(
        minWidth: double.infinity,
        color: Colors.blue,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(58.0),
        ),
        onPressed: () async{

          if(!_formKey.currentState.validate() || file == null) {

            setState(() {
              warning = true;
            });

          }
          else {
            setState(() {
              clicked = true;
            });

            StorageUploadTask uploadThumbnailImage = FirebaseStorage.instance.ref().child("FoodShop").
            child(userId).child(Timestamp.now().toString()).child(monumentName.text).putFile(file);

            final StorageTaskSnapshot imageDownloadUrl =
            (await uploadThumbnailImage.onComplete);
            final String imageUrl = await imageDownloadUrl.ref.getDownloadURL();


            await Firestore.instance.collection("MonumentsUser").document().setData({
                'monumentName' : monumentName.text,
                'about' : about.text,
                'history' : history.text,
                'location' : location.text,
                'city' : cityController.text,
                'state' : stateController.text,
                'entry' : entryFee.text,
                'shortDescription' : shortDescription.text,
                'userId' : userId,
                "userName" : userName,
                'imageUrl' : imageUrl,
                'timeStamp' : Timestamp.now(),
            });



            Navigator.pop(context);



          }
        },
        height: 50.0,
        child: Text("Submit", style: TextStyle(
          fontSize: 20.0,
          color: Colors.white,
          fontFamily: 'sf_pro_bold',
        ),),
      );
    }
    return CircularProgressIndicator();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Monuments"),
      ),

      body: Container(
        padding: EdgeInsets.only(left: 13,right: 13),
        child: ListView(
          children: [
            Form(
              key: _formKey,
              child: Column(

                children: [
                  FormInputField(
                    inputLabel: "Name of Monument*",
                    hintText: "Monument Name",
                    textController: monumentName,
                    validator: (value){
                      if(value.isEmpty){
                        return "Field should not be empty";
                      }
                      return null;
                    },

                  ),
                  SizedBox(height: 10,),
                  FormInputField(
                    inputLabel: "About*",
                    hintText: "About Monument",
                    textController: about,
                    validator: (value){
                      if(value.isEmpty){
                        return "Field should not be empty";
                      }
                      return null;
                    },

                  ),
                  SizedBox(height: 10,),
                  FormInputField(
                    inputLabel: "History",
                    hintText: "History",
                    textController: history,
                    validator: (value){
                      if(value.isEmpty){
                        return "Field should not be empty";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 10,),

                  FormInputField(
                    inputLabel: "Monument Location*",
                    hintText: "Monument Location",
                    textController: location,
                    validator: (value){
                      if(value.isEmpty){
                        return "Field should not be empty";
                      }
                      return null;
                    },
                  ),

                  FormInputField(
                    inputLabel: "Entry Fee*",
                    hintText: "Entry Fee",
                    textController: entryFee,
                    validator: (value){
                      if(value.isEmpty){
                        return "Field should not be empty";
                      }
                      return null;
                    },
                  ),




                  SizedBox(height: 10,),

                  FormInputField(
                    inputLabel: "Short Description*",
                    hintText: "Short Description",
                    textController: shortDescription,
                    validator: (value){
                      if(value.isEmpty){
                        return "Field should not be empty";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 10,),


                  FormInputField(
                    inputLabel: "City*",
                    hintText: "City",
                    textController: cityController,
                    validator: (value){
                      if(value.isEmpty){
                        return "Field should not be empty";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 10,),
                  FormInputField(
                    inputLabel: "State*",
                    hintText: "State",
                    textController: stateController,
                    validator: (value){
                      if(value.isEmpty){
                        return "Field should not be empty";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10,),

                  Container(
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            child: Image(
                              height: 300,
                              width: 300,
                              fit: BoxFit.cover,
                              image:
                              file != null ? FileImage(file)
                                  :  AssetImage('assets/images/dummy.jpg'),
                            ),
                          ),

                          GestureDetector(
                            onTap: () async{
                              if(file == null) {
                                final pickedFile = await
                                ImagePicker.pickImage(source: ImageSource.gallery,
                                    imageQuality: 100);

                                setState(() {
                                  file = File(pickedFile.path);

                                });
                              }

                              else {
                                setState(() {
                                  file = null;
                                });
                              }

                            },
                            child: Container(
                                width: 50,
                                height: 50,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: Colors.blue,
                                ),
                                margin: EdgeInsets.only(top: 150,left: 250),
                                alignment: Alignment.center,
                                child:file == null ?   Icon(
                                  Icons.add,color: white,
                                ) :
                                Icon(
                                  Icons.remove,color: white,
                                )
                            ),
                          ),
                        ],
                      )
                  ),

                  SizedBox(height: 10,),

                  file == null && warning == true ?
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Please Upload an Image",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ): Container(),

                  SizedBox(height: 20,),
                  submitBtn(),
                  SizedBox(height: 30,)

                ],
              ),
            )
          ],
        ),
      ),


    );
  }
}
