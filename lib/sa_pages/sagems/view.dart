import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

import 'index.dart';
import 'widgets/widgets.dart';

class SagemsPage extends GetView<SagemsController> {
  const SagemsPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return const SAContentWidget();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SagemsController>(
      builder: (_) {
        return baseScaffold(body: _buildView());
      },
    );
  }
}
