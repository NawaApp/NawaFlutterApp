import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart'; // استيراد ملف firebase_options.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Example',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Firebase Example'),
        ),
        body: const Center(
          child: Text(
            'Firebase App Initialized!',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
