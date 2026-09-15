import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sovchilar/src/config/core/app_colors.dart';
import 'package:sovchilar/src/service/socket/socket.dart';
import 'package:sovchilar/translations/locale_keys.g.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final String messageId;
  final bool isMe;
  final bool isRead;
  final String timestamp;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.isRead,
    required this.timestamp, required this.messageId,
  });

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width * 0.75;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
        child: InkWell(
          onLongPress: () {
            if (isMe) showDeleteDialog(context,messageId);
          },
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: maxWidth,
            ),
            padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 12.w),
            decoration: BoxDecoration(
              color: isMe ? Colors.blue : Colors.grey[300],
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    message,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      formatTimeFromString(timestamp),
                      style: TextStyle(
                        color: isMe ? Colors.white70 : Colors.black54,
                      ),
                    ),
                    SizedBox(width: 2.h),
                    if (isMe)
                      Icon(
                        isRead ? Icons.done_all : Icons.check,
                        size: 16,
                        color: isRead ? Colors.white : Colors.grey[700],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String formatTimeFromString(String dateTimeString) {
  DateTime dateTime = DateTime.parse(dateTimeString);
  return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
}

void showDeleteDialog(BuildContext context,String messageId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          LocaleKeys.xabarDel.tr(),
          style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.secondary),
        ),
        content: Text(LocaleKeys.content.tr()),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(LocaleKeys.otmena.tr()),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              SocketService socketService = SocketService();
              socketService.deleteMessage(messageId);
              socketService.getConversationMessages();

              Navigator.of(context).pop();
            },
            child: Text(LocaleKeys.udalit.tr(), style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}
