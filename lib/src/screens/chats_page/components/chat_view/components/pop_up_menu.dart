import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/services.dart';
import 'package:sovchilar/src/service/socket/socket.dart';
import 'package:sovchilar/translations/locale_keys.g.dart';

class ChatPopupMenuButton extends StatefulWidget {
  const ChatPopupMenuButton(
      {super.key, required this.onPressedForm, required this.status});

  final VoidCallback onPressedForm;
  final String status;

  @override
  State<ChatPopupMenuButton> createState() => _ChatPopupMenuButtonState();
}

class _ChatPopupMenuButtonState extends State<ChatPopupMenuButton> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      padding: EdgeInsets.all(10.w),
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: widget.onPressedForm,
          child: Text(
            LocaleKeys.profile.tr(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        PopupMenuItem(
          child: Text(
            LocaleKeys.delChat.tr(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          onTap: ()  {
            SocketService socketService = SocketService();
            socketService.removeConversation();
            Navigator.pop(context);
          },
        ),
      ],
      position: PopupMenuPosition.under,
      constraints: BoxConstraints(minWidth: 25.w, minHeight: 20.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      color: Colors.white,
      elevation: 10,
      clipBehavior: Clip.antiAlias,
      child: Icon(Icons.more_vert_outlined),
    );
  }
}
