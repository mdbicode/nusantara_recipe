

import 'package:cloud_firestore/cloud_firestore.dart';

class FollowingModel{

final String userId;
final List<String> followId;
final Timestamp timestamp;

FollowingModel(
  this.userId,
  this.followId,
  this.timestamp
);

FollowingModel.fromJson(Map<String, dynamic> json)
      : userId = json['userId'] as String,
        followId = List<String>.from(json['followId'] as List),
        timestamp = json['timestamp'] as Timestamp;

Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'followId': followId,
      'timestamp': timestamp,
    };
  }
}