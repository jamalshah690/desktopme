import 'package:desktopme/core/configs/colors/app_colors.dart';
import 'package:desktopme/feature/auth/provider/auth_provider.dart';
import 'package:desktopme/feature/todo/provider/todo_provider.dart'; 
import 'package:desktopme/shared/components/customfield_component.dart';
import 'package:desktopme/shared/components/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
 
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
    return AlertDialog(
      
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
              child: Consumer<AuthProvider>(
                builder: (builder, val, cd) {
                  return PrimaryButton(
                    onTap: val.isLoading
                        ? () {
                            print('object');
                          }
                        : () async {
                         await   Provider.of<TodoProvider>(context, listen: false).deleteData(id: widget.id);
                            Navigator.of(context).pop();
                          },
                    childWidget: val.isLoading == true
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
    );
  }
}
