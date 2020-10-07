import 'package:bhrammanbeta/resource/color.dart';
import 'package:flutter/material.dart';

class FormInputField extends StatelessWidget {

  final dynamic inputLabel,textController,validator,hintText;
  FormInputField({ this.inputLabel,this.textController,this.validator,this.hintText });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              inputLabel,
              style: TextStyle(
                  fontFamily: 'sf_pro_semi_bold',
                  fontSize: 20,
                  color: black,
                  ),
            ),
          ),
          SizedBox(height: 1,),
          TextFormField(
            maxLines: 200,
            minLines: 1,
            validator: validator,
            controller: textController,
            style: TextStyle(
              fontSize: 20.0,
            ),
            textAlignVertical: TextAlignVertical.center,
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              hintText: hintText,
            ),
          ),
        ],
      ),
    );
  }
}
