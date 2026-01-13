import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

import 'index.dart';
import 'widgets/as_body.dart';

class SadiscoveryPage extends StatefulWidget {
  const SadiscoveryPage({Key? key}) : super(key: key);

  @override
  State<SadiscoveryPage> createState() => _SadiscoveryPageState();
}

class _SadiscoveryPageState extends State<SadiscoveryPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _SadiscoveryViewGetX();
  }
}

class _SadiscoveryViewGetX extends GetView<SadiscoveryController> {
  const _SadiscoveryViewGetX({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return const ASBodyWidget();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SadiscoveryController>(
      init: SadiscoveryController(),
      id: "sadiscovery",
      builder: (_) {
        return baseScaffold(body: _buildView());
      },
    );
  }
}
