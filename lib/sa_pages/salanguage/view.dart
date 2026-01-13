import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/sa_widgets/sa_base_scaffold.dart';

import 'index.dart';
import 'widgets/widgets.dart';

class SalanguagePage extends GetView<SalanguageController> {
  const SalanguagePage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return const SAContentWidget();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SalanguageController>(
      builder: (_) {
        return baseScaffold(body: _buildView());
      },
    );
  }
}
