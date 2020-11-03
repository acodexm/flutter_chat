import 'package:flutter_chat/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('email validator', () {
    test('should return null when email is valid', () {
      final result = validateEmail('example@gmail.com');
      expect(result, null);
    });

    test('should return null when email is valid with whitespace', () {
      final result = validateEmail('  example@gmail.com  ');
      expect(result, null);
    });

    test('should return error message when email is missing @', () {
      final result = validateEmail('examplegmail.com');
      expect(result.runtimeType, String);
    });

    test('should return error message when email is missing @ prefix', () {
      final result = validateEmail('@gmail.com');
      expect(result.runtimeType, String);
    });
  });
  group('password validator', () {
    test('should return null when password is valid', () {
      final result = validatePassword('123456');
      expect(result, null);
    });

    test('should return error message when password contains whitespace', () {
      final result = validatePassword('123 56');
      expect(result.runtimeType, String);
    });

    test('should return error message when password is too short', () {
      final result = validatePassword('1234');
      expect(result.runtimeType, String);
    });
    test('should return null when confirm password is valid', () {
      final result = validateConfirmPassword('123456', '123456');
      expect(result, null);
    });
    test('should return error message when confirm password dont match password', () {
      final result = validateConfirmPassword('xxxxxx', '123456');
      expect(result.runtimeType, String);
    });
  });
}
