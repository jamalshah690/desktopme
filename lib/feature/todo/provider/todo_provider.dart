import 'package:desktopme/feature/todo/data/todo_local_db.dart';
import 'package:desktopme/feature/todo/domain/todo_model.dart';
import 'package:desktopme/shared/services/logger_service.dart';
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
void reorderTasks(List<TodoModel> taskList, int oldIndex, int newIndex) {
    final task = taskList.removeAt(oldIndex);
    taskList.insert(newIndex, task);
    notifyListeners();
  }
  bool isAddLoading = false;

  Future<void> insertData({
    required TodoModel todo,
    required BuildContext context,
  }) async {
    try {
      isAddLoading = true;
      notifyListeners();
      int userId =await SessionController().userDataModel.id!;
      final dateNow = DateTime.now().toIso8601String();
      final todoModel = TodoModel(
        title: todo.title,
        description: todo.description,
        status: todo.status,
        createdAt: dateNow,
        updatedAt: dateNow,
        userId: userId,
      );
      await _todoLocalDataSource.createTodoTask(todo: todoModel).then((
        onValue,
      ) async {
        await getAllTask();
        isAddLoading = false;
        LoggerService.logger.i("Task added"); 

         Navigator.of(context).pop(true);
        notifyListeners();
      });
    } catch (e) {
      isAddLoading = false;
      notifyListeners();
      print(e.toString());

      LoggerService.logger.e("Failed to insert  data");
    }
  }

  Future<void> updateData({
    required TodoModel todo,
    required BuildContext context,
  }) async {
    try {
      isAddLoading = true;
      notifyListeners();
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
      print(
        todoModel.id.toString() +
            todoModel.userId.toString() +
            todoModel.createdAt.toString() +
            todoModel.description +
            todoModel.title +
            todoModel.updatedAt.toString(),
      );

      LoggerService.logger.i(
        todoModel.id.toString() +
            todoModel.userId.toString() +
            todoModel.createdAt.toString() +
            todoModel.description +
            todoModel.title +
            todoModel.updatedAt.toString(),
      );

      await _todoLocalDataSource.updateTask(todo: todoModel).then((
        onValue,
      ) async {
        await getAllTask(); LoggerService.logger.i("Task Updated");
        Navigator.of(context).pop();
        isAddLoading = false;
        notifyListeners();
      });
    } catch (e) {
      LoggerService.logger.e("Failed to update  data");

      isAddLoading = false;
      notifyListeners();
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
       LoggerService.logger.i("Task get");
    } catch (e) {
      print(e.toString());
      LoggerService.logger.e("Failed to getAllData  data");
    }
  }

  Future<void> deleteData({required String id}) async {
    try {
      isAddLoading = true;
      notifyListeners();
      await _todoLocalDataSource.deleteTask(todoId: id);
      isAddLoading = false;
      await getAllTask();
       LoggerService.logger.i("Task delete");
      notifyListeners();
    } catch (e) {
      isAddLoading = false;
      notifyListeners();
      print(e.toString());
      LoggerService.logger.e("Failed to delete  data");
    }
  }
}
