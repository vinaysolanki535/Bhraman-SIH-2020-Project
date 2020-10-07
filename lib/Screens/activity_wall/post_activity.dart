import 'dart:io';

import 'package:bhrammanbeta/database/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostActivity extends StatefulWidget {
  final String hashTag,documentId;
  PostActivity({this.hashTag,this.documentId});

  @override
  _PostActivityState createState() => _PostActivityState();
}

class _PostActivityState extends State<PostActivity> {


  final descriptionController = TextEditingController();
  File file;
  bool warningImage;
  bool warningText;


  checkWarning() {
    if(file == null)  {
      setState(() {
        warningImage = true;
      });
    }
    else{
      setState(() {
        warningImage = false;
      });
    }
    if(descriptionController.text.isEmpty) {
      warningText = true;

    }
    else{
      setState(() {
        warningText = false;
      });
    }

  }

  String profilePhoto, userName, userId;

  getUserDataFromLocal() async{
    await AuthService.getProfilePhotoSharedPref().then((value) {
      if(value!=null) {
        setState(() {
          profilePhoto = value;
        });
      }
    });
    await AuthService.getUserIdSharedPref().then((value) {
      if(value!=null){
        print(userId);
        setState(() {
          userId =  value;
        });

      }
      else{
        print("NBull");
      }
    });
    await AuthService.getUserNameSharePref().then((value){
      if(value!=null) {
        setState(() {
          userName = value;
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDataFromLocal();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         title: Text(widget.hashTag),
       ),

      floatingActionButton: FloatingActionButton.extended(
          onPressed: ()async{
            checkWarning();
            if(warningImage == false && warningText == false) {


              StorageUploadTask image = FirebaseStorage.instance.ref().child("Activity").
              child(userId).child(Timestamp.now().toString()).child("Image").putFile(file);

              final StorageTaskSnapshot imageDownloadUrl =
              (await image.onComplete);
              final String imageFile = await imageDownloadUrl.ref.getDownloadURL();


              await Firestore.instance.collection("ActivityPosts").document().setData({

                 "image" : imageFile,
                 "description" : descriptionController.text,
                 "timeStamp" : Timestamp.now(),
                 "userId" : userId,
                 "userName" : userName,
                 "profilePic" : profilePhoto,
                  "reported" : null,

              });

              Navigator.pop(context);


            }
          },
          label: Text("Submit HASHTAG",style: TextStyle(fontSize: 16),)
      ),
      
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: descriptionController,
              style: TextStyle(fontSize: 18),
              decoration: InputDecoration(
                hintText: "Enter a short Description"
              ),
            ),

            warningText == true ? Text("Field should not be empty",style: TextStyle(color: Colors.red),) : Container(),

           SizedBox(height: 10,),
            
           file != null ? Container(
             height: 300,
             width: 300,
             child: Image(image: FileImage(file),),
            ):Container(),

            warningText == true ? Text("Please Upload an Image",style: TextStyle(color: Colors.red),) : Container(),


            SizedBox(height: 10,),

            RaisedButton(
              color: file ==null ?  Colors.green  : Colors.red,
              onPressed: ()async {
                if(file==null) {
                  File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

                  setState(() {
                    file = File(imageFile.path);
                  });

                }
                else{
                  setState(() {
                    file = null;
                  });
                }
              },
              child: file==null ? Text("Upload Image",style: TextStyle(color: Colors.white),) :
              Text("Remove Image", style :  TextStyle(color: Colors.white)),
            ),

          ],
        ),
      ),

    );
  }
}
