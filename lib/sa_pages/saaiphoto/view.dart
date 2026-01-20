import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/sa_widgets/sa_base_scaffold.dart';

import 'index.dart';
import 'widgets/sa_content_widget.dart';

class SaaiphotoPage extends StatefulWidget {
  const SaaiphotoPage({Key? key}) : super(key: key);

  @override
  State<SaaiphotoPage> createState() => _SaaiphotoPageState();
}

class _SaaiphotoPageState extends State<SaaiphotoPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _SaaiphotoViewGetX();
  }
}

class _SaaiphotoViewGetX extends GetView<SaaiphotoController> {
  const _SaaiphotoViewGetX({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return const SaContentWidget();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SaaiphotoController>(
      init: SaaiphotoController(),
      id: "saaiphoto",
      builder: (_) {
        return baseScaffold(body: _buildView());
      },
    );
  }
}
