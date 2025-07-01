// FILE: lib/main.dart (CORRECTED)
// =======================================================================
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // This is now required
import 'staff_list_page.dart';

void main() async {
  // Ensure that Flutter bindings are initialized before calling Firebase.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase using the generated options file.
  // This is the corrected line.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Staff Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const StaffListPage(),
    );
  }
}
