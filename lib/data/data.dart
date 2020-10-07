import 'package:cloud_firestore/cloud_firestore.dart';

class Data{
  String imageUrl;
  List images;
  String city;
  String location;
  String place;
  String shortdescription;
  String history;
  String about;
  String country;
  double rating;
  String culName;
  String imageUrlTwo;
  String cardName;
  String cardUrl;
  String entryFee;
  String culture;
  String festival;
  dynamic latitude;
  dynamic longitude;
  String descriptionHindi;
  String historyHindi;
  String aboutHindi;
  String typeOfThing;

  Data(
      {
        this.imageUrl,
        this.location,
        this.images,
        this.city,
        this.place,
        this.entryFee,
        this.shortdescription,
        this.country,
        this.rating,
        this.culture,
        this.festival,
        this.imageUrlTwo,
        this.cardName,
        this.cardUrl,
        this.about,
        this.history,
        this.typeOfThing,
        this.latitude,
        this.longitude,
        this.aboutHindi,
        this.descriptionHindi,
        this.historyHindi,
      }
    );
}

