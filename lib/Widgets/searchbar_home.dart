
import 'package:bhrammanbeta/resource/color.dart';
import 'package:flutter/material.dart';
import 'package:bhrammanbeta/Screens/search_screen.dart';

class SearchBarHome extends StatelessWidget {

  final List searchList;
  SearchBarHome({this.searchList});

  @override
  Widget build(BuildContext context) {
      return GestureDetector(
        onTap: (){
          showSearch(context: context, delegate: SearchScreen(searchList: searchList));
        },
        child: Container(
           padding: EdgeInsets.all(8),
           margin: EdgeInsets.only(left: 20,right: 20),
           height: 45,
           width: MediaQuery.of(context).size.width/1,
           decoration: BoxDecoration(
             borderRadius: BorderRadius.circular(10.0),
             color: white,
             boxShadow: [
               BoxShadow(
                 color: Colors.grey.withOpacity(0.5),
                 spreadRadius: 5,
                 blurRadius: 7,
                 offset: Offset(0, 3), // changes position of shadow
               ),
             ],
           ),

          child: Row(

            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Search City"),
              Icon(Icons.search),
            ],
          ),

        ),
      );

  }
}

