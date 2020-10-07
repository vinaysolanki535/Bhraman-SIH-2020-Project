import 'package:flutter/material.dart';


class MakeInput extends StatelessWidget {
  final dynamic label,obscureText,textController,inputType,iconPass,validator;
  MakeInput({ this.label ,this.obscureText=false, this.textController, this.inputType,this.iconPass,this.validator });
  @override
  Widget build(BuildContext context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 8.0,),
          Text(label,style: TextStyle(
              fontSize: 16.0,color: Colors.black87
          ),),
          SizedBox(height: 8.0,),
          TextFormField(
              validator: validator,
            controller: textController,
            style: TextStyle(
                fontSize: 19.0
            ),
            obscureText: obscureText,
            keyboardType: inputType,
            decoration: InputDecoration(
              suffixIcon: iconPass,
              contentPadding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 0.0),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black45),),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black45),
              ),
            ),
          ),
          SizedBox(height: 8.0,),
        ],
      );
    }
  }
