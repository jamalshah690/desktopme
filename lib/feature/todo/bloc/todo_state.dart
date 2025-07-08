import 'package:desktopme/core/enums/view_state.dart';
import 'package:desktopme/feature/todo/domain/todo_model.dart';
import 'package:equatable/equatable.dart';

class TodoState extends Equatable {
  TodoState({
    this.todo = null,
    this.selectedTab = 0,
    List<TodoModel>? todoList,
    this.apiStatus = StatusApp.initializing,
    this.selectedDropDownTab = 0,
    this.selectType = 'Active',
    this.id = 0,
    this.title = '',
    this.desPass = '',
  }) : todoList = todoList ?? [];
  final TodoModel? todo;
  final int? selectedTab;
  final StatusApp apiStatus;
  final List<TodoModel> todoList;
  int? selectedDropDownTab;
  String? selectType;
  int? id;
  String? title;
  String? desPass;
  TodoState copyWith({
    TodoModel? todo,
    String? title,
    String? desPass,
    int? selectedTab,
    List<TodoModel>? todoList,
    StatusApp? apiStatus,
    int? selectedDropDownTab,
    String? selectType,
    int? id,
  }) {
    return TodoState(
      title: title ?? this.title,
      desPass: desPass ?? this.desPass,
      todo: todo ?? this.todo,
      selectedTab: selectedTab ?? this.selectedTab,
      todoList: todoList ?? this.todoList,
      apiStatus: apiStatus ?? this.apiStatus,
      selectedDropDownTab: selectedDropDownTab ?? this.selectedDropDownTab,
      selectType: selectType ?? this.selectType,
      id:id?? this.id,
    );
  }

  @override
  List<Object?> get props => [
    todo,
    selectedTab,
    todoList,
    selectedDropDownTab,
    apiStatus,
    selectType,
    id,
    title,
    desPass
  ];
}
