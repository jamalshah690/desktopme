import 'package:desktopme/core/configs/colors/app_colors.dart';
import 'package:desktopme/feature/auth/provider/auth_provider.dart';
import 'package:desktopme/feature/todo/presentation/widgets/add_dailog.dart';
import 'package:desktopme/feature/todo/presentation/widgets/booking_tab.dart';
import 'package:desktopme/feature/todo/presentation/widgets/card_component.dart';
import 'package:desktopme/feature/todo/provider/todo_provider.dart';
import 'package:desktopme/shared/components/primary_button.dart';
import 'package:desktopme/shared/services/sessionManger/session_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SessionController().userDataModel.id.toString().isEmpty?null: Provider.of<TodoProvider>(context, listen: false).getAllTask();
     Provider.of<TodoProvider>(context, listen: false).selectedIndex=0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        title: Text('Wecome Back ${SessionController().userDataModel.email}'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: PrimaryButton(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AddTaskDialog(
                    onSuccess: (msg) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(msg)));
                    },
                  ),
                );
                ;
              },
              childWidget: Text(
                'Add Task',
                style: TextStyle(fontSize: 11, color: AppColors.white),
              ),
              elevation: 0,
              gradient: const LinearGradient(
                colors: [AppColors.purple, AppColors.lightPurple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              height: 37,

              borderRadius: 100,
              bgColor: Colors.transparent,
            ),
          ),
          Consumer<AuthProvider>(
            builder: (builder, c, cd) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: PrimaryButton(
                  onTap: c.isLoading
                      ? () {
                          print('object');
                        }
                      : () async {
                          await Provider.of<AuthProvider>(
                            context,
                            listen: false,
                          ).logout(context);
                        },
                  childWidget: Consumer<AuthProvider>(
                    builder: (builder, val, child) {
                      return val.signUpStatus == true
                          ? Center(
                              child: CircularProgressIndicator.adaptive(
                                backgroundColor: AppColors.white,
                              ),
                            )
                          : Text(
                              'LogOut',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.white,
                              ),
                            );
                    },
                  ),
                  elevation: 0,
                  gradient: const LinearGradient(
                    colors: [AppColors.purple, AppColors.lightPurple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  height: 37,

                  borderRadius: 100,
                  bgColor: Colors.transparent,
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Consumer<TodoProvider>(
          builder: (builder, state, child) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.greyLight,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BookingTabs(
                          index: 0,
                          selectedIndex: state.selectedIndex,
                          onTap: () async{
                            state.updateIndex(0);
                           SessionController().userDataModel.id.toString().isEmpty?null: await state.getAllTask();
                          },
                          title: 'All Task',
                        ),
                        SizedBox(width: 8),
                        BookingTabs(
                          index: 1,
                          selectedIndex: state.selectedIndex,
                          onTap: () {
                            state.updateIndex(1);
                            
                          },
                          title: 'Active Task',
                        ),
                        SizedBox(width: 8),
                        BookingTabs(
                          index: 2,
                          selectedIndex: state.selectedIndex,
                          onTap: () {
                            state.updateIndex(2);
                          },
                          title: 'Complete Task',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  if (state.selectedIndex == 0)
                    CardComponent(todoList: state.todoList),
                  if (state.selectedIndex == 1)
                    CardComponent(
                      todoList: state.todoList
                          .where((type) => type.status == 'Active')
                          .toList(),
                    ),
                  if (state.selectedIndex == 2)
                    CardComponent(
                      todoList: state.todoList
                          .where((type) => type.status == 'Completed')
                          .toList(),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
