import 'package:desktopme/feature/auth/domain/user_model.dart';
import 'package:desktopme/shared/services/database_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:synchronized/synchronized.dart';

class LocalAuthDataSource {
  DatabaseService databaseServices = DatabaseService();
  Future<bool> insertUser({
    required String email,
    required String password,
  }) async {
    try {
      final db = await databaseServices.database;
      final result = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );
      if (result.isNotEmpty) {
        print(" User already registered with this email.");
        return false;
      } else {
        await db.insert('users', {
          'email': email,
          'password': password,
        }, conflictAlgorithm: ConflictAlgorithm.abort);
        return true;
      }
    } catch (e) {
      print(" Error inserting user: $e");
      return false;
    }
  }

  

  Future<UserModel?> signInnUser(String email, String password) async {
    try {
      final db = await databaseServices.database;

      final result = await db.query(
        'users',
        where: 'email = ? AND password = ?',
        whereArgs: [email, password],
      );

      print("Query Result: $result");

      if (result.isNotEmpty) {
        return UserModel.fromMap(result.first); //  just pass the first row
      } else {
        print(" No user found with these credentials.");
        return null;
      }
    } catch (e) {
      print(" Error fetching user: $e");
      return null;
    }
  }
}
