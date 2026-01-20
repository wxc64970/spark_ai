import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/sa_widgets/index.dart';

import 'index.dart';
import 'widgets/widgets.dart';

class SaaiskuPage extends GetView<SaaiskuController> {
  const SaaiskuPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return const SAContentWidget();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SaaiskuController>(
      builder: (_) {
        return baseScaffold(body: _buildView());
      },
    );
  }
}
