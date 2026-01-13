import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'index.dart';
import 'widgets/sa_content_widget.dart';

class SamePage extends StatefulWidget {
  const SamePage({Key? key}) : super(key: key);

  @override
  State<SamePage> createState() => _SamePageState();
}

class _SamePageState extends State<SamePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _SameViewGetX();
  }
}

class _SameViewGetX extends GetView<SameController> {
  const _SameViewGetX({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return const SaContentWidget();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SameController>(
      init: SameController(),
      id: "same",
      builder: (_) {
        return baseScaffold(body: _buildView());
      },
    );
  }
}
