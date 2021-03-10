class Response {
  bool success;
  String ref;

  Response({this.success, this.ref});

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        success: json['success'] as bool,
        ref: json['ref'] as String
    );
  }

class ResponseUser {
  bool success;
  int userId;

  ResponseUser({this.success, this.userId});

  factory ResponseUser.fromJson(Map<String, dynamic> json) {
    return ResponseUser(
        success: json['success'] as bool,
        userId: json['user_id'] as int
    );
  }
}
class ResponseTabel {
  bool success;
  String text;

  ResponseTabel({this.success, this.text});

  factory ResponseTabel.fromJson(Map<String, dynamic> json) {
    return ResponseTabel(
        success: json['success'] as bool,
        text: json['text'] as String,
    );
  }
}
