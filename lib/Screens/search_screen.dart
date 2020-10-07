import 'package:bhrammanbeta/Screens/home_page.dart';
import 'package:bhrammanbeta/resource/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SearchScreen extends SearchDelegate<String> {



  bool isAvailable = false;
  bool isListening = false;




  
  final searchList;
  SearchScreen({this.searchList});
  
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
   return [
     IconButton(icon:Icon(Icons.clear,color: black,), onPressed: (){
       query = "";
     },)
   ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return
      IconButton(icon:Icon(Icons.arrow_back,color: black,), onPressed: (){Navigator.pop(context);},);

  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    final myList = query.isEmpty  ?  ["hello"] : searchList.where((q) => q.toString().startsWith(query.substring(0,1).toUpperCase() + query.substring(1,query.length))).toList();
    return ListView.builder(
        itemCount: myList.length,
        itemBuilder: (context, index) {
          return query.isEmpty ? Container()  :
          ListTile(onTap: (){
            Navigator.pushReplacement(context, MaterialPageRoute(
               builder: (context) => HomePage(city: myList[index],)
            ));
          },
              title: Text(myList[index]) );
        }
    );
  }

}
