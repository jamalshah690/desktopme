// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:desktopme/feature/todo/domain/todo_model.dart';

abstract class TodoBaseEvent extends Equatable{
 @override
  List<Object?> get props => [];

}


class TabEvent extends TodoBaseEvent {
  TabEvent({required this.selectedTab});
  int selectedTab;

  @override
  List<Object?> get props => [selectedTab];

  
}

class TitleEvent extends TodoBaseEvent{
TitleEvent({required this.title});
 String title;
  @override
  // TODO: implement props
  List<Object?> get props => [title];

}
class DescriptionEvent extends TodoBaseEvent{
DescriptionEvent({required this.desPass});
 String desPass;
  @override
  // TODO: implement props
  List<Object?> get props => [desPass];

}

class SelectCategoyEvent extends TodoBaseEvent
{ SelectCategoyEvent({required this.selectedDropDownTab, required this.selectType});
    int selectedDropDownTab = 0;
    String selectType;

  @override 
  List<Object?> get props =>[selectedDropDownTab,selectType];
  
}


class AddTodoEvent extends TodoBaseEvent{
 
  @override 
  List<Object?> get props => [ ];
  
}

class UpadteTodoEvent extends TodoBaseEvent {
 int todoId;
  UpadteTodoEvent({
    required this.todoId,
  });
  @override 
  List<Object?> get props => [todoId ];
  
}

class DeleteTodoEvent extends TodoBaseEvent
{
  DeleteTodoEvent({required this.id});

  int id;
  @override 
  List<Object?> get props => [id];
  
}


class TaskFetch extends TodoBaseEvent {
  @override 
  List<Object?> get props => [];
}

class ReorderTodoEvent extends TodoBaseEvent {
  final int oldIndex;
  final int newIndex;
final List<TodoModel> taskList;
  ReorderTodoEvent({required this.oldIndex, required this.newIndex, required this.taskList});

  @override 
  List<Object?> get props => [oldIndex,newIndex,taskList];
}
