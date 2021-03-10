import 'package:ekta/api/api.dart';
import 'package:ekta/model/db.dart';
import 'package:ekta/model/response.dart';
import 'package:ekta/model/user.dart';
import 'package:ekta/utilities/constants.dart';
import 'package:ekta/utilities/controller.dart';
import 'package:ekta/widgets/main_header.dart';
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
  bool workIn = false;
  User _user;
  //int timeStart, timeEnd, timeInWork,

  void initState() {
    // TODO: implement initState
    super.initState();
    updateUserList();
  }
  updateUserList(){
    setState(() {
      _userList = DB.db.getUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _userList,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.data != null && snapshot.data.length > 0) {
              _user = snapshot.data[0];

              print(_user.toString());
              print(_user.userId);
              print(_user.ref);
              print(_user.id);
              print(_user.date);
              return _buildBody();
            } else {
              //print('flutter ok');
              //Navigator.pushNamed(context, '/login');
              return LoginPage();
            }
          }),
      backgroundColor: Colors.grey.shade700,
    );
  }

  Widget _buildBody() {
    return SafeArea(
        child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                _header(),
                _buttonRow(),
                //HeaderMain(),
                SizedBox(height: 50)
              ],
            )));
  }

  Row _header() {
    TextStyle _hedStyle = TextStyle(fontSize: 15.0, color: Colors.white);
    TextStyle _timeStyle = TextStyle(fontSize: 30.0, color: Colors.white);
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
                  ? TimeController.getTime(_user.timeStart )
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
              _user.timeStart != null ? TimeController.currentTimeInSeconds() -  _user.timeStart : '-- : --',
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
              _user.timeStart != null ? _user.timeStart  : '-- : --',
              style: _timeStyle,
            )
          ],
        ),

      ],
    );
  }

  RaisedButton _buttonRow() {
    return RaisedButton(
        child: _textMod(
            workIn ? 'Иду с работы' : 'Я на работе', 20.0, Colors.black54),
        color: Colors.blue,
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
      print('info.text: $info');
      //_user.timeStart = TimeController.currentTimeInSeconds();
      DB.db.updateUser(_user);
      setState(() {});
    } else {
      print('$info');
      Fluttertoast.showToast(
          msg: "This is Toast messaget",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2
        //timeInSecForIos: 1
      );
    }
  }
}
