import 'dart:io';

import 'package:bhrammanbeta/Widgets/form_field.dart';
import 'package:bhrammanbeta/database/auth.dart';
import 'package:bhrammanbeta/database/firestore.dart';
import 'package:bhrammanbeta/resource/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ArtShopForm extends StatefulWidget {
  @override
  _ArtShopFormState createState() => _ArtShopFormState();
}

class _ArtShopFormState extends State<ArtShopForm> {


  final ownerController = TextEditingController();
  final shopController = TextEditingController();
  final addressController = TextEditingController();
  final contactNumberController = TextEditingController();
  final emailIdController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final famousItemController = TextEditingController();
  final gstIn = TextEditingController();
  final aadharNumber = TextEditingController();
  final licenseNumber = TextEditingController();


  final _formKey = GlobalKey<FormState>();

  DatabaseService databaseService = DatabaseService();

  bool clicked = false;

  initState(){
    super.initState();
    getUserId();
    getUserName();
  }

  bool warning  = false;

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

  File passportPhoto,shopPhoto;

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

          if(!_formKey.currentState.validate() || passportPhoto == null || shopPhoto==null) {

            setState(() {
              warning = true;
            });

          }
          else {
            setState(() {
              clicked = true;
            });

            StorageUploadTask uploadThumbnailImage = FirebaseStorage.instance.ref().child("ArtShop").
            child(userId).child(Timestamp.now().toString()).child("PassportPhoto").putFile(passportPhoto);

            final StorageTaskSnapshot imageDownloadUrl =
            (await uploadThumbnailImage.onComplete);
            final String passport = await imageDownloadUrl.ref.getDownloadURL();


            StorageUploadTask image = FirebaseStorage.instance.ref().child("ArtShop").
            child(userId).child(Timestamp.now().toString()).child("ShopPhoto").putFile(shopPhoto);

            final StorageTaskSnapshot imageDow =
            (await image.onComplete);
            final String shop = await imageDow.ref.getDownloadURL();


            databaseService.addShopToDatabase(state: stateController.text,
                shopAddress: addressController.text,passportPhoto: passport,
                type: "ArtShop", shopPhoto: shop, aadhaarNumber: aadharNumber.text,
                gstIn : gstIn.text, licenseNumber:  licenseNumber.text,
                famousThings: famousItemController.text,email: emailIdController.text,
                ownerName: ownerController.text,shopName: shopController.text,
                number: contactNumberController.text,city: cityController.text);

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
        title: Text("Add Art and Craft Shop"),
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
                    inputLabel: "Name of Owner*",
                    hintText: "Write Owner Name",
                    textController: ownerController,
                    validator: (value){
                      if(value.isEmpty){
                        return "Field should not be empty";
                      }
                      return null;
                    },

                  ),
                  SizedBox(height: 10,),
                  FormInputField(
                    inputLabel: "Shop Name*",
                    hintText: "Your Shop Name",
                    textController: shopController,
                    validator: (value){
                      if(value.isEmpty){
                        return "Field should not be empty";
                      }
                      return null;
                    },

                  ),
                  SizedBox(height: 10,),
                  FormInputField(
                    inputLabel: "Shop Address*",
                    hintText: "Your Shop Address",
                    textController: addressController,
                    validator: (value){
                      if(value.isEmpty){
                        return "Field should not be empty";
                      }
                      return null;
                    },

                  ),
                  SizedBox(height: 10,),
                  FormInputField(
                    inputLabel: "Contact Number*",
                    hintText: "Mobile Number",
                    textController: contactNumberController,
                    validator: (value){
                      if(value.isEmpty){
                        return "Field should not be empty";
                      }
                      return null;
                    },

                  ),

                  SizedBox(height: 10,),
                  FormInputField(
                    inputLabel: "Aadhar Number*",
                    hintText: "Aaadhar",
                    textController: aadharNumber,
                    validator: (value){
                      if(value.isEmpty){
                        return "Field should not be empty";
                      }
                      return null;
                    },

                  ),

