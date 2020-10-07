import 'dart:io';

import 'package:bhrammanbeta/Widgets/form_field.dart';
import 'package:bhrammanbeta/database/auth.dart';
import 'package:bhrammanbeta/database/firestore.dart';
import 'package:bhrammanbeta/resource/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddStoriesForm extends StatefulWidget {
  @override
  _AddStoriesFormState createState() => _AddStoriesFormState();
}

class _AddStoriesFormState extends State<AddStoriesForm> {

  TextEditingController storyTitleController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController storyController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  DatabaseService databaseService = DatabaseService();
  File file;
  String userId,userName;
  bool warning  = false;

  bool clicked = false;

  initState() {
    super.initState();
    getUserId();
  }

  getUserId() async{
    await AuthService.getUserIdSharedPref().then((value) {
      if(value!=null) {
        setState(() {
          userId = value;
        });
      }
    });

    await AuthService.getUserNameSharePref().then((value) {
      if(value!=null) {
        setState(() {
          userName = value;
        });
      }
    });

  }

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

            //save image to storage//
            StorageUploadTask uploadThumbnailImage = FirebaseStorage.instance.ref().child("Story").
                      child(userId).child(Timestamp.now().toString()).child("IntangibleImage").putFile(file);

            final StorageTaskSnapshot imageDownloadUrl =
            (await uploadThumbnailImage.onComplete);
            final String imageUrl = await imageDownloadUrl.ref.getDownloadURL();
            //save image to storage//


            //save storyData to Firebase//
            await databaseService.saveUserStoryToFirebase(userId : userId, storyTitle : storyTitleController.text,
            story :  storyController.text, imageUrl:  imageUrl,
                city: cityController.text, state: stateController.text);
            //save storyData to Firebase//

            Navigator.pop(context);

          }
        },
        height: 50.0,
        child: Text("Submit Story", style: TextStyle(
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
        title: Text('Add Stories'),
      ),
      
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [

                 FormInputField(
                   validator: (value){
                     if(value.isEmpty) {
                       return "title should not be empty";
                     }
                     return null;
                   },

                   textController: storyTitleController,
                   inputLabel: "Story Title*",
                   hintText: "Title of the Story",

                ),

                SizedBox(
                  height: 20,
                ),

                FormInputField(
                  validator: (value){
                    if(value.isEmpty) {
                      return "city should not be empty";
                    }
                    return null;
                  },
                  textController: cityController,
                  inputLabel: "City*",
                  hintText: "City",
                ),

                SizedBox(
                  height: 20,
                ),

                FormInputField(
                  validator: (value){
                    if(value.isEmpty) {
                      return "state should not be empty";
                    }
                    return null;
                  },
                  textController: stateController,
                  inputLabel: "State*",
                  hintText: "State",
                ),

                SizedBox(
                  height: 20,
                ),

                FormInputField(
                  validator: (value){
                    if(value.isEmpty) {
                      return "Story should not be empty";
                    }
                    return null;
                  },
                  textController: storyController,
                  inputLabel: "Story*",
                  hintText: "Story",
                ),

                SizedBox(height: 20,),

                Text(
                  "Add an image for the story*",
                   style: (
                     TextStyle(
                       color: black,
                       fontFamily: 'sf_pro_semi_bold',
                       fontSize: 20,
                     )
                   ),
                ),

                SizedBox(height: 15,),

                 Container(
                     alignment: Alignment.center,
                     child: Stack(
                       children: [
                         Container(
                           alignment: Alignment.center,
                           width: MediaQuery.of(context).size.width,
                           child: Image(
                             height: 250,
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
                               final pickedFile = await ImagePicker.pickImage(source: ImageSource.gallery,
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




              ],
             ),

          ),
        ),
      ),
      
    );
  }
}
