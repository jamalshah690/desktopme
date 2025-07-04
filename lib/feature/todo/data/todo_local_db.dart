 
import 'package:desktopme/feature/todo/domain/todo_model.dart';
import 'package:desktopme/shared/services/database_service.dart';

class TodoLocalDataSource {
  DatabaseService databaseServices = DatabaseService();

  Future<void> createTodoTask({required TodoModel todo}) async {
    try {
      final db = await databaseServices.database;
      await db.insert('todos', todo.toMap());
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<void> updateTask({required TodoModel todo}) async {
    try {
      final db = await databaseServices.database;

      await db.update(
        'todos',
        todo.toMap(),
        where: 'id = ?',
        whereArgs: [todo.id],
      );
    } catch (e) {
      print(e.toString());
      return;
    }
  }

  Future<void> deleteTask({required String todoId}) async {
    try {
      final db = await databaseServices.database;
      await db.delete('todos', where: 'id = ? ', whereArgs: [todoId]);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<List<TodoModel>> getAllTask({required String userId}) async {
    try {
      final db = await databaseServices.database;
      final res = await db.query(
        'todos',
        where: 'userId = ?',
        whereArgs: [userId],
        orderBy: ' createdAt DESC',
      );

      return res.map((toElement) => TodoModel.fromMap(toElement)).toList();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
