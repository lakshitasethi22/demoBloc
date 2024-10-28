import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:loginpage/bloc/login/login_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/ui/UserDetailsScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginBloc _loginBloc;
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: BlocProvider(
        create: (_) => _loginBloc,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome',
                style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  return TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    focusNode: emailFocusNode,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: const TextStyle(color: Colors.white54),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white54),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    onChanged: (value) {
                      context.read<LoginBloc>().add(EmailChanged(email: value));
                    },
                    style: const TextStyle(color: Colors.white),
                  );
                },
              ),
              const SizedBox(height: 20),
              BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  return TextFormField(
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: const TextStyle(color: Colors.white54),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white54),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    onChanged: (value) {
                      context.read<LoginBloc>().add(PasswordChanged(password: value));
                    },
                    style: const TextStyle(color: Colors.white),
                  );
                },
              ),
              const SizedBox(height: 50),
              BlocListener<LoginBloc, LoginState>(
                listener: (context, state) async {
                  if (state.loginStatus == LoginStatus.success) {
                    try {
                      final userData = await fetchUserData(state.email); // Fetch specific user data based on email
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('isLoggedIn', true);
                      await prefs.setString('userData', jsonEncode(userData));

                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => UserDetailsScreen(userData: userData),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to load user data: $e')),
                      );
                    }
                  }
                },
                child: BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: () {
                        context.read<LoginBloc>().add(LoginApi());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                      ),
                      child: const Text('Login', style: TextStyle(fontSize: 24, color: Colors.white)),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  String get uri =>'https://reqres.in/api/users';
      Future<Map<String, dynamic>> fetchUserData(String email) async {
    final response = await http.get(Uri.parse('uri'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final users = data['data'] as List;


      final user = users.firstWhere((user) => user['email'] == email, orElse: () => null);

      if (user != null) {
        return user;
      } else {
        throw Exception('User not found');
      }
    } else {
      throw Exception('Failed to load user data');
    }
  }
}
