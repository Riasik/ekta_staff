import 'package:ekta/model/db.dart';
import 'package:ekta/screens/login_screen.dart';
import 'package:ekta/screens/main_screen.dart';
import 'package:flutter/material.dart';

import 'model/user.dart';

void main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //final dbHelper = DB.db.;
  //Future<List<User>> _userList = DB.db.getUser();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

        initialRoute: '/login',
        // home: FutureBuilder(
        //   future: _userList,
        //   builder: (context, snapshot){
        //     if(snapshot.hasData){
        //       return MainScreen();
        //     }else{
        //       return LoginPage();
        //     }
        //   },
        // ),
        // home: FutureBuilder(
        //     future: dbHelper.getAllUser(),
        //     builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        //       if (snapshot.hasData){
        //         print(snapshot.data.userId);
        //         return MainScreen();
        //           //Center(child: CircularProgressIndicator());
        //       } else {
        //         return LoginPage();
        //           //Center(child: CircularProgressIndicator());
        //       }
        //     }),
        routes: {
          '/login': (context) => LoginPage(),
          // '/code': (context) => CodePage(),
          '/main': (context) => MainScreen(),
        });
  }
}
