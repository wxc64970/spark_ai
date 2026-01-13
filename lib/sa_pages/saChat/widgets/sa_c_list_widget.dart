import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:spark_ai/sa_pages/saChat/widgets/sa_c_con.dart';

import 'sa_b_list_widgetd.dart';
import 'sa_c_item.dart';

class ConversationListWidget extends BaseListView<SAConversationModel, ConversationController> {
  const ConversationListWidget({super.key, required super.controller});

  @override
  Widget buildList(BuildContext context, ScrollPhysics physics) {
    return ListView.separated(
      physics: physics,
      // padding: padding ?? const EdgeInsets.symmetric(vertical: 14),
      padding: EdgeInsets.zero,
      cacheExtent: cacheExtent,
      itemBuilder: (_, index) => buildItem(context, controller.dataList[index]),
      separatorBuilder: (_, index) => SizedBox(height: 16.w),
      itemCount: controller.dataList.length,
    );
  }

  Widget buildItem(BuildContext context, SAConversationModel item) {
    return ConversationItem(avatar: item.avatar ?? '', name: item.title ?? '', updateTime: item.updateTime, lastMsg: item.lastMessage ?? '-', onTap: () => controller.onItemTap(item));
  }
}
