import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';
import 'widgets/widgets.dart';

class SasubscribePage extends GetView<SasubscribeController> {
  const SasubscribePage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return const SaContentWidget();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SasubscribeController>(
      builder: (_) {
        return Scaffold(body: _buildView());
      },
    );
  }
}
