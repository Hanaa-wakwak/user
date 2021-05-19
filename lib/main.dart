import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:grocery/services/auth.dart';
import 'package:grocery/services/database.dart';
import 'package:grocery/ui/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/theme_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  if (message.notification != null) {
    showNotification(message.notification.title, message.notification.body);
  }
  // Or do other work.
}

///initialize Flutter local notification plugin
FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

///Show notification
Future<void> showNotification(String title, String description) async {
  var android = new AndroidNotificationDetails(
    'channel id',
    'channel NAME',
    'CHANNEL DESCRIPTION',
    priority: Priority.high,
    importance: Importance.max,
    playSound: true,
  );
  var iOS = new IOSNotificationDetails();
  var platform = new NotificationDetails(android: android, iOS: iOS);
  await _flutterLocalNotificationsPlugin.show(0, title, description, platform);
}

class _MyAppState extends State<MyApp> {
  Future<ThemeData> initializeApp(BuildContext context) async {
    ///Initialize Firebase
    await Firebase.initializeApp();

    ///Initialize Firebase messaging
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    ///Request notifications permission
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    ///Show foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        showNotification(message.notification.title, message.notification.body);
      }
    });

    ///Show background notifications
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

    ///Check dark mode
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDark = false;
    if (prefs.containsKey('isDark')) {
      isDark = prefs.getBool('isDark');
    }

    return (isDark) ? ThemeModel.dark : ThemeModel.light;
  }

  @override
  void initState() {
    super.initState();

    ///Configure notifications: initialization for iOS and android
    _flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android =
        new AndroidInitializationSettings('@drawable/notification_logo');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android: android, iOS: iOS);
    _flutterLocalNotificationsPlugin.initialize(initSetttings);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ThemeData>(
      future: initializeApp(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return MultiProvider(
              providers: [
                Provider<AuthBase>(
                  create: (context) => Auth(),
                ),
                Provider<Database>(
                  create: (context) => FirestoreDatabase(),
                ),
              ],
              child: ChangeNotifierProvider<ThemeModel>(
                create: (context) => ThemeModel(theme: snapshot.data),
                child: Consumer<ThemeModel>(
                  builder: (context, themeModel, _) {
                    return MaterialApp(
                      debugShowCheckedModeBanner: false,
                      title: 'Grocery App',
                      theme: themeModel.theme,
                      home: SplashScreen(),
                    );
                  },
                ),
              ),
            );
          } else {
            return MaterialApp(
              home: Scaffold(
                body: Center(
                  child: Text(
                    snapshot.error.toString(),
                  ),
                ),
              ),
            );
          }
        }
        return MaterialApp(
          home: Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}
