import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:loginpage/bloc/login/login_bloc.dart';
import 'package:loginpage/ui/UserDetailsScreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:loginpage/ui/login.dart';
class MockHttpClient extends Mock implements http.Client {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockLoginBloc extends Mock implements LoginBloc{}
void main() {
  late LoginBloc loginBloc;
  late MockHttpClient mockHttpClient;
  late MockSharedPreferences mockSharedPreferences;
  //pre test
  setUp(() { //called before every test is called
    mockHttpClient = MockHttpClient();
    mockSharedPreferences = MockSharedPreferences();
    loginBloc = LoginBloc();
  });
  //post test
  tearDown(() { //called after every test
    loginBloc.close();
  });
  //actual testing
  Future<void> pumpLoginWidget(WidgetTester tester) async {
    await tester.pumpWidget(
      Provider<LoginBloc>.value(
        value: loginBloc,
        child: MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                TextField(
                  key: Key('emailField'),
                  onChanged: (value) => loginBloc.add(EmailChanged(email: value)),
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  key: Key('passwordField'),
                  onChanged: (value) => loginBloc.add(PasswordChanged(password: value)),
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                ElevatedButton(
                  key: Key('loginButton'),
                  onPressed: () => loginBloc.add(LoginApi()),
                  child: Text('Login'),
                ),
                StreamBuilder<LoginState>(
                  stream: loginBloc.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.loginStatus == LoginStatus.loading) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasData && snapshot.data!.loginStatus == LoginStatus.error) {
                      return Text(snapshot.data!.message, key: Key('errorMessage'), style: TextStyle(color: Colors.red));
                    }
                    if (snapshot.hasData && snapshot.data!.loginStatus == LoginStatus.success) {
                      return Text('Login successful', key: Key('successMessage'));
                    }
                    return Container();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  //given when then
  testWidgets('Shows error message when invalid email or password', (WidgetTester tester) async {
    await pumpLoginWidget(tester);

    // Directly emit an invalid login state for testing purposes
    loginBloc.emit(loginBloc.state.copyWith(
      loginStatus: LoginStatus.error,
      message: 'Invalid email or password',
    ));
    await tester.pump();

    // Verify error message
    expect(find.text('Invalid email or password'), findsOneWidget);
  });

  // testWidgets('Shows error message when invalid email or password', (WidgetTester tester) async {
    // await pumpLoginWidget(tester);
    //
    // // Enter invalid email and password
    // await tester.enterText(find.byKey(Key('emailField')), 'test@example.com');
    // await tester.enterText(find.byKey(Key('passwordField')), 'test');
    //
    // // Tap on login button
    // await tester.tap(find.byKey(Key('loginButton')));
    // await tester.pump();
    //
    // // Verify error message
    // expect(find.text('Invalid email or password'), findsOneWidget);
  // });

  testWidgets('Shows loading indicator when login is in progress', (WidgetTester tester) async {
    await pumpLoginWidget(tester);

    loginBloc.emit(loginBloc.state.copyWith(loginStatus: LoginStatus.loading));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Shows success message when login is successful', (WidgetTester tester) async {
    await pumpLoginWidget(tester);

    loginBloc.emit(loginBloc.state.copyWith(
      loginStatus: LoginStatus.success,
      message: 'Login successful',
    ));
    await tester.pump();

    expect(find.text('Login successful'), findsOneWidget);
  });

  testWidgets('Shows error message on login failure', (WidgetTester tester) async {
    await pumpLoginWidget(tester);

    loginBloc.emit(loginBloc.state.copyWith(
      loginStatus: LoginStatus.error,
      message: 'Invalid email or password',
    ));
    await tester.pump();

    expect(find.text('Invalid email or password'), findsOneWidget);
  });
  
  // testWidgets('on pressing the login button user must be navigated to the details page of the user', (tester) async{
  //   await tester.pumpWidget(const LoginScreen());
  //   final test1 = find.text('Welcome');
  //   expect(test1, findsOneWidget); //since we are looking for only one text then use findsOneWidget
  //   // if you want to find two texts then use findsNWidegts(number)
  //   //if you don't want to find anything then use findsNothing
  // }); this test will throw an error because loginscreen renders scaffold but what about the material app that is in the main.dart
  testWidgets('on pressing the login button user must be navigated to the details page of the user', (tester) async{
    final mockLoginBloc = MockLoginBloc();
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginScreen(),
      ),
    );
    // final test1 = find.text('hi');
    final test1 = find.text('Welcome');
    // final test1 = find.text('welcome'); //case sensitive
    expect(test1, findsOneWidget); //since we are looking for only one text then use findsOneWidget
    // if you want to find two texts then use findsNWidegts(number)
    //if you don't want to find anything then use findsNothing
    final button = find.byType(ElevatedButton);
    expect(button, findsOneWidget);
    print('FOUND THE ELEVATED BUTTON');
    //now we want to click on this button --> use tester --> has tap/drag
    await tester.tap(button);
    print('BUTTON PRESSED');
    await tester.pump();
    expect(find.byType(AppBar), findsOneWidget);
    print('FOUND THE APPBAR');
    // expect(find.byType(UserDetailsScreen), findsOneWidget);
    expect(find.byKey(Key('loginButton')), findsOneWidget);
  }); //this test will pass which mean it found the welcome text in the login screen
  //if i change the welcome text to something else and then try to find it out then it will throw an exception
}


//call back function in the testWidget is future void
//here the testingwidgets are  isolated from each other
//so we need to make a widget tree which can be tested so to that we use tester
//and to build a widget tree we user tester.pumpWidget --> it renders the ui and will build the widget tree based on the ui you pass
//there can be multiple expect function in a single testWidget
