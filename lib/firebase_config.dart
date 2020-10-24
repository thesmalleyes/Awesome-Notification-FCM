import 'dart:io';

import 'package:awesome_notification_example_fcm/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class FirebaseConfig{
  showHeadsUp(Map<String, dynamic> message){
    var data = message['data'] ?? message['notification'];
    String method = data==null? '' : data['method'];
    String title;
    String body;
    bool isCleverTap = false;
    String payload;
    if(Platform.isIOS){
      title = message['title']??message['aps']['alert']['title'];
      body = message['body']??message['aps']['alert']['body'];
      if(message['screen']!=null || message['wzrk_dl']!=null){
        isCleverTap = true;
        payload = '${message['screen']}||${message['id']??'0'}||${message['wzrk_dl']??''}';
      }
    } else {
      title = data['nt']??data['title'];
      body = data['nm']??data['body'];
      if(data['nt']!=null){
        isCleverTap = true;
        payload = '${data['screen']}||${data['id']??'0'}||${message['data']['wzrk_dl']??''}||${message['data']['wzrk_pid']??''}';
      }
    }
  }
  
  Future<void> handleBox() async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    final token = await _firebaseMessaging.getToken();
    print(token);
    _firebaseMessaging.configure(
      onBackgroundMessage: Platform.isIOS
        ? null
        : myBackgroundMessageHandler,
      onMessage: (Map<String, dynamic> message) async {
        if(Platform.isIOS){
          print("IOS : $message");
        } else {
          print("Android : $message");
        }
      },
      onResume: (Map<String, dynamic> message) async {
        print(message.toString());
      },
      onLaunch: (Map<String, dynamic> message) async {
        print(message.toString());
      },
    );
    _firebaseMessaging.requestNotificationPermissions(const IosNotificationSettings(sound: true, badge: true, alert: true));
      _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
        debugPrint("Settings registered: $settings");
      });
  } 
}