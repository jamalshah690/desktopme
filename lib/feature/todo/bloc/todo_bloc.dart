import 'package:desktopme/core/enums/view_state.dart';
import 'package:desktopme/feature/todo/bloc/todo_event.dart';
import 'package:desktopme/feature/todo/bloc/todo_state.dart';
import 'package:desktopme/feature/todo/data/todo_local_db.dart';
import 'package:desktopme/feature/todo/domain/todo_model.dart';
import 'package:desktopme/shared/services/logger_service.dart';
import 'package:desktopme/shared/services/sessionManger/session_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoBloc extends Bloc<TodoBaseEvent, TodoState> {
  TodoLocalDataSource _todoLocalDataSource = TodoLocalDataSource();
  TodoBloc() : super(TodoState(selectedTab: 0)) {
    on<TabEvent>(_updateTab);
    on<AddTodoEvent>(_insertData);
    on<UpadteTodoEvent>(_updateData);
    on<DeleteTodoEvent>(_delete);
    on<TaskFetch>(_fetchAllTask);
    on<SelectCategoyEvent>(updateDropDownIndex);
    on<TitleEvent>(_inputTitleEvent);
    on<DescriptionEvent>(_inputDescriptionEvent);
    on<ReorderTodoEvent>(_reorderTodoEvent);
  }

  _updateTab(TabEvent event, Emitter<TodoState> emit) {
    emit(state.copyWith(selectedTab: event.selectedTab));
  }

  updateDropDownIndex(SelectCategoyEvent event, Emitter<TodoState> emit) {
    emit(
      state.copyWith(
        selectedDropDownTab: event.selectedDropDownTab,
        selectType: event.selectType,
      ),
    );
  }

  _inputTitleEvent(TitleEvent event, Emitter<TodoState> emit) {
    emit(state.copyWith(title: event.title));
    print(state.title.toString() + " is typing");
  }

  _inputDescriptionEvent(DescriptionEvent event, Emitter<TodoState> emit) {
    emit(state.copyWith(desPass: event.desPass));
    print(state.desPass.toString() + " is typing");
  }

  _insertData(AddTodoEvent event, Emitter<TodoState> emit) async {
    try {
      emit(state.copyWith(apiStatus: StatusApp.Loading));
      int userId = await SessionController().userDataModel.id ?? 0;
      final dateNow = DateTime.now().toIso8601String();
      print(state.title);
      print(state.desPass);
      print(state.selectType);

      final todoModel = TodoModel(
        title: state.title!,
        description: state.desPass!,
        status: state.selectType!,
        createdAt: dateNow,
        updatedAt: dateNow,
        userId: userId,
      );
      await _todoLocalDataSource.createTodoTask(todo: todoModel).then((
        onValue,
      ) async {
        emit(state.copyWith(apiStatus: StatusApp.Completed));
         await Future.microtask(() => add(TaskFetch()));
        
        LoggerService.logger.i("Task added");
 emit(state.copyWith(apiStatus: StatusApp.initializing));
        //  Navigator.of(context).pop(true);
      });
    } catch (e) {emit(state.copyWith(apiStatus: StatusApp.Error)); emit(state.copyWith(apiStatus: StatusApp.initializing));
      print(e.toString());

      LoggerService.logger.e("Failed to insert  data");
    }
  }
 _updateData(UpadteTodoEvent event, Emitter<TodoState> emit) async {
    try {
      emit(state.copyWith(apiStatus: StatusApp.Loading,id: event.todoId));
      int userId = await SessionController().userDataModel.id ?? 0;
      final dateNow = DateTime.now().toIso8601String();
      print(state.title);
      print(state.desPass);
      print(state.selectType);
      print(state.id);

      final todoModel = TodoModel(
        title: state.title!,
        description: state.desPass!,
        status: state.selectType!,
        createdAt: dateNow,
        id: state.id,
        updatedAt: dateNow,
        userId: userId,
      );
      await _todoLocalDataSource.updateTask(todo: todoModel).then((
        onValue,
      ) async {
        emit(state.copyWith(apiStatus: StatusApp.Completed));
         await Future.microtask(() => add(TaskFetch()));
        
        LoggerService.logger.i("update task ");
 emit(state.copyWith(apiStatus: StatusApp.initializing));
        //  Navigator.of(context).pop(true);
      });
    } catch (e) {emit(state.copyWith(apiStatus: StatusApp.Error)); emit(state.copyWith(apiStatus: StatusApp.initializing));
      print(e.toString());

      LoggerService.logger.e("Failed to insert  data");
    }
  }

  _delete(DeleteTodoEvent event, Emitter<TodoState> emit) async {
    try {

      emit(state.copyWith(apiStatus: StatusApp.Loading,id: event.id));
     print(state.id);
     print('object');
      await _todoLocalDataSource.deleteTask(todoId: state.id.toString()!);
      emit(state.copyWith(apiStatus: StatusApp.Completed));
       await Future.microtask(() => add(TaskFetch()));
        
      LoggerService.logger.i("Task delete");
      emit(state.copyWith(apiStatus: StatusApp.initializing));
    } catch (e) {
      emit(state.copyWith(apiStatus: StatusApp.Error));
      emit(state.copyWith(apiStatus: StatusApp.initializing));
      print(e.toString());
      LoggerService.logger.e("Failed to delete  data");
    }
  }

  _fetchAllTask(TaskFetch event, Emitter<TodoState> emit) async {
    try {
      final userId = SessionController().userDataModel.id;
      final result = await _todoLocalDataSource.getAllTask(
        userId: userId.toString(),
      );
      state.todoList.clear();
      emit(state.copyWith(todoList: result));

      print(state.todoList.length);
      LoggerService.logger.i("Task get");
    } catch (e) {
      print(e.toString());
      LoggerService.logger.e("Failed to getAllData  data");
    }
  }
 
 _reorderTodoEvent(ReorderTodoEvent event,Emitter<TodoState> emit)async{
  emit(state.copyWith(todoList:event.taskList ));
   final updatedList = List<TodoModel>.from(state.todoList);
  final task = updatedList.removeAt(event.oldIndex);
  updatedList.insert(event.newIndex, task);
 }
 
 }
