import 'package:flutter/material.dart';
import 'package:spark_ai/saCommon/index.dart';

import 'widgets.dart';

class SAMsgContainerFactory {
  SAMsgContainerFactory._();

  static final Map<MessageSource, Widget Function(SAMessageModel)> _containerBuilders = {
    MessageSource.tips: (msg) => SATipItem(msg: msg),
    MessageSource.maskTips: (msg) => SATipItem(msg: msg),
    MessageSource.error: (msg) => SATipItem(msg: msg),
    MessageSource.welcome: (msg) => SATItem(msg: msg),
    MessageSource.scenario: (msg) => SATItem(msg: msg, title: "${SATextData.scenario}:"),
    MessageSource.intro: (msg) => SATItem(msg: msg, title: "${SATextData.intro}:"),
    MessageSource.sendText: (msg) => SATItem(msg: msg),
    MessageSource.text: (msg) => SATItem(msg: msg),
    MessageSource.photo: (msg) => SAImgItem(msg: msg),
    MessageSource.clothe: (msg) => SAImgItem(msg: msg),
    MessageSource.video: (msg) => SAVItem(msg: msg),
    MessageSource.audio: (msg) => SAAudItem(msg: msg, key: ValueKey(msg.id)),
  };

  /// 创建消息容器widget
  static Widget createContainer(MessageSource source, SAMessageModel msg) {
    final builder = _containerBuilders[source];
    return builder?.call(msg) ?? const SizedBox.shrink();
  }
}

class MessageItem extends StatelessWidget {
  const MessageItem({super.key, required this.msg});

  final SAMessageModel msg;

  MessageSource get source => msg.source;

  @override
  Widget build(BuildContext context) {
    return SAMsgContainerFactory.createContainer(source, msg);
  }
}
