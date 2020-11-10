import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

import 'routes.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  final String title = 'Awesome Notifications Basic Demo';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _firebaseAppToken = '';
  bool _notificationsAllowed = false;
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {

    // Here you ensure to request the user permission, but do not do so
    // directly. Ask the user permission before in a personalized pop up dialog
    // this is more friendly to the user
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      _notificationsAllowed = isAllowed;
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    // Here you get the token every time its changed by firebase process or by a new installation
    AwesomeNotifications().fcmTokenStream.listen((String newFcmToken) {
      print("New FCM token: "+newFcmToken);
    });

    AwesomeNotifications().createdStream.listen((ReceivedNotification notification) {
      print("Notification created: "+(notification.title ?? notification.body ?? notification.id.toString()));
    });

    AwesomeNotifications().displayedStream.listen((ReceivedNotification notification) {
      print("Notification displayed: "+(notification.title ?? notification.body ?? notification.id.toString()));
    });

    AwesomeNotifications().dismissedStream.listen((ReceivedAction dismissedAction) {
      print("Notification dismissed: "+(dismissedAction.title ?? dismissedAction.body ?? dismissedAction.id.toString()));
    });

    AwesomeNotifications().actionStream.listen((ReceivedAction action){
      print("Action received!");

      // Avoid to open the notification details page twice
      Navigator.pushNamedAndRemoveUntil(
          context,
          PAGE_NOTIFICATION_DETAILS,
          (route) => (route.settings.name != PAGE_NOTIFICATION_DETAILS) || route.isFirst,
          arguments: action
      );

    });

    initializeFirebaseService();

    super.initState();
  }

  Future<void> initializeFirebaseService() async {
    String firebaseAppToken;
    bool isFirebaseAvailable;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      isFirebaseAvailable = await AwesomeNotifications().isFirebaseAvailable;

      if(isFirebaseAvailable){
        try {
          firebaseAppToken = await AwesomeNotifications().firebaseAppToken;
          debugPrint('Firebase token: $firebaseAppToken');
        } on Exception {
          firebaseAppToken = 'failed';
          debugPrint('Firebase failed to get token');
        }
      }
      else {
        firebaseAppToken = 'unavailable';
        debugPrint('Firebase is not available on this project');
      }

    } on Exception {
      isFirebaseAvailable = false;
      firebaseAppToken = 'Firebase is not available on this project';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted){
      _firebaseAppToken = firebaseAppToken;
      return;
    }

    setState(() {
      _firebaseAppToken = firebaseAppToken;
    });
  }

  Future<void> requestUserPermission() async {
    showDialog(
        context: context,
        builder: (_) =>
            NetworkGiffyDialog(
              buttonOkText: Text('Allow', style: TextStyle(color: Colors.white)),
              buttonCancelText: Text('Later', style: TextStyle(color: Colors.white)),
              buttonCancelColor: Colors.grey,
              buttonOkColor: Colors.deepPurple,
              buttonRadius: 0.0,
              image: Image.asset("assets/images/animated-bell.gif", fit: BoxFit.cover),
              title: Text('Get Notified!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600)
              ),
              description: Text('Allow Awesome Notifications to send to you beautiful notifications!',
                textAlign: TextAlign.center,
              ),
              entryAnimation: EntryAnimation.DEFAULT,
              onCancelButtonPressed: () async {
                Navigator.of(context).pop();
                _notificationsAllowed = await AwesomeNotifications().isNotificationAllowed();
                setState(() {
                  _notificationsAllowed = _notificationsAllowed;
                });
              },
              onOkButtonPressed: () async {
                Navigator.of(context).pop();
                await AwesomeNotifications().requestPermissionToSendNotifications();
                _notificationsAllowed = await AwesomeNotifications().isNotificationAllowed();
                setState(() {
                  _notificationsAllowed = _notificationsAllowed;
                });
              },
            )
    );
  }

  void sendNotification() async {

    if(!_notificationsAllowed){
      await requestUserPermission();
    }

    if(!_notificationsAllowed){
      return;
    }

    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 100,
            channelKey: "basic_channel",
            title: "Huston! The eagle has landed!",
            body: "A small step for a man, but a giant leap to Flutter's community!",
            notificationLayout: NotificationLayout.BigPicture,
            largeIcon: "https://avidabloga.files.wordpress.com/2012/08/emmemc3b3riadeneilarmstrong3.jpg",
            bigPicture: "https://www.dw.com/image/49519617_303.jpg",
            showWhen: true,
            autoCancel: true,
            payload: {
              "secret": "Awesome Notifications Rocks!"
            }
        )
    );

  }

  void sendLocalImageNotification() async {

    if(!_notificationsAllowed){
      await requestUserPermission();
    }

    if(!_notificationsAllowed){
      return;
    }

    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 101,
            channelKey: "basic_channel",
            title: "Best Places To Go On A Hot Air Balloon!",
            notificationLayout: NotificationLayout.BigPicture,
            body: "Check out the best places to go on a hot Air Balloon!",
            bigPicture: "asset://assets/images/balloons-in-sky.jpg",
            showWhen: true,
            autoCancel: true,
            payload: {
              "secret": "Awesome Notifications Rocks!"
            }
        )
    );

  }

  void cancelAllNotifications(){
    AwesomeNotifications().cancelAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10),
            shrinkWrap: true,
            children: <Widget>[
              RaisedButton(
                  onPressed: () => requestUserPermission(),
                  child: Text('Request User Permission')
              ),
              SizedBox( height: 20),
              RaisedButton(
                  onPressed: () => sendNotification(),
                  child: Text('Send a local notification')
              ),
              RaisedButton(
                  onPressed: () => sendLocalImageNotification(),
                  child: Text('Send a local notification with local files')
              ),
              SizedBox( height: 20),
              RaisedButton(
                  color: Colors.red,
                  textColor: Colors.white,
                  onPressed: () => cancelAllNotifications(),
                  child: Text('Cancel all notifications')
              ),
            ]
          ),
        )
    );
  }
}
