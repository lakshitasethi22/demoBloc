import 'package:flutter_test/flutter_test.dart';
import 'package:loginpage/ui/login.dart';

void main(){
  testWidgets('Display the list of emails ', (tester) async{
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginScreen(),
      ),
    );
  });
}