import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';
import 'widgets/widgets.dart';

class SatexttoimagePage extends GetView<SatexttoimageController> {
  const SatexttoimagePage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return const SAContextWidget();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SatexttoimageController>(
      builder: (_) {
        return Scaffold(
          backgroundColor: const Color(0xFFF7F7F7),
          body: _buildView(),
        );
      },
    );
  }
}
