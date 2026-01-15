import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class SamomentsPage extends StatefulWidget {
  const SamomentsPage({Key? key}) : super(key: key);

  @override
  State<SamomentsPage> createState() => _SamomentsPageState();
}

class _SamomentsPageState extends State<SamomentsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _SamomentsViewGetX();
  }
}

class _SamomentsViewGetX extends GetView<SamomentsController> {
  const _SamomentsViewGetX({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return const Center(
      child: Text("SamomentsPage"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SamomentsController>(
      init: SamomentsController(),
      id: "samoments",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("samoments")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
