import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

class SAFloItem extends StatelessWidget {
  const SAFloItem({super.key, required this.role, required this.sessionId});

  final ChaterModel role;
  final int sessionId;

  @override
  Widget build(BuildContext context) {
    if (role.videoChat == true) return _buildVideoItem();
    return const SizedBox();
  }

  void _onTapPhoneVideo() {
    SAlogEvent('c_videocall');
    Get.toNamed(SARouteNames.phoneGuide, arguments: {'role': role});
  }

  Widget _buildVideoItem() {
    final guide = role.characterVideoChat?.firstWhereOrNull((e) => e.tag == 'guide');
    final url = guide?.gifUrl ?? role.avatar;

    return GestureDetector(
      onTap: _onTapPhoneVideo,
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SAImageWidget(
              url: url,
              width: 64,
              height: 64,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
          Image.asset('assets/images/videocall.png', width: 20, height: 20),
        ],
      ),
    );
  }
}
