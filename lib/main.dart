import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import "package:universal_html/html.dart" as html;
import 'firebase_options.dart'; // تأكد من إضافة ملف Firebase options الخاص بك

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key}); // إضافة المُعامل key هنا

  @override
  MyAppState createState() => MyAppState(); // هنا استخدمنا _MyAppState بدلاً من State<MyApp>
}

class MyAppState extends State<MyApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    setupFirebaseMessaging();
  }

  void setupFirebaseMessaging() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print('Message data: ${message.data}');
    });

    await _retrieveToken();

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print("Token updated: $newToken");
      storeTokenSecurely(newToken);
    });

  }

  Future<void> _retrieveToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        print("Firebase Token: $token");
        await storeTokenSecurely(token);
      } else {
        print("Failed to retrieve token.");
      }
    } catch (e) {
      print("Error getting Firebase token: $e");
    }
  }

  Future<void> storeTokenSecurely(String token) async {
    try {
      html.window.localStorage['firebase_token'] = token;
    } catch (e) {
      print("Error storing token securely: $e");
    }
    // يمكنك أيضاً إرسال التوكن إلى السيرفر الخاص بك هنا إذا كان ذلك ضرورياً
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Messaging',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Firebase Messaging Example'),
        ),
        body: const Center(
          child: Text('Firebase Messaging Example'),
        ),
      ),
    );
  }
}
