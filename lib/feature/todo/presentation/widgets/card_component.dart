import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'package:desktopme/core/configs/colors/app_colors.dart';
import 'package:desktopme/core/configs/assets/images_urls.dart';
import 'package:desktopme/core/configs/assets/app_icons.dart.dart';
import 'package:desktopme/feature/todo/domain/todo_model.dart';
import 'package:desktopme/feature/todo/presentation/widgets/delete_dailog.dart';
import 'package:desktopme/feature/todo/presentation/widgets/edit_add_dailog.dart';

class CardComponent extends StatelessWidget {
  final List<TodoModel> todoList;
  final void Function(int oldIndex, int newIndex)? onReorder;

  const CardComponent({
    super.key,
    required this.todoList,
    this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    if (todoList.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0).copyWith(top: 100),
          child: Column(
            children: [
              Image.asset(ImagesUrls.todoList, width: 120, height: 120),
              const SizedBox(height: 3),
              Text(
                'List is Empty',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return AnimationLimiter(
      child: ReorderableListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        buildDefaultDragHandles: false,
        itemCount: todoList.length,
        onReorder: onReorder ?? (_, __) {},
        itemBuilder: (context, index) {
          final todo = todoList[index];
          return ReorderableDelayedDragStartListener(
            index: index,
            key:ValueKey(todo.id) ,
            child: AnimationConfiguration.staggeredList(
              key: ValueKey(todo.id), // 👈 Required for reorderable items
              position: index,
              duration: const Duration(milliseconds: 400),
              child: SlideAnimation(
                verticalOffset: 44.0,
                child: FadeInAnimation(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 12.0,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title & Date Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              todo.title,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                            ),
                            Text(
                              'Date : ${formatDate(todo.createdAt)}',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
            
                        // Description
                        Text(
                          todo.description,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
            
                        // Status
                        Row(
                          children: [
                            const Text(
                              'Status  : ',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                            ),
                            Text(
                              todo.status,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: todo.status == 'Active'
                                    ? AppColors.lightBlack
                                    : AppColors.green,
                              ),
                            ),
                          ],
                        ),
            
                        // Edit / Delete Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              splashColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                             highlightColor: Colors.transparent,
                              
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => DeleteTaskDialog(
                                    id: todo.id.toString(),
                                    onSuccess: (msg) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(msg)),
                                      );
                                    },
                                  ),
                                );
                              },
                              child: SvgPicture.asset(AppIcons.deleteIcon, width: 28, height: 25),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => EditTaskDialog(
                                    todo: TodoModel(
                                      id: todo.id,
                                      title: todo.title,
                                      description: todo.description,
                                      status: todo.status,
                                      userId: todo.userId,
                                      createdAt: todo.createdAt,
                                      updatedAt: todo.updatedAt,
                                    ),
                                    onSuccess: (msg) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(msg)),
                                      );
                                    },
                                  ),
                                );
                              },
                              child: SvgPicture.asset(AppIcons.editIcon),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    final formatter = DateFormat("MMM d-yyyy");
    return formatter.format(parsedDate);
  }
}
