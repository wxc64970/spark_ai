import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';
import 'widgets/widgets.dart';

class SaprofilePage extends GetView<SaprofileController> {
  const SaprofilePage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return const SAContentWidget();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SaprofileController>(
      builder: (_) {
        return Scaffold(body: _buildView());
      },
    );
  }
}
