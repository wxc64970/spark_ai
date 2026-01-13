import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spark_ai/saCommon/index.dart';

class ConversationItem extends StatelessWidget {
  const ConversationItem({super.key, this.onTap, required this.avatar, required this.name, this.updateTime, this.lastMsg, this.isLikes, this.handleCollect});

  final void Function()? onTap;
  final String avatar;
  final String name;
  final String? lastMsg;
  final int? updateTime;
  final bool? isLikes;
  final void Function()? handleCollect;

  String formatSessionTime(int timestamp) {
    DateTime messageTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateTime now = DateTime.now();
    final difference = now.difference(messageTime);
    String twoDigits(int n) {
      return n.toString().padLeft(2, '0');
    }

    if (difference.inHours < 24) {
      return '${twoDigits(messageTime.hour)}:${twoDigits(messageTime.minute)}';
    } else {
      return '${twoDigits(messageTime.month)}-${twoDigits(messageTime.day)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ButtonWidget(
      borderRadius: BorderRadius.circular(0),
      color: Colors.transparent,
      onTap: onTap,
      height: 152.w,
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(24.r), color: Colors.white),
        child: Row(
          spacing: 16.w,
          children: [
            SAImageWidget(url: avatar, width: 96.w, height: 96.w, cacheWidth: 100, cacheHeight: 100, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(24.r)),
            Expanded(
              child: isLikes == true
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Color(0xff222222), fontSize: 32.sp, fontWeight: FontWeight.w600),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  lastMsg ?? '-',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Color(0xFF999999), fontSize: 28.sp, fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              formatSessionTime(updateTime ?? DateTime.now().millisecondsSinceEpoch),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Color(0xFF999999), fontSize: 24.sp, fontWeight: FontWeight.w400),
                            ),
                            SizedBox(height: 17.w),
                            InkWell(
                              onTap: handleCollect,
                              child: Image.asset("assets/images/sa_04.png", width: 40.w, fit: BoxFit.contain),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Color(0xff080817), fontSize: 28.sp, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(
                              formatSessionTime(updateTime ?? DateTime.now().millisecondsSinceEpoch),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Color(0xFF797C7B), fontSize: 24.sp, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        Text(
                          lastMsg ?? '-',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Color(0xFF797C7B), fontSize: 24.sp, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
