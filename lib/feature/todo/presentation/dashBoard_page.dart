import 'package:desktopme/core/configs/colors/app_colors.dart';
import 'package:desktopme/core/configs/routes/routes.dart';
import 'package:desktopme/core/enums/view_state.dart';
import 'package:desktopme/feature/auth/bloc/auth_bloc.dart';
import 'package:desktopme/feature/auth/bloc/bloc_event.dart' hide TabEvent;
import 'package:desktopme/feature/auth/bloc/bloc_state.dart';
import 'package:desktopme/feature/todo/bloc/todo_bloc.dart';
import 'package:desktopme/feature/todo/bloc/todo_event.dart';
import 'package:desktopme/feature/todo/bloc/todo_state.dart';  
import 'package:desktopme/feature/todo/presentation/widgets/add_dailog.dart';
import 'package:desktopme/feature/todo/presentation/widgets/booking_tab.dart';
import 'package:desktopme/feature/todo/presentation/widgets/card_component.dart'; 
import 'package:desktopme/shared/components/primary_button.dart';
import 'package:desktopme/shared/services/sessionManger/session_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';  

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
    checking();
  }

  checking() async {
    await SessionController().userDataModel.id.toString().isEmpty
        ? null
        : BlocProvider.of<TodoBloc>(context).add(TaskFetch());
  
    BlocProvider.of<TodoBloc>(context).add(TabEvent(selectedTab: 0)); 
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
          BlocConsumer<AuthBloc, AuthSate>(
            listener: (context, state) {
              if (state.apiStatus == StatusApp.Completed) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: AppColors.green,
                    content: Text('✅ User Logout successfully'),
                  ),
                );
                Navigator.pushReplacementNamed(context, AppNameRoutes.mainUi);
                 BlocProvider.of<AuthBloc>(context).emit(
                          state.copyWith(apiStatus: StatusApp.initializing),
                        );
              }else{
                 BlocProvider.of<AuthBloc>(context).emit(
                          state.copyWith(apiStatus: StatusApp.initializing),
                        );
              }
            },
            builder: (builder, state) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: PrimaryButton(
                  onTap: state.apiStatus == StatusApp.Loading
                      ? () {
                          print('object');
                        }
                      : () async {
                          BlocProvider.of<AuthBloc>(context).add(LogOutEvent());
                        },
                  childWidget: state.apiStatus == StatusApp.Loading
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
        child: BlocConsumer<TodoBloc,TodoState>(
          builder: (builder, state, ) {
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
                          selectedIndex: state.selectedTab!,
                          onTap: () async { 
                            BlocProvider.of<TodoBloc>(context).add(TabEvent(selectedTab: 0));
                              SessionController().userDataModel.id
                                      .toString()
                                    .isEmpty
                                 ? null
                                 : BlocProvider.of<TodoBloc>(context).add(TaskFetch());
                          },
                          title: 'All Task',
                        ),
                        SizedBox(width: 8),
                        BookingTabs(
                          index: 1,
                          selectedIndex: state.selectedTab!,
                          onTap: () {
                            BlocProvider.of<TodoBloc>(context).add(TabEvent(selectedTab: 1));
                          },
                          title: 'Active Task',
                        ),
                        SizedBox(width: 8),
                        BookingTabs(
                          index: 2,
                          selectedIndex: state.selectedTab!,
                          onTap: () {
                            BlocProvider.of<TodoBloc>(context).add(TabEvent(selectedTab: 2));
                          },
                          title: 'Complete Task',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  if (state.selectedTab == 0)
                    CardComponent(
                      todoList: state.todoList,
                      onReorder: (oldIndex, newIndex) {
                        if (newIndex > oldIndex) newIndex -= 1;
                        BlocProvider.of<TodoBloc>(
                          context,
                          listen: false,
                        ).add(ReorderTodoEvent(oldIndex: oldIndex, newIndex: newIndex, taskList: state.todoList));
                      },
                    ),
                  if (state.selectedTab == 1)
                    CardComponent(
                      todoList: state.todoList
                          .where((type) => type.status == 'Active')
                          .toList(),
                      onReorder: (oldIndex, newIndex) {
                        if (newIndex > oldIndex) newIndex -= 1;
                        BlocProvider.of<TodoBloc>(
                          context,
                          listen: false,
                        ).add(ReorderTodoEvent(oldIndex: oldIndex, newIndex: newIndex, taskList: state.todoList
                              .where((type) => type.status == 'Active')
                              .toList()));
                        
                      },
                    ),
                  if (state.selectedTab == 2)
                    CardComponent(
                      todoList: state.todoList
                          .where((type) => type.status == 'Completed')
                          .toList(),
                      onReorder: (oldIndex, newIndex) {
                        if (newIndex > oldIndex) newIndex -= 1;
                        
                         BlocProvider.of<TodoBloc>(
                          context,
                          listen: false,
                        ).add(ReorderTodoEvent(oldIndex: oldIndex, newIndex: newIndex, taskList: state.todoList
                              .where((type) => type.status == 'Completed')
                              .toList()));
                      },
                    ),
                ],
              ),
            );
          }, listener: (BuildContext context, TodoState state) {  },
        ),
      ),
    );
  }
}