                  SizedBox(height: 10,),
                  FormInputField(
                    inputLabel: "GST IN number*",
                    hintText: "GSTIN",
                    textController: gstIn,
                    validator: (value){
                      if(value.isEmpty){
                        return "Field should not be empty";
                      }
                      return null;
                    },

                  ),
                  SizedBox(height: 10,),
                  FormInputField(
                    inputLabel: "Shop License Number*",
                    hintText: "License Number",
                    textController: licenseNumber,
                    validator: (value){
                      if(value.isEmpty){
                        return "Field should not be empty";
                      }
                      return null;
                    },

                  ),



                  SizedBox(height: 10,),
                  FormInputField(
                    inputLabel: "Email Id*",
                    hintText: "Write Email Id",
                    textController: emailIdController,
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
                    hintText: "Write city name",
                    textController: cityController,
                    validator: (value){
                      if(value.isEmpty){
                        return "Field should not be empty";
                      }
                      return null;
                    },

                  ), FormInputField(
                    inputLabel: "State*",
                    hintText: "State name",
                    textController: stateController,
                    validator: (value){
                      if(value.isEmpty){
                        return "Field should not be empty";
                      }
                      return null;
                    },

                  ),
                  SizedBox(height: 10,),
                  FormInputField(
                    inputLabel: "Famous Items",
                    hintText: "eg : clay boxes, silk Sari , etc",
                    textController: famousItemController,
                    validator: (value){
                      if(value.isEmpty){
                        return "Field should not be empty";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10,),


                  Text(
                    "Add owners passport size photo*",
                    style: (
                        TextStyle(
                          color: black,
                          fontFamily: 'sf_pro_semi_bold',
                          fontSize: 20,
                        )
                    ),
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
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                              image:
                              passportPhoto != null ? FileImage(passportPhoto)
                                  :  AssetImage('assets/images/dummy.jpg'),
                            ),
                          ),

                          GestureDetector(
                            onTap: () async{
                              if(passportPhoto == null) {
                                final pickedFile = await
                                ImagePicker.pickImage(source: ImageSource.gallery,
                                    imageQuality: 100);

                                setState(() {
                                  passportPhoto = File(pickedFile.path);

                                });
                              }

                              else {
                                setState(() {
                                  passportPhoto = null;
                                });
                              }

                            },
                            child: Container(
                                width: 40,
                                height: 40,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: Colors.blue,
                                ),
                                margin: EdgeInsets.only(top: 100,left:220 ),
                                alignment: Alignment.center,
                                child:passportPhoto == null ?   Icon(
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

                  passportPhoto == null && warning == true ?
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Please Upload an Image",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ): Container(),

                  Text(
                    "Add photo of your shop*",
                    style: (
                        TextStyle(
                          color: black,
                          fontFamily: 'sf_pro_semi_bold',
                          fontSize: 20,
                        )
                    ),
                  ),

                  Container(
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            child: Image(
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                              image:
                              shopPhoto != null ? FileImage(shopPhoto)
                                  :  AssetImage('assets/images/dummy.jpg'),
                            ),
                          ),

                          GestureDetector(
                            onTap: () async{
                              if(shopPhoto == null) {
                                final pickedFile = await
                                ImagePicker.pickImage(source: ImageSource.gallery,
                                    imageQuality: 100);

                                setState(() {
                                  shopPhoto = File(pickedFile.path);

                                });
                              }

                              else {
                                setState(() {
                                  shopPhoto = null;
                                });
                              }

                            },
                            child: Container(
                                width: 40,
                                height: 40,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: Colors.blue,
                                ),
                                margin: EdgeInsets.only(top: 100,left:220 ),
                                alignment: Alignment.center,
                                child:shopPhoto == null ?   Icon(
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
                  shopPhoto == null && warning == true ?
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
