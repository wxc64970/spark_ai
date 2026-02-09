import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

import 'index.dart';
import 'widgets/widgets.dart';

class SaaigeneratehistoryPage extends GetView<SaaigeneratehistoryController> {
  const SaaigeneratehistoryPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return const SAContextWidget();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SaaigeneratehistoryController>(
      builder: (_) {
        return baseScaffold(body: _buildView());
      },
    );
  }
}
