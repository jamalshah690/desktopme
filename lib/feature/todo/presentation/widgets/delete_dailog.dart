import 'package:desktopme/core/configs/colors/app_colors.dart';
import 'package:desktopme/core/enums/view_state.dart';
import 'package:desktopme/feature/todo/bloc/todo_bloc.dart';
import 'package:desktopme/feature/todo/bloc/todo_event.dart';
import 'package:desktopme/feature/todo/bloc/todo_state.dart';  
import 'package:desktopme/shared/components/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 
 
class DeleteTaskDialog extends StatefulWidget {
  String  id; 
   
  final Function(String message)? onSuccess;

    DeleteTaskDialog({super.key, required this.id,  this.onSuccess});

  @override
  State<DeleteTaskDialog> createState() => _DeleteTaskDialogState();
}

class _DeleteTaskDialogState extends State<DeleteTaskDialog> {
   
   
  @override
  Widget build(BuildContext context) {
    return BlocListener<TodoBloc,TodoState>(
      listener: (context, state) {
         if (state.apiStatus == StatusApp.Completed) {
      Navigator.of(context).pop(true); // ✅ Close dialog on success
    } 
      },
      child: AlertDialog(
        
        backgroundColor: AppColors.background,
        title: Center(child: const Text('Delete the Current Task')),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300 ),
          child: Column(mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Are you Sure want to delete Task?',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
              
              SizedBox(height: 30),
          
              Center(
                child: BlocBuilder<TodoBloc,TodoState>(
                  builder: (builder, val, ) {
                    return PrimaryButton(
                      onTap: val.apiStatus==StatusApp.Loading
                          ? () {
                              print('object');
                            }
                          : () async { 
                            
                           BlocProvider.of<TodoBloc>(context).add(DeleteTodoEvent(id: int.parse(widget.id)));
                              
                            },
                      childWidget: val.apiStatus==StatusApp.Loading
                          ? Center(
                              child: CircularProgressIndicator.adaptive(
                                backgroundColor: AppColors.white,
                              ),
                            )
                          : Text(
                              'Delete',
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
    );
  }
}
