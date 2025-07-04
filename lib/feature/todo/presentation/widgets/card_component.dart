// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:desktopme/core/configs/assets/app_icons.dart.dart';
import 'package:desktopme/core/configs/assets/images_urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:desktopme/core/configs/colors/app_colors.dart';
import 'package:desktopme/feature/todo/domain/todo_model.dart';
import 'package:desktopme/feature/todo/presentation/widgets/delete_dailog.dart';
import 'package:desktopme/feature/todo/presentation/widgets/edit_add_dailog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class CardComponent extends StatelessWidget {
  List<TodoModel> todoList;
  CardComponent({Key? key, required this.todoList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log('search off');
    return todoList.isEmpty
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0).copyWith(top: 100),
              child: Column(
                children: [
                  Image.asset(ImagesUrls.todoList, width: 120, height: 120),
                  SizedBox(height: 3),
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
          )
        : AnimationLimiter(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,

              itemCount: todoList.length,
              itemBuilder: (context, index) {
                final todo = todoList[index];
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 400),
                  child: SlideAnimation(
                    verticalOffset: 44.0,
                    child: FadeInAnimation(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        padding: EdgeInsets.all(16),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  todo.title,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                 'Date : ' +formatDate(todo.createdAt),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 2),
                            Text(
                              todo.description,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Status  : ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  '${todo.status}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: todo.status == 'Active'
                                        ? AppColors.lightBlack
                                        : AppColors.green,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => DeleteTaskDialog(
                                        id: todo.id.toString(),
                                        onSuccess: (msg) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(content: Text(msg)),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: SvgPicture.asset(AppIcons.deleteIcon,width: 28,height: 25,),
                                ),
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
                                          updatedAt: todo.createdAt,
                                          createdAt: todo.updatedAt,
                                        ),
                                        onSuccess: (msg) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
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
                );
              },
            ),
          );
  }

  String formatDate(String date) {
    final parsedDate = DateTime.parse(date); // Parses "2025-06-25"
    final formatter = DateFormat("MMM d-yyyy"); // Converts to "Jun 25-2025"
    return formatter.format(parsedDate);
  }
}
