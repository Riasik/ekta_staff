class TimeController{
  static bool isToday(int timestamp) {
    var now = new DateTime.now().day;
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000).day;
    var time = true;
    print('diff.inDays: $now, $date');
    if (now == date) {
      time = false;
    }
    return time;
  }
  static String getTime(int timestamp){
    return '${new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000).hour} : ${new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000).minute}';
  }
  static int currentTimeInSeconds() {
    var ms = (new DateTime.now()).millisecondsSinceEpoch;
    return (ms / 1000).round();
  }
}