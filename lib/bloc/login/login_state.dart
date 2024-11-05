import 'dart:convert';
part of 'login_bloc.dart';

enum LoginStatus { initial, loading, success, error }

class LoginState extends Equatable {
  final String email;
  final String password;
  final bool isEmailValid;
  final bool isPasswordValid;
  final LoginStatus loginStatus;
  final String message;
  final List userData;

  LoginState({
    this.email = '',
    this.password = '',
    this.isEmailValid = false,
    this.isPasswordValid = false,
    this.loginStatus = LoginStatus.initial,
    this.message = '',
    this.userData = const [],
  });
  factory LoginState.fromJson(String source) {
    final data = json.decode(source);
    return LoginState(
      userData: data is List ? data : [],
      loginStatus: LoginStatus.success,
    );
  }
  Map<String,dynamic> toJson() {
    final result = <String, dynamic>{};

    result.addAll({'email': email});
    return result;
  }

  LoginState copyWith({
    String? email,
    String? password,
    bool? isEmailValid,
    bool? isPasswordValid,
    LoginStatus? loginStatus,
    String? message,
    List? userData,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      loginStatus: loginStatus ?? this.loginStatus,
      message: message ?? this.message,
      userData: userData ?? this.userData,
    );
  }

  @override
  List<Object> get props => [email, password, isEmailValid, isPasswordValid, loginStatus, message, userData];
}
