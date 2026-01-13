import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

import 'index.dart';
import 'widgets/sa_content_widget.dart';

class SachatPage extends StatefulWidget {
  const SachatPage({Key? key}) : super(key: key);

  @override
  State<SachatPage> createState() => _SachatPageState();
}

class _SachatPageState extends State<SachatPage> with AutomaticKeepAliveClientMixin, RouteAware {
  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    RoutePages.observer.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    RoutePages.observer.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // 当其它页面 pop 回到本页面时被调用
    Get.find<SachatController>().refreshCurrentTabList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _SachatViewGetX();
  }
}

class _SachatViewGetX extends GetView<SachatController> {
  const _SachatViewGetX({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return const SaContentWidget();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SachatController>(
      init: SachatController(),
      id: "sachat",
      builder: (_) {
        return baseScaffold(body: _buildView());
      },
    );
  }
}
