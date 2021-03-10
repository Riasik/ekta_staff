import 'dart:convert';

// User clientFromJson(String str) {
//   final jsonData = json.decode(str);
//   return User.fromMap(jsonData);
// }
//
// String clientToJson(User data) {
//   final dyn = data.toMap();
//   return json.encode(dyn);
// }

class User {
  int id, userId, date, timeStart;
  String ref;

  User({this.id, this.userId, this.date, this.timeStart, this.ref});

  // factory User.fromMap(Map<String, dynamic> json) => User(
  //     id: json["id"] as int,
  //     userId: json["user_id"] as int,
  //     date: json["date"] as int,
  //     timeStart: json["timeStart"] as int,
  //     ref: json["ref"] as String
  // );
  User.fromMap(Map<String, dynamic> map) {
    id = map['id'] as int;
    userId = map['userId'] as int;
    ref = map['ref'];
    date = map["date"] as int;
    timeStart = map["timeStart"] as int;
  }
  Map<String, dynamic> toMap() => {
    "id": id,
    "userId": userId,
    "date": date,
    "timeStart": timeStart,
    "ref": ref,
  };
  // Map<String, dynamic> toMapI() => {
  //   //"id": id,
  //   "user_id": userId,
  //   "date": date,
  //  // "timeStart": timeStart,
  //   "ref": ref
  // };
  Map<String, dynamic> toMapI() {
    final map = Map<String, dynamic>();
    map['id'] = id;
    map['userId'] = userId;
    map['ref'] = ref;
    map['date'] = date;
    return map;
  }
}
// class Student {
//   int id;
//   String name;
//
//   Student(this.id, this.name);
//
//   Map<String, dynamic> toMap() {
//     final map = Map<String, dynamic>();
//     map['id'] = id;
//     map['name'] = name;
//     return map;
//   }
//
//   Student.fromMap(Map<String, dynamic> map) {
//     id = map['id'];
//     name = map['name'];
//   }
// }
