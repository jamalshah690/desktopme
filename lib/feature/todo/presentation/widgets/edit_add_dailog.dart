import 'package:desktopme/core/configs/colors/app_colors.dart';
import 'package:desktopme/core/enums/view_state.dart';
import 'package:desktopme/feature/todo/bloc/todo_bloc.dart';
import 'package:desktopme/feature/todo/bloc/todo_event.dart';
import 'package:desktopme/feature/todo/bloc/todo_state.dart'; 
import 'package:desktopme/feature/todo/domain/todo_model.dart'; 
import 'package:desktopme/shared/components/customfield_component.dart';
import 'package:desktopme/shared/components/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 
 
class EditTaskDialog extends StatefulWidget {
  final TodoModel todo;
  final Function(String message)? onSuccess;

  const EditTaskDialog({super.key, required this.todo, this.onSuccess});

  @override
  State<EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
   

  List<String> tabList = [ 'Active', 'Completed'];
 String status='Active';
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo.title);
    _descController = TextEditingController(text: widget.todo.description);
     BlocProvider.of<TodoBloc>(
                    context,
                  ).add(TitleEvent(title: widget.todo.title));
      BlocProvider.of<TodoBloc>(
                    context,
                  ).add(DescriptionEvent(desPass:widget.todo.description  ));
    status = widget.todo.status;
    print(widget.todo.id.toString()+' this is id');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TodoBloc,TodoState>(
      listener: (context, state) {
         if (state.apiStatus == StatusApp.Completed) {
      Navigator.of(context).pop(true); // ✅ Close dialog on success
  } 
      },
      child: AlertDialog(backgroundColor: AppColors.background,
        title: const Text('Edit Task'),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300 ),
          child: Form(
        key: _formKey,
        child: Column(mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 8),
            CustomFieldComponents(
              hint: 'enter a tile',
              controller: _titleController,
              validator: (v) {
                if (v!.isEmpty) {
                  return 'feild Must not be Empty';
                }
                return null;
              }, onChanged: (val) async{
                      print(val);
                   BlocProvider.of<TodoBloc>(
                    context,
                  ).add(TitleEvent(title: val));
                },
                onTapOutside: (p0) {
                  FocusManager.instance.primaryFocus!.unfocus();
                },
            ),
            SizedBox(height: 12),
            Text(
              'Description',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 8),
            CustomFieldComponents(
              hint: 'enter a Description',
              validator: (v) {
                if (v!.isEmpty) {
                  return 'feild Must not be Empty';
                }
                return null;
              },
              controller: _descController,
                onChanged: (val) {
                  BlocProvider.of<TodoBloc>(
                    context,
                  ).add(DescriptionEvent(desPass:val  ));
                },
                onTapOutside: (p0) {
                  FocusManager.instance.primaryFocus!.unfocus();
                },
            ), SizedBox(height: 12),
               Text(
                  'Select Categories',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                ),SizedBox(height: 8),  BlocBuilder<TodoBloc,TodoState>(
                    builder: (builder, state, ) {
                      return Container(
                        
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.greyLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: SizedBox(
                          height: 70,
                          width: 190,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: tabList.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, indexe) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                     
                                     
                                    status=tabList[indexe].toString();
                                     BlocProvider.of<TodoBloc>(
                    context,
                  ).add(SelectCategoyEvent(selectedDropDownTab: indexe, selectType: status ));
                                    print(status);
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 10),
                                    height: 45,
                                    padding: state.selectedDropDownTab == indexe
                                        ? EdgeInsets.symmetric(
                                            horizontal: indexe == 0 ? 6 : 18,
                                            vertical: indexe == 0 ? 3 : 6,
                                          )
                                        : null,
                                    decoration: BoxDecoration(
                                      color: state.selectedDropDownTab == indexe
                                          ? AppColors.white
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      tabList[indexe],
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight:
                                            state.selectedDropDownTab == indexe
                                            ? FontWeight.bold
                                            : FontWeight.w300,
                                        color: state.selectedDropDownTab == indexe
                                            ? AppColors.black
                                            : AppColors.black.withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
      
            SizedBox(height: 30),
      
            Center(
                    child: BlocBuilder<TodoBloc,TodoState>(
                      builder: (builder, val,) {
                        return PrimaryButton(
                          onTap: val.apiStatus==StatusApp.Loading
                              ? () {
                                  print('object');
                                }
                              : () async {
                                  if (_formKey.currentState!.validate()) {
        
                                        BlocProvider.of<TodoBloc>(context).add(UpadteTodoEvent(todoId: widget.todo.id!));
        
        
        
                                     
                                    
                                  }
                                },
                          childWidget:  val.apiStatus==StatusApp.Loading
                              ? Center(
                                  child: CircularProgressIndicator.adaptive(
                                    backgroundColor: AppColors.white,
                                  ),
                                )
                              : Text(
                                  'Update',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.white,
                                  ),
                                ),
                          elevation: 0,
                          gradient: const LinearGradient(
                            colors: [AppColors.purple, AppColors.lightPurple],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          height: 52,
                          width: 355,
                          borderRadius: 100,
                          bgColor: Colors.transparent,
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
        ),
      ),
    );
  }
}
