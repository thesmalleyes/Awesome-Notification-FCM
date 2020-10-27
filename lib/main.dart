import 'dart:developer';

import 'package:awesome_notification_example_fcm/routes.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

import 'home_page.dart';


void initializeApp() async{
  AwesomeNotifications().initialize(
    null, // this makes you use your default icon, if you haven't one
    [
        NotificationChannel(
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Colors.blueAccent,
            ledColor: Colors.white
        )
    ]
  );
}

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Awesome Notification',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.deepPurple,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      // This will initialize the route system to use names defined inside "routes" file
      initialRoute: PAGE_HOME,
      routes: materialRoutes,

    );
  }
}
