import 'dart:convert';


class User {
  int id, userId, date, timeStart, timeEnd, status;
  String ref;

  User({this.id, this.userId, this.date, this.timeStart, this.timeEnd, this.ref, this.status});

  User.fromMap(Map<String, dynamic> map) {
    id = map['id'] as int;
    userId = map['userId'] as int;
    ref = map['ref'];
    date = map["date"] as int;
    timeStart = map["timeStart"] as int;
    timeEnd = map["timeEnd"] as int;
    status = map["status"] as int;
  }
  Map<String, dynamic> toMap() => {
    "id": id,
    "userId": userId,
    "date": date,
    "status": status,
    "timeStart": timeStart,
    "timeEnd": timeEnd,
    "ref": ref,
  };

  Map<String, dynamic> toMapI() {
    final map = Map<String, dynamic>();
    map['id'] = id;
    map['status'] = status;
    map['userId'] = userId;
    map['ref'] = ref;
    map['date'] = date;
    return map;
  }
}

