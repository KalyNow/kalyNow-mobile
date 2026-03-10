import 'package:flutter_test/flutter_test.dart';
import 'package:kalynow_mobile/features/auth/domain/entities/user.dart';
import 'package:kalynow_mobile/features/auth/data/models/user_model.dart';

void main() {
  group('UserModel', () {
    const tUserModel = UserModel(
      id: 'user-1',
      email: 'test@example.com',
      name: 'Test User',
    );

    const tUserModelJson = {
      'id': 'user-1',
      'email': 'test@example.com',
      'name': 'Test User',
      'avatar_url': null,
      'phone_number': null,
    };

    test('should be a subtype of User', () {
      expect(tUserModel, isA<User>());
    });

    test('fromJson should return a valid UserModel', () {
      final result = UserModel.fromJson(tUserModelJson);
      expect(result.id, 'user-1');
      expect(result.email, 'test@example.com');
      expect(result.name, 'Test User');
      expect(result.avatarUrl, isNull);
    });

    test('toJson should return a valid map', () {
      final result = tUserModel.toJson();
      expect(result['id'], 'user-1');
      expect(result['email'], 'test@example.com');
      expect(result['name'], 'Test User');
    });

    test('fromEntity should create UserModel from User entity', () {
      const user = User(id: 'u1', email: 'a@b.com', name: 'Alice');
      final model = UserModel.fromEntity(user);
      expect(model.id, 'u1');
      expect(model.email, 'a@b.com');
      expect(model.name, 'Alice');
    });

    test('equality should work on value fields', () {
      const other = UserModel(
        id: 'user-1',
        email: 'test@example.com',
        name: 'Test User',
      );
      expect(tUserModel, equals(other));
    });
  });
}
