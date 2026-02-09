import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';
import 'widgets/widgets.dart';

class SaaigenerateresultPage extends GetView<SaaigenerateresultController> {
  const SaaigenerateresultPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return const SAContentWidget();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SaaigenerateresultController>(
      builder: (_) {
        return Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          body: _buildView(),
        );
      },
    );
  }
}
