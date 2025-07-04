import 'package:desktopme/feature/auth/domain/user_model.dart';
import 'package:desktopme/shared/services/database_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
  import 'package:synchronized/synchronized.dart';

class LocalAuthDataSource {
  DatabaseServices databaseServices = DatabaseServices();
 Future<UserInsertResult> insertUser(UserModel user) async {
  try {
    final exists = await userExists(user.email ?? '');
    if (exists) {
      print(" User already registered with this email.");
      return UserInsertResult(success: false, user: null);
    }

    final db = await databaseServices.database;
    final id = await db.insert(
      'Users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );

    print(" User inserted into SQLite with id $id");

    // Return the inserted user (with id)
    final insertedUser = UserModel(
      id: id,
      email: user.email,
      password: user.password,
    );

    return UserInsertResult(success: true, user: insertedUser);
  } catch (e) {
    print(" Error inserting user: $e");
    return UserInsertResult(success: false, user: null);
  }
}

  Future<bool> userExists(String email) async {


    final db = await databaseServices.database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }


Future<UserModel?> signInnUser(String email, String password) async {
  try {
    final db = await databaseServices.database;

    final result = await db.query(
      'Users',
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
