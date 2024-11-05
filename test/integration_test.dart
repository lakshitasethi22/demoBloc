import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:loginpage/ui/login.dart';
import 'package:loginpage/ui/UserDetailsScreen.dart';
import 'package:loginpage/main.dart' as app;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Initialize mock SharedPreferences before running tests
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('End to End Testing', () {
    testWidgets('Verify login screen with correct username and password', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), 'username');
      await tester.enterText(find.byType(TextFormField).at(1), 'password');
      await tester.tap(find.byType(ElevatedButton));
      print('ELEVATED BUTTON');
      await tester.pumpAndSettle();

      expect(find.byKey(Key('loginButton')), findsOneWidget);
    });
  });
}
