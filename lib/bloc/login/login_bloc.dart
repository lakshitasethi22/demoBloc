import 'package:loginpage/ui/UserDetailsScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<LoginApi>(_loginApi);
  }

  String get uri => 'https://reqres.in/api/login';
  Future<LoginState> fetchLoginApi() async {
    // Simulated API URL
    final url = Uri.parse(uri);
    final response = await http.get(url); // Replace with actual login API

    if (response.statusCode == 200) {
      // Simulating a successful response
      return LoginState.fromJson(response.body);
    } else {
      // Simulating an error response
      throw Exception('Failed to load user data');
    }
  }
  void _onEmailChanged(EmailChanged event, Emitter<LoginState> emit) {
    emit(
      state.copyWith(
        email: event.email,
        isEmailValid: _isValidEmail(event.email),
      ),
    );
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<LoginState> emit) {
    emit(
      state.copyWith(
        password: event.password,
        isPasswordValid: _isValidPassword(event.password),
      ),
    );
  }

  void _loginApi(LoginApi event, Emitter<LoginState> emit) async {
    if (!state.isEmailValid || !state.isPasswordValid) {
      emit(state.copyWith(
        loginStatus: LoginStatus.error,
        message: 'Invalid email or password',
      ));
      return;
    }

    emit(state.copyWith(loginStatus: LoginStatus.loading));

    Map<String, String> data = {
      'email': state.email,
      'password': state.password,
    };

    try {
      final response = await http.post(Uri.parse(uri), body: data);
      var responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Fetching user details after login success
        final detailsResponse = await http.get(Uri.parse(uri));
        var detailsData = jsonDecode(detailsResponse.body);

        if (detailsResponse.statusCode == 200 && detailsData['data'] != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('userData', jsonEncode(responseData['data']));
          emit(
            state.copyWith(
              loginStatus: LoginStatus.success,
              message: 'Login successful',
              userData: List.from(detailsData['data']),
            ),
          );
        } else {
          emit(state.copyWith(
            loginStatus: LoginStatus.error,
            message: 'Failed to load user details.',
          ));
        }
      } else {
        emit(state.copyWith(
          loginStatus: LoginStatus.error,
          message: responseData['error'] ?? 'Invalid credentials',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        loginStatus: LoginStatus.error,
        message: 'Network error: ${e.toString()}',
      ));
    }
  }

  bool _isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  bool _isValidPassword(String password) {
    return password.length >= 8;
  }
}
