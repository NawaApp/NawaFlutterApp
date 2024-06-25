import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nawa_flutter_app/firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // استيراد مكتبة flutter_dotenv

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // تحميل المتغيرات من ملف .env
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    setupFirebaseMessaging();
  }

  void setupFirebaseMessaging() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined or has not accepted permission');
    }

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
      // Storing token securely (for web this will use local storage)
      // html.window.localStorage['firebase_token'] = token;
    } catch (e) {
      print("Error storing token securely: $e");
    }
  }

  Future<void> _sendMessage() async {
    if (_controller.text.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _sendToChatGPT(_controller.text);

      setState(() {
        _messages.add({'user': _controller.text});
        _messages.add({'bot': response});
        _isLoading = false;
        _controller.clear();
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error: $e");
    }
  }
 
  Future<String> _sendToChatGPT(String message) async {
  final apiKey = dotenv.env['OPENAI_API_KEY']; // استخدام المتغير من .env

  if (apiKey == null) {
    throw Exception("API key not found in .env file");
  }

  const url = 'https://api.openai.com/v1/chat/completions';

  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $apiKey',
    },
    body: json.encode({
      'model': 'gpt-4o-2024-05-13',
      'messages': [
        {'role': 'user', 'content': message},
      ],
    }),
  );

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(utf8.decode(response.bodyBytes));
    return jsonResponse['choices'][0]['message']['content'].trim();
  } else {
    throw Exception('Failed to load response: ${response.body}');
  }
}


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'نوى',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.grey,
          brightness: Brightness.light,
        ),
        textTheme: TextTheme(
          titleLarge: GoogleFonts.tajawal(),
          bodyMedium: GoogleFonts.tajawal(),
          displaySmall: GoogleFonts.tajawal(),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('نوى في خدمتك كيف يمكنني مساعدتك'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isUserMessage = message.containsKey('user');
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    child: Align(
                      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: isUserMessage ? Colors.blue[100] : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          message[isUserMessage ? 'user' : 'bot']!,
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_isLoading) const CircularProgressIndicator(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'أكتب رسالتك',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
