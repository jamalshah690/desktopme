import 'package:desktopme/feature/todo/data/todo_local_db.dart';
import 'package:desktopme/feature/todo/domain/todo_model.dart';
import 'package:desktopme/shared/services/sessionManger/session_controller.dart';
import 'package:flutter/widgets.dart';

class TodoProvider extends ChangeNotifier {
  TodoLocalDataSource _todoLocalDataSource = TodoLocalDataSource();
  int selectedIndex = 0;
  updateIndex(index) {
    selectedIndex = index;
    notifyListeners();
  }

  int selectedDropDownTab = 0;
  updateDropDownIndex(index) {
    selectedDropDownTab = index;
    notifyListeners();
  }

  bool isAddLoading = false;

  Future<void> insertData({required TodoModel todo}) async {
    try {
      isAddLoading = true; notifyListeners();
      int userId = SessionController().userDataModel.id!;
      final dateNow = DateTime.now().toIso8601String();
      final todoModel = TodoModel(
        title: todo.title,
        description: todo.description,
        status: todo.status,
        createdAt: dateNow,
        updatedAt: dateNow,
        userId: userId,
      );
      await _todoLocalDataSource.createTodoTask(todo: todoModel);
      await getAllTask();
      isAddLoading = false; notifyListeners();
    } catch (e) {
      isAddLoading = false; notifyListeners();
      print(e.toString());
    }
  }

  Future<void> updateData({required TodoModel todo}) async {
    try {isAddLoading = true; notifyListeners();
      int userId = SessionController().userDataModel.id!;
      final dateNow = DateTime.now().toIso8601String();
      final todoModel = TodoModel(
        id: todo.id,
        title: todo.title,
        description: todo.description,
        status: todo.status,
        createdAt: dateNow,
        updatedAt: dateNow,
        userId: userId,
      );
      print(todoModel.id.toString()+todoModel.userId.toString()+todoModel.createdAt.toString()+todoModel.description+todoModel.title+todoModel.updatedAt.toString());
      await _todoLocalDataSource.updateTask(todo: todoModel);
       await getAllTask();
      isAddLoading = false; notifyListeners();
    } catch (e) {  
      isAddLoading = false; notifyListeners();
      print(e.toString());
    }
  }

  List<TodoModel> todoList = [];
  Future<void> getAllTask() async {
    try {
      final userId = SessionController().userDataModel.id;
      final result = await _todoLocalDataSource.getAllTask(
        userId: userId.toString(),
      );
      todoList.clear();

      todoList = result;
      print(todoList.length);
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deleteData({required String id}) async {
    try {
      isAddLoading = true;
      notifyListeners();
      await _todoLocalDataSource.deleteTask(todoId: id);
      isAddLoading = false;
     await getAllTask();
      notifyListeners();
    } catch (e) {
      isAddLoading = false;
      notifyListeners();
      print(e.toString());
    }
  }
}
