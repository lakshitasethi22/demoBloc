// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:loginpage/bloc/login/login_bloc.dart';
// import 'package:loginpage/ui/login.dart';
// import 'package:loginpage/ui/UserDetailsScreen.dart';
// import 'package:http/http.dart' as http;
// import 'package:mockito/mockito.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// // Mock classes
// class MockLoginBloc extends Mock implements LoginBloc {}
//
// class MockHttpClient extends Mock implements http.Client {}
//
// void main() {
//   late LoginBloc loginBloc;
//
//   setUp(() {
//     loginBloc = MockLoginBloc();
//   });
//
//   group('LoginScreen', () {
//     testWidgets('renders LoginScreen and shows welcome message', (WidgetTester tester) async {
//       await tester.pumpWidget(
//         MaterialApp(
//           home: BlocProvider<LoginBloc>(
//             create: (context) => loginBloc,
//             child: LoginScreen(),
//           ),
//         ),
//       );
//
//       expect(find.text('Welcome'), findsOneWidget);
//       expect(find.byType(TextFormField), findsNWidgets(2)); // Email and Password fields
//       expect(find.text('Login'), findsOneWidget);
//     });
//
//     testWidgets('enters email and password', (WidgetTester tester) async {
//       await tester.pumpWidget(
//         MaterialApp(
//           home: BlocProvider<LoginBloc>(
//             create: (context) => loginBloc,
//             child: LoginScreen(),
//           ),
//         ),
//       );
//
//       await tester.enterText(find.byType(TextFormField).at(0), 'test@example.com'); // Email
//       await tester.enterText(find.byType(TextFormField).at(1), 'password123'); // Password
//
//       expect(find.text('test@example.com'), findsOneWidget);
//       expect(find.text('password123'), findsOneWidget);
//     });
//
//     testWidgets('presses login button', (WidgetTester tester) async {
//       when(loginBloc.state).thenReturn(LoginState.initial()); // This should now work.
//
//       await tester.pumpWidget(
//         MaterialApp(
//           home: BlocProvider<LoginBloc>(
//             create: (context) => loginBloc,
//             child: LoginScreen(),
//           ),
//         ),
//       );
//
//       await tester.tap(find.byKey(ValueKey('loginButton')));
//       await tester.pump();
//
//       verify(loginBloc.add(LoginApi())).called(1);
//     });
//
//     testWidgets('navigates to UserDetailsScreen on successful login', (WidgetTester tester) async {
//       when(loginBloc.state).thenReturn(LoginState.loginSuccess('test@example.com')); // This should now work.
//
//       await tester.pumpWidget(
//         MaterialApp(
//           home: BlocProvider<LoginBloc>(
//             create: (context) => loginBloc,
//             child: LoginScreen(),
//           ),
//         ),
//       );
//
//       await tester.tap(find.byKey(ValueKey('loginButton')));
//       await tester.pumpAndSettle();
//
//       expect(find.byType(UserDetailsScreen), findsOneWidget);
//     });
//
//   });
// }

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/ui/UserDetailsScreen.dart';
import 'package:loginpage/bloc/login/login_bloc.dart';
import 'package:loginpage/ui/login.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';

// Define the mock LoginBloc properly
class MockLoginBloc extends MockBloc<LoginEvent, LoginState> implements LoginBloc {}

void main() {
  testWidgets('Login page input fields for email and password', (WidgetTester tester) async {
    // Arrange: Create a LoginBloc instance
    final loginBloc = LoginBloc();

    // Act: Build the LoginPage widget
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: loginBloc,
          child: LoginScreen(),
        ),
      ),
    );

    // Assert: Check if the email and password input fields are present
    expect(find.byKey(Key('emailField')), findsOneWidget);
    expect(find.byKey(Key('passwordField')), findsOneWidget);

    // Assert: Check the initial state of the LoginBloc
    expect(loginBloc.state.loginStatus, LoginStatus.initial);
    expect(loginBloc.state.email, '');
    expect(loginBloc.state.password, '');
  });

  // testWidgets('presses login button', (WidgetTester tester) async {
  //   // Arrange
  //   final loginBloc = MockLoginBloc(); // Mock the LoginBloc
  //   whenListen(
  //     loginBloc,
  //     Stream.fromIterable([LoginState(loginStatus: LoginStatus.initial)]),
  //     initialState: LoginState(loginStatus: LoginStatus.initial),
  //   );
  //
  //   await tester.pumpWidget(
  //     MaterialApp(
  //       home: BlocProvider<LoginBloc>.value(
  //         value: loginBloc,
  //         child: LoginScreen(),
  //       ),
  //     ),
  //   );
  //
  //   // Act
  //   await tester.tap(find.byKey(Key('loginButton')));
  //   await tester.pump();
  //
  //   // Assert
  //   verify(() => loginBloc.add(LoginApi())).called(1);
  // });

  group('grouped tests', () {
    testWidgets('Login page input fields for email and password', (WidgetTester tester) async {
      // Arrange: Create a LoginBloc instance
      final loginBloc = LoginBloc();

      // Act: Build the LoginPage widget
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: loginBloc,
            child: LoginScreen(),
          ),
        ),
      );

      // Assert: Check if the email and password input fields are present
      expect(find.byKey(Key('emailField')), findsOneWidget);
      expect(find.byKey(Key('passwordField')), findsOneWidget);

      // Assert: Check the initial state of the LoginBloc
      expect(loginBloc.state.loginStatus, LoginStatus.initial);
      expect(loginBloc.state.email, '');
      expect(loginBloc.state.password, '');
    });

    testWidgets('enters email and password', (WidgetTester tester) async {
      final loginBloc = LoginBloc();

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<LoginBloc>(
            create: (context) => loginBloc,
            child: LoginScreen(),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField).at(0), 'test@example.com'); // Email
      await tester.enterText(find.byType(TextFormField).at(1), 'password123'); // Password

      expect(find.text('test@example.com'), findsOneWidget);
      expect(find.text('password123'), findsOneWidget);
    });
  });
}
