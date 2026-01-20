import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/sa_widgets/index.dart';

import 'index.dart';
import 'widgets/widgets.dart';

class SaundrPage extends GetView<SaundrController> {
  const SaundrPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return const SaContentWidget();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SaundrController>(
      builder: (_) {
        return baseScaffold(body: _buildView());
      },
    );
  }
}
