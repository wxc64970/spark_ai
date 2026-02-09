import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

import 'index.dart';
import 'widgets/widgets.dart';

class SaaigenerateimagePage extends GetView<SaaigenerateimageController> {
  const SaaigenerateimagePage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return const SAContentWidget();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SaaigenerateimageController>(
      builder: (_) {
        return GestureDetector(
          onTap: () {
            // 点击空白处关闭键盘
            Get.focusScope?.unfocus();
          },
          child: baseScaffold(body: _buildView()),
        );
      },
    );
  }
}
