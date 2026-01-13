import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

import 'index.dart';
import 'widgets/widgets.dart';

class SasearchPage extends GetView<SasearchController> {
  const SasearchPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return const SaContentWidget();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SasearchController>(
      builder: (_) {
        return GestureDetector(
          onTap: () {
            controller.focusNode.unfocus();
          },
          child: baseScaffold(body: _buildView()),
        );
      },
    );
  }
}
