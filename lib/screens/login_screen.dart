import 'package:ekta/Widgets/verticalText.dart';
import 'package:ekta/api/login_api.dart';
import 'package:ekta/model/db.dart';
import 'package:ekta/model/user.dart';
import 'package:ekta/screens/main_screen.dart';
import 'package:ekta/utilities/constants.dart';
import 'package:ekta/utilities/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  Future<List<User>> _userList;
  bool phoneIs = false;
  int _userId;
  String _inputPhone, _verificationCode, _ref;
  @override
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

      //Navigator.pushNamed(context, '/main');

      return
         FutureBuilder(
           future: _userList,
           builder: (context,snapshot){
             if(snapshot.data != null && snapshot.data.length > 0){
               return MainScreen();
             } else{
               return Scaffold(
                 body: Container(
                   decoration: BoxDecoration(
                     gradient: LinearGradient(
                         begin: Alignment.topRight,
                         end: Alignment.bottomLeft,
                         colors: [Colors.blueGrey, Colors.lightBlueAccent]),
                   ),
                   child: ListView(
                     children: <Widget>[
                       Column(
                         children: <Widget>[
                           Row(children: <Widget>[
                             VerticalText(),
                             _helpText(phoneIs == true
                                 ? 'Пожалуйста, укажите код'
                                 : 'Пожалуйста, укажите свой телефон')
                           ]),
                           SizedBox(height: 50.0,),
                           SafeArea(
                             child: Padding(
                                 padding: const EdgeInsets.all(20),
                                 child: phoneIs == true ?
                                 PinCodeFields(
                                   length: 4,
                                   animationDuration: const Duration(milliseconds: 200),
                                   animationCurve: Curves.easeInOut,
                                   switchInAnimationCurve: Curves.easeIn,
                                   switchOutAnimationCurve: Curves.easeOut,
                                   keyboardType: TextInputType.number,
                                   borderColor: Colors.white,
                                   textStyle: TextStyle(fontSize: 20.0),
                                   //animation: Animations.SlideInDown,
                                   onComplete: (output) {
                                     _verificationCode = output;
                                     print(output);
                                     sentCod();
                                   },
                                 )
                                     :
                                 IntlPhoneField(
                                     decoration: InputDecoration(
                                       //labelText: 'Phone Number',
                                       border: OutlineInputBorder(
                                         borderSide: BorderSide(),
                                       ),
                                     ),
                                     initialCountryCode: 'UA',
                                     maxLength: 9,
                                     onChanged: (phone) {
                                       if (phone.number.length == 9) {
                                         _inputPhone = phone.completeNumber;
                                         sentPhone();
                                         setState(() {
                                           phoneIs = true;
                                         });
                                       }
                                     })
                             ),
                           )
                           // _textField(),
                           // _flatButton('GO')
                         ],
                       )
                     ],
                   ),
                 ),
               );
             }
           },

         );}



  Widget _helpText (String helpText){
    return Padding(
      padding: const EdgeInsets.only(top: 30.0, left: 10.0),
      child: Container(
        //color: Colors.green,
        height: 200,
        width: 200,
        child: Column(
          children: <Widget>[
            Container(
              height: 60,
            ),
            Center(
              child: Text( helpText,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
   sentPhone () async{
    var info = await ApiLogin().login(input: _inputPhone);
    _ref = info.ref;
    print('FlatButton: ${info.ref}');
    //return info.ref;
  }
  sentCod () async{
    var info = await ApiLogin().cod(input: _verificationCode, ref: _ref);
    if(info.success == true){
      _userId = info.userId;
      print('user_id: $_userId');
      var con = await DB.db.insertUser(User(userId: _userId,ref: _ref, date: TimeController.currentTimeInSeconds(),status: 1));
      print(con.toString());
      Navigator.pushNamed(context, '/main');
    }else{
      setState(() {
        phoneIs = false;
        _inputPhone = '';
        _verificationCode = '';
        _ref = '';
        Fluttertoast.showToast(
            msg: "Incorrect Cod",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1
        );
      });
    }
  }
}
