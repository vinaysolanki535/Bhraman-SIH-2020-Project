import 'dart:io';

import 'package:bhrammanbeta/Widgets/form_field.dart';
import 'package:bhrammanbeta/database/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {

  final profilePic;
  final name;
  final userId;

  EditProfile({this.profilePic,this.name,this.userId});

  @override
  _EditProfileState createState() => _EditProfileState();
}


class _EditProfileState extends State<EditProfile> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  initState(){
    super.initState();
    setState(() {
      nameController.text  = widget.name;
    });
  }

  File imageFile;

  bool clicked = false;


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

          if(!_formKey.currentState.validate()) {

          }
          else {
            setState(() {
              clicked = true;
            });

            if (imageFile!=null) {
              StorageUploadTask uploadThumbnailImage = FirebaseStorage.instance.ref().
              child(widget.userId).child("ProfilePic").putFile(imageFile);

              final StorageTaskSnapshot imageDownloadUrl =
              (await uploadThumbnailImage.onComplete);
              final String imageUrl = await imageDownloadUrl.ref.getDownloadURL();

              Firestore.instance.collection("Users").document(widget.userId).updateData({
                "profilePic" : imageUrl,
              });

              AuthService.saveProfilePhotoSharedPref(imageUrl);

            }


            Firestore.instance.collection("Users").document(widget.userId).updateData({
              "name" : nameController,
              "bio" : bioController,
            });

            AuthService.saveUserNameSharedPref(nameController.text);

            Navigator.pop(context);

          }
        },
        height: 50.0,
        child: Text("UPDATE", style: TextStyle(
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
        backgroundColor: Colors.lightBlue,
        title: Text("Edit Profile"),
      ),

      body: Container(
        padding: EdgeInsets.all(20),
        alignment: Alignment.center,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: ()async{
                  File image = await ImagePicker.pickImage(source: ImageSource.gallery);
                  setState(() {
                     imageFile  = File(image.path);
                  });
                },
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage:imageFile != null ? FileImage(imageFile) :  widget.profilePic!= null ?
                  NetworkImage(widget.profilePic) : AssetImage('assets/icons/profile_avatar.jpg'),
                ),
              ),


              SizedBox(height: 20,),

              FormInputField(
                validator: (value){
                  if(value.isEmpty) {
                    return "Name should not be empty";
                  }
                  return null;
                },
                textController: nameController,
                inputLabel: "Display Name",
                hintText: widget.name!=null ? widget.name : "",

              ),
              SizedBox(height: 20,),

              FormInputField(
                textController: bioController,
                inputLabel: "Something About You",
                hintText: "Bio",
              ),

              SizedBox(height: 30,),

              submitBtn(),
            ],
          ),
        ),
      ),
    );
  }
}
