import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:site_buddy/features/auth/domain/models/user_model.dart';

abstract class UserRepository {
  Future<User?> getUser();
  Future<void> saveUser(User user);
}

class HiveUserRepository implements UserRepository {
  static const String _boxName = 'user_box';
  static const String _userKey = 'current_user';

  @override
  Future<User?> getUser() async {
    final box = await Hive.openBox(_boxName);
    final String? userJson = box.get(_userKey);
    if (userJson == null) return null;
    return User.fromJson(jsonDecode(userJson));
  }

  @override
  Future<void> saveUser(User user) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_userKey, jsonEncode(user.toJson()));
  }
}
