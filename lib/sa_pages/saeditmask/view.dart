import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

import 'index.dart';
import 'widgets/widgets.dart';

class SaeditmaskPage extends GetView<SaeditmaskController> {
  const SaeditmaskPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return const SaContentWidget();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SaeditmaskController>(
      builder: (_) {
        return baseScaffold(body: _buildView());
      },
    );
  }
}
