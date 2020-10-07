import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:panorama/panorama.dart';

class ThreeSixtyView extends StatefulWidget {
  final String imageUrl;
    final   dynamic imageSource;
  ThreeSixtyView({this.imageUrl,this.imageSource});

  @override
  _ThreeSixtyViewState createState() => _ThreeSixtyViewState();
}

class _ThreeSixtyViewState extends State<ThreeSixtyView> {

  File fileImage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.imageSource != null) {
      getImage();
    }
  }

  getImage() async{
    try{
      if(widget.imageSource == 'Gallery') {
        File file = await ImagePicker.pickImage(source: ImageSource.gallery);
        setState(() {
          fileImage = File(file.path);
        });
      }
    }
    catch(e){
      print("Please wait");
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         backgroundColor:Colors.white,
         centerTitle: true,
         title: Text("360 View", style: TextStyle(color: Colors.black,fontFamily: 'sf_pro_bold',fontSize: 24),),
         iconTheme: IconThemeData(
           color: Colors.black,
         ),

       ),

      body: Center(
        child:  Panorama(
                  zoom: 0,
                  child: Image(
                  image: widget.imageSource  == null && fileImage == null ?   NetworkImage(widget.imageUrl)
                    :FileImage(fileImage) ,
                  ),
         )

      ),

    );
  }
}
