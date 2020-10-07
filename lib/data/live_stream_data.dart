import 'package:cloud_firestore/cloud_firestore.dart';

class LiveStreamData {
  String broadCastingId;
  String currentStatus;
  String placeName;
  String state;
  String userName;
  Timestamp timestamp;

  LiveStreamData({
      this.broadCastingId,
      this.currentStatus,
      this.placeName,
      this.state,
      this.userName,
      this.timestamp,
  });


}