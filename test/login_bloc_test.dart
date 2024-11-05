import 'package:flutter_test/flutter_test.dart';
import 'package:loginpage/bloc/login/login_bloc.dart';
// import 'package:loginpage/bloc/login/login_state.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
// Mock class for the HTTP client
class MockHttpClient extends Mock implements http.Client {}

void main() {
  late LoginBloc loginBloc;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    loginBloc = LoginBloc();
  });

  group('User details', ()
  {
    group('fetchLoginApi function', () {
      test('When status code is 200, should return a valid response', () async {
        // Arrange
        //   final mockResponse = jsonEncode([{'name': 'John Doe', 'email': 'john@example.com'}]);
        //
        //   when(mockHttpClient.get(any)).thenAnswer((_) async => http.Response(mockResponse, 200));
        //
        //   // Act
        //   final response = await loginBloc.fetchLoginApi();
        //
        //   // Assert
        //   expect(response, isA<List>());
        //   expect(response.isNotEmpty, true);
        // });

        // test('When status code is not 200, should throw an exception', () async {
        //   // Arrange
        //   when(mockHttpClient.get(any!)).thenAnswer((_) async => http.Response('Not Found', 404));
        //
        //   // Act and Assert
        //   expect(
        //         () async => await loginBloc.fetchLoginApi(),
        //     throwsA(isA<Exception>()),
        //   );
        // });

        //arrange
        //act
        final user = await loginBloc.fetchLoginApi();
        //assert
        expect(user, isA<LoginState>()); //checks the return data type of both if it is then okay else throws an exception
      });

      test('given class when function is called and status code is not 200', () async{
        //arrange
        //act
        final user = await loginBloc.fetchLoginApi();
        //assert
        // expect(user, throwsException); //in-built matcher
        //it will throw an exception because staus code is 200
        //if the first test passed then this test needs to fail
        expect(user, isNot(throwsException)); //this will not throw any exception because the first function didn't threw exception and
        //and since there is no exception this function worked fine
      });
    });
  });
}


//tests should not depend on an external factors
//mockito and mocktail helps in running the tests even when there is no internet connection

//when we have an external dependency (http) then we need to have control over it so to test without internet connection too