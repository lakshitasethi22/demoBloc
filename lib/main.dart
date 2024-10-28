import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/ui/UserDetailsScreen.dart';
import 'package:loginpage/ui/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bloc/login/login_bloc.dart'; // Import your LoginBloc

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  Map<String, dynamic>? userData; // Change to Map<String, dynamic>

  // Load user data if logged in
  if (isLoggedIn) {
    String? userDataString = prefs.getString('userData');
    if (userDataString != null) {
      userData = jsonDecode(userDataString); // Decode JSON to Map
    }
  }

  runApp(MyApp(isLoggedIn: isLoggedIn, userData: userData));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final Map<String, dynamic>? userData; // Change to Map<String, dynamic>?

  MyApp({required this.isLoggedIn, required this.userData});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocProvider(
        create: (context) => LoginBloc(), // Provide the LoginBloc
        child: isLoggedIn && userData != null // Check if userData is not null
            ? UserDetailsScreen(userData: userData!)
            : LoginScreen(),
      ),
    );
  }
}
