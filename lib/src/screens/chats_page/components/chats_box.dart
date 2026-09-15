import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sovchilar/src/config/core/app_colors.dart';

class ChatsBox extends StatefulWidget {
  const ChatsBox(
      {super.key,
      required this.onPressed,
      this.imageUrl,
      required this.name,
      required this.online,
      required this.lastMessage,
      required this.unreadMessagesCount});

  final VoidCallback onPressed;
  final String? imageUrl;
  final String name;
  final String? lastMessage;
  final int? unreadMessagesCount;
  final bool online;

  @override
  State<ChatsBox> createState() => _ChatsBoxState();
}

class _ChatsBoxState extends State<ChatsBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 3.h),
      child: SizedBox(
        width: 200.w,
        height: 60.h,
        child: ElevatedButton(
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: Colors.white,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
                side: BorderSide(color: AppColors.textFieldColor, width: 1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              16.horizontalSpace,
              Stack(
                children: [
                  CircleAvatar(
                    radius: 22.r,
                    backgroundColor: Colors.grey[100],
                    child: ClipOval(
                      child: widget.imageUrl == '' || widget.imageUrl == null
                          ? SizedBox(
                              width: 44.w,
                              height: 44.h,
                              child: Center(
                                  child: Text(
                                widget.name[0],
                                style: TextStyle(fontSize: 20.sp),
                              )),
                            )
                          : Image.network(
                              widget.imageUrl ?? "", // URL
                              fit: BoxFit.cover,
                              width: 44.w,
                              height: 44.h,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: Platform.isIOS
                                      ? CupertinoActivityIndicator() // iOS platformasida
                                      : CircularProgressIndicator(),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) =>
                                  SizedBox(
                                width: 44.w,
                                height: 44.h,
                                child: Center(
                                    child: Text(
                                  widget.name[0],
                                  style: TextStyle(fontSize: 20.sp),
                                )),
                              ),
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 1,
                    right: 1,
                    child: CircleAvatar(
                      radius: 6.r,
                      backgroundColor: widget.online
                          ? Colors.lightGreen
                          : AppColors.grey.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              20.horizontalSpace,
              SizedBox(
                width: 200.w,
                child: Text(
                  widget.name,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontSize: 20.sp),
                ),
              ),
              widget.unreadMessagesCount != null && widget.unreadMessagesCount != 0
                  ? CircleAvatar(
                      radius: 12.r,
                      child: Text(
                        widget.unreadMessagesCount.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: Colors.white, fontSize: 12.sp),
                      ),
                    )
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
