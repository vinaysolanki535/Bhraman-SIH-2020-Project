import 'dart:io';
import 'dart:async';

import 'file:///D:/FlutterProjects/bhramman_beta/bhramman_beta/lib/Screens/video/videos.dart';
import 'package:bhrammanbeta/Widgets/form_field.dart';
import 'package:bhrammanbeta/Widgets/videoList.dart';
import 'package:bhrammanbeta/database/auth.dart';
import 'package:bhrammanbeta/database/firestore.dart';
import 'package:bhrammanbeta/resource/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';




class VideoUploadForm extends StatefulWidget {
  @override
  _VideoUploadFormState createState() => _VideoUploadFormState();
}

class _VideoUploadFormState extends State<VideoUploadForm> {

  DatabaseService databaseService = DatabaseService();

  String dropDownVideoType = 'Select';
  String dropDownState= 'Select';

  final titleController = TextEditingController();
  final cityController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool clicked = false;

  File file,videoFile;

  bool warning = false;


  String userId,userName;

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


  Widget uploadButton() {
    if(clicked ==  false) {
      return MaterialButton(
        minWidth: double.infinity,
        color: Colors.blue,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(58.0),
        ),
        onPressed: () async{

          if(!_formKey.currentState.validate() || ( (dropDownVideoType == "Select") || (dropDownState == "Select") )  || file ==null || videoFile == null) {
            print(titleController.text);
            print(cityController.text);
            print(dropDownVideoType);
            setState(() {
              warning = true;
            });
          }
          else {
            setState(() {
              clicked = true;
              warning = false;
            });
            //
            StorageUploadTask uploadThumbnailImage = FirebaseStorage.instance.ref().child("Videos").child(userId).child(Timestamp.now().toString())
              .child("ThumbnailImage").putFile(file);

            final StorageTaskSnapshot imageDownloadUrl =
            (await uploadThumbnailImage.onComplete);
            final String thumbnailImageUrl = await imageDownloadUrl.ref.getDownloadURL();

            StorageUploadTask uploadTask = FirebaseStorage.instance.ref().child("Videos").child(userId).child(Timestamp.now().toString())
                .child("Videos").putFile(videoFile);


          final StorageTaskSnapshot videoDownloadUrl =
          (await uploadTask.onComplete);

            final String videoUrl = await videoDownloadUrl.ref.getDownloadURL();

            await databaseService.saveVideoToFirebase(userId: userId,thumbImageUrl: thumbnailImageUrl,
              videoUrl: videoUrl,city: cityController.text,state:dropDownState,
              videoTitle: titleController.text,userName: userName,type: dropDownVideoType).then((value) {


              showDoneDialog(context);

            });




          }

        },
        height: 50.0,
        child: Text("Upload Video", style: TextStyle(
          fontSize: 20.0,
          color: Colors.white,
          fontFamily: 'sf_pro_bold',
        ),),
      );
    }

