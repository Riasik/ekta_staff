import 'dart:async';

import 'package:ekta/api/api.dart';
import 'package:ekta/model/db.dart';
import 'package:ekta/model/response.dart';
import 'package:ekta/model/user.dart';
import 'package:ekta/utilities/constants.dart';
import 'package:ekta/utilities/controller.dart';
import 'package:ekta/widgets/main_header.dart';
import 'package:ekta/widgets/time_in_work.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'login_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Future<List<User>> _userList;
  User _user;
  Timer _timer;
  int _timeInWork;

  void initState() {
    super.initState();
    updateUserList();
  }

  updateUserList() {
    setState(() {
      _userList = DB.db.getUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                DB.db.deleteAllUser();
                Navigator.pushNamed(context, '/login');
              })
        ],
      ),
      body: FutureBuilder(
          future: _userList,
          builder: (context, snapshot) {
            if (snapshot.data != null && snapshot.data.length > 0) {
              _user = snapshot.data[0];
              return _buildBody();
            } else {
              return LoginPage();
            }
          }),
      backgroundColor: Colors.grey.shade700,
    );
  }

  Widget _buildBody() {
    //print( _user.timeStart );
    return SafeArea(
        child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                _header(),
                SizedBox(height: 30),
                _buttonRow(),
                SizedBox(height: 50),
              ],
            )));
  }

  Row _header() {
    int hours, mins, seconds;
    TextStyle _hedStyle = TextStyle(fontSize: 15.0, color: Colors.white);
    TextStyle _timeStyle = TextStyle(fontSize: 30.0, color: Colors.white);
    if (_user.timeStart != null) {
      _timeInWork = _user.timeEnd != null
          ? _timeInWork = _user.timeEnd - _user.timeStart
          : (TimeController.currentTimeInSeconds() - _user.timeStart);
      hours = ((_timeInWork / 3600) % 24).toInt();
      mins = ((_timeInWork / 60) % 60).toInt();
      seconds = _timeInWork % 60;
      startTimer();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Text(
              'Начало',
              style: _hedStyle,
            ),
            Text(
              _user.timeStart != null
                  ? TimeController.getTime(_user.timeStart)
                  : '-- : --',
              style: _timeStyle,
            )
          ],
        ),
        Column(
          children: [
            Text(
              'На работе',
              style: _hedStyle,
            ),
            Text(
              _timeInWork != null ? '$hours : $mins : $seconds' : '-- : --',
              style: _timeStyle,
            )
          ],
        ),
        Column(
          children: [
            Text(
              'Конец',
              style: _hedStyle,
            ),
            Text(
              _user.timeEnd != null
                  ? TimeController.getTime(_user.timeEnd)
                  : '-- : --',
              style: _timeStyle,
            )
          ],
        ),
      ],
    );
  }

  RaisedButton _buttonRow() {
    String _btnText;
    Color _btnColor;
    if (_user.status == 1) {
      _btnText = 'Я на работе';
      _btnColor = Colors.blue;
    } else if (_user.status == 2) {
      _btnText = 'Иду с работы';
      _btnColor = Colors.green;
    } else if (_user.status == 3) {
      _btnText = 'Я на работе';
      _btnColor = Colors.blue;
    }
    return RaisedButton(
        child: _textMod(_btnText, 20.0, Colors.black54),
        color: _btnColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(color: Colors.grey)),
        onPressed: () {
          getLocation();
        });
  }

  Text _textMod(text, fontSize, color) {
    return Text(text, style: TextStyle(fontSize: fontSize, color: color));
  }

  void getLocation() async {
    var info = await Api().goToApi(userId: _user.userId.toString());
    if (info.success == true) {
      //  в локации
      // print('info.text: $info');
      updateUserData(_user.status);
    } else {
      // не в локации
      // print('$info');
      Fluttertoast.showToast(
          msg: "This is Toast messaget",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2
          //timeInSecForIos: 1
          );
    }
  }

  void updateUserData(int status) {
    if (status == 1) {
      _user.timeStart = TimeController.currentTimeInSeconds();
      _user.status = 2;
    } else if (status == 2) {
      _user.timeEnd = TimeController.currentTimeInSeconds();
      _user.status = 3;
    } else if (status == 3) {
      _user.timeEnd = null;
      _user.status = 2;
    }
    DB.db.updateUser(_user);
    setState(() {});
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 2);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_user.timeEnd != null) {
            timer.cancel();
          } else {
            _timeInWork = _timeInWork + 1;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
