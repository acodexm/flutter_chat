import 'package:faker/faker.dart';
import 'package:flutter_chat/utils/hash.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  List<String> chatUsers1;
  List<String> chatUsers2;
  List<String> ultraLongListOfUsers;
  List<String> chatUsers3;
  Faker faker;
  String salt1;
  String salt2;
  setUp(() {
    faker = Faker();
    chatUsers1 = ['adam', 'krzysio', 'bartus'];
    chatUsers2 = ['adam', 'bartus', 'krzysio'];
    chatUsers3 = ['adam2', 'bartus', 'krzysio'];
    salt1 = 'salt';
    salt2 = 'xDDDDD';
    ultraLongListOfUsers = [];
    for (var i = 0; i < 100; i++) {
      ultraLongListOfUsers.add(faker.lorem.sentence());
    }
  });

  group('common utils', () {
    test('should return same value', () {
      final result1 = getHash(chatUsers1, salt1);
      final result2 = getHash(chatUsers2, salt1);
      final result22 = getHash(chatUsers2, salt2);
      final result3 = getHash(chatUsers3, salt1);
      final ultraLongHash = getHash(ultraLongListOfUsers, salt1);
      print(result1);
      print(result2);
      print(result3);
      print(ultraLongHash);
      expect(result1, equals(result2));
      expect(result1, isNot(equals(result3)));
      expect(result1, isNot(equals(result22)));
    });
  });
}