    return CircularProgressIndicator();
  }



  showDoneDialog(BuildContext context) {
    return showDialog(context: context,builder: (context){

      return AlertDialog(
        content:  Container(
            height: MediaQuery.of(context).size.height*0.2,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: Container(
              child: Column(
                children: [
                  Container(
                    child: Text("Your video has been uploaded successfully",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                        fontFamily: 'sf_pro_bold',
                      ),
                    ),
                  ),

                  SizedBox(height: 20,),

                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(50)
                    ),
                    child: Icon(
                      Icons.done,color: Colors.white,
                    ),
                  )

                ],
              ),
            )
        ),
        actions: [
          MaterialButton(
            onPressed: (){
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text("Done" , style: TextStyle(color: black, fontFamily:'normal_font'),),
          )
        ],
      );

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         iconTheme: IconThemeData(
           color: Colors.white,
         ),
         backgroundColor: Colors.lightBlue,
         title: Text("Video Upload Form"),
       ),

      body: SingleChildScrollView(
        child: Container(
          
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [

                //Video Title
                FormInputField(

                  inputLabel: "Video Title*",
                  textController: titleController,
                  hintText: "Video Title",
                  validator: (value) {
                    if(value.isEmpty) {
                      return "Title should not be empty";
                    }
                    return null;
                  },
                ),
                //Video Title

                SizedBox(height: 20,),


                FormInputField(
                  inputLabel: "City",
                  textController: cityController,
                  hintText: "City*",
                  validator: (value) {
                    if(value.isEmpty) {
                      return "city should not be empty";
                    }
                    return null;
                  },


                ),
                SizedBox(height: 20,),


                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width:  MediaQuery.of(context).size.width,
                      child: Text(
                        'Video Type*',
                        style: TextStyle(
                            fontFamily: 'sf_pro_regular',
                            fontSize: 20,
                            color: black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),

                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: DropdownButton<String>(
                        value: dropDownVideoType,
                        icon: Icon(Icons.keyboard_arrow_down),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.blue),
                        underline: Container(
                          height: 1,
                          color: Colors.blue,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            dropDownVideoType = newValue;
                          });
                        },
                        items: <String>[
                          'Select',
                          'Experience',
                          'Monuments',
                          'Food',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(fontSize: 20),
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  ],
                ),
                //city drop down


                SizedBox(height: 20,),


                //state drop down
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        'State*',
                        style: TextStyle(
                            fontFamily: 'sf_pro_regular',
                            fontSize: 20,
                            color: black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),

                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: DropdownButton<String>(
                        value: dropDownState,
                        icon: Icon(Icons.keyboard_arrow_down),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.blue),
                        underline: Container(
                          height: 1,
                          color: Colors.blue,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            dropDownState = newValue;
                          });
                        },
                        items: <String>[
                          'Select',
                          'Madhya Pradesh',
                          'New Delhi',
                          'Rajasthan',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(fontSize: 20),
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  ],
                ),
                //state drop down
                SizedBox(height: 20,),

                Container(
                  child: Text(
                    "Upload Video*",
                    style: TextStyle(
                        fontFamily: 'sf_pro_regular',
                        fontSize: 20,
                        color: black,
                        fontWeight: FontWeight.bold),
                  ),
                ),

                SizedBox(height: 10,),

                //video
                Container(
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        child:videoFile == null ? Image(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/images/upload_video_image.jpg'),
                        ) :

                         VideoList(
                           videoPlayerController: VideoPlayerController.file(videoFile),
                         )

                      ),

                      GestureDetector(
                        onTap: () async{
                          if(videoFile == null) {
                            final pickedFile = await FilePicker.getFile(type: FileType.video);

                            setState(() {
                              videoFile = File(pickedFile.path);

                            });
                          }

                          else {
                            setState(() {
                              videoFile = null;
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
                          margin: EdgeInsets.only(top: 150,left: 300),
                          alignment: Alignment.center,
                          child:videoFile == null ?   Icon(
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
                //video


                videoFile == null ?  Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Please Upload a Thumbnail Image",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ) : Container(),

                SizedBox(height: 20,),

                Container(
                  child: Text(
                    "Upload a thumbnail Image*",
                    style: TextStyle(
                        fontFamily: 'sf_pro_regular',
                        fontSize: 20,
                        color: black,
                        fontWeight: FontWeight.bold),
                  ),
                ),

                SizedBox(height: 10,),

                //Thumbnail Image
                Container(
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          child: Image(
                            fit: BoxFit.fill,
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
                //Thumbnail Image


                SizedBox(height: 10,),

                uploadButton(),

                //Warning Text
                SizedBox(height: 10,),
                warning == true ?
                    dropDownState == "Select" && dropDownVideoType != "Select" ?
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            "State is not selected",
                             style: TextStyle(
                               color: Colors.red,
                             ),
                          ),
                        ) :
                        dropDownVideoType == "Select"  && dropDownState != "Select"?
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            "Video Type is not selected",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ) :
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            "Video Type is not selected",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        )
                    : Container(),


                 SizedBox(height: 5,),

                 file == null && warning == true ?
                 Container(
                   alignment: Alignment.center,
                   child: Text(
                     "Please Upload a Thumbnail Image",
                     style: TextStyle(
                       color: Colors.red,
                     ),
                   ),
                 ): Container()
              //Warning Text

              ],
            ),
          ),
        ),
      ),


    );
  }


}

