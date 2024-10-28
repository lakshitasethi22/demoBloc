part of 'login_bloc.dart';

enum LoginStatus { initial, loading, success, error }

class LoginState extends Equatable {
  final String email;
  final String password;
  final bool isEmailValid;
  final bool isPasswordValid;
  final LoginStatus loginStatus;
  final String message;
  final List<dynamic> userData;

  LoginState({
    this.email = '',
    this.password = '',
    this.isEmailValid = true,
    this.isPasswordValid = true,
    this.loginStatus = LoginStatus.initial,
    this.message = '',
    this.userData = const [],
  });

  LoginState copyWith({
    String? email,
    String? password,
    bool? isEmailValid,
    bool? isPasswordValid,
    LoginStatus? loginStatus,
    String? message,
    List<dynamic>? userData,
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
  List<Object> get props => [
    email,
    password,
    isEmailValid,
    isPasswordValid,
    loginStatus,
    message,
    userData,
  ];
}
